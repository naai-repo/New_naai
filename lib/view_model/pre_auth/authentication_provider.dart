import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naai/models/user.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

import '../../utils/access_token.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isGetOtpButtonActive = false;
  bool _isVerifyOtpButtonActive = false;
  bool _isOtpLoaderActive = false;
  bool _isUsernameButtonActive = false;

  String _verificationId = "";
  String _enteredOtp = "000000";
  String? _phoneNumber;
  String? _userId;
  String _selectedGender = '';
  DateTime?  _logintime;


  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _otpDigitOneController = TextEditingController();
  TextEditingController _otpDigitTwoController = TextEditingController();
  TextEditingController _otpDigitThreeController = TextEditingController();
  TextEditingController _otpDigitFourController = TextEditingController();
  TextEditingController _otpDigitFiveController = TextEditingController();
  TextEditingController _otpDigitSixController = TextEditingController();

  bool get isGetOtpButtonActive => _isGetOtpButtonActive;
  bool get isVerifyOtpButtonActive => _isVerifyOtpButtonActive;
  bool get isOtpLoaderActive => _isOtpLoaderActive;
  bool get isUsernameButtonActive => _isUsernameButtonActive;

  String get verificationId => _verificationId;
  String get enteredOtp => _enteredOtp;
  String get selectedGender => _selectedGender;
  String? get userId => _userId;

  TextEditingController get userNameController => _userNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get mobileNumberController => _mobileNumberController;
  TextEditingController get otpDigitOneController => _otpDigitOneController;
  TextEditingController get otpDigitTwoController => _otpDigitTwoController;
  TextEditingController get otpDigitThreeController => _otpDigitThreeController;
  TextEditingController get otpDigitFourController => _otpDigitFourController;
  TextEditingController get otpDigitFiveController => _otpDigitFiveController;
  TextEditingController get otpDigitSixController => _otpDigitSixController;

  /// Method to trigger the social login flow depending upon which social login method is chosen


  /// Triggers Google authentication flow


  Future<String> getGender(GoogleSignInAccount googleSignIn) async {
    final headers = await googleSignIn.authHeaders;
    final r = await http.get(
      Uri.parse(
          "https://people.googleapis.com/v1/people/me?personFields=genders&key="),
      headers: {
        "Authorization": '${headers["Authorization"]}',
      },
    );
    final response = jsonDecode(r.body);
    return response["genders"][0]["formattedValue"];
  }

  /// Triggers Apple authentication flow
  Future<void> appleLogin(BuildContext context) async {
    if (Platform.isIOS) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).onError((error, stackTrace) {
        throw Exception('$error');
      });
      print(
          "Apple credential ===>\nEmail - ${credential.email}\nid_Token - ${credential.identityToken}\nAuthorization code - ${credential.authorizationCode}\nUser identifier - ${credential.userIdentifier}");
    }

  }




  /// Method to set user's gender
  void setGender(String value) {
    _selectedGender = value;
    setUsernameButtonActive();
    notifyListeners();
  }

  /// Method to check the validity of mobile number
  void setIsGetOtpButtonActive(String value) {
    _isGetOtpButtonActive = value.length == 10;
    notifyListeners();
  }

  /// Set the retrieved [_verificationId]. If nothing is sent, the [_verificationId] will
  /// be reset to an empty [String]
  void setVerificationId({
    String value = "",
    bool resetVerificationId = false,
  }) {
    resetVerificationId ? _verificationId = "" : _verificationId = value;
    notifyListeners();
  }

  /// Check if the entered username is valid and set the value of [_isUsernameButtonActive]
  void setUsernameButtonActive() {
    _isUsernameButtonActive = _userNameController.text.trim().length > 0 &&
        _selectedGender.isNotEmpty;
    notifyListeners();
  }

  /// Set the otp string as the user enters the otp digits
  void setOtp({required int index, required String digit}) {
    bool didDeleteDigit = digit == "";
    digit = digit == "" ? "0" : digit;

    _enteredOtp = _enteredOtp.substring(0, index) +
        digit +
        _enteredOtp.substring(index + 1);

    // Change the focus to next otp text box if the user has typed something in the otp box
    if (!didDeleteDigit) {
      if (index != 5) {
        FocusManager.instance.primaryFocus!.nextFocus();
      } else {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      if (index != 0) {
        FocusManager.instance.primaryFocus!.previousFocus();
      } else {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }

    _isVerifyOtpButtonActive = (otpDigitOneController.text.isNotEmpty &&
        otpDigitTwoController.text.isNotEmpty &&
        otpDigitThreeController.text.isNotEmpty &&
        otpDigitFourController.text.isNotEmpty &&
        otpDigitFiveController.text.isNotEmpty &&
        otpDigitSixController.text.isNotEmpty);
    notifyListeners();
  }




  /// Save the [_userId] after authentication in [SharedPreferences]
  /// and in [AuthenticationProvider]
  void setUserId({required String? userId}) async {
    _userId = userId;
    await SharedPreferenceHelper.setUserId(userId ?? '');
  }
  void handleLogoutClick(BuildContext context ) async {
    // Delete the access token
    await AccessTokenManager.removeAccessToken();
    // Navigate to the splash screen
    resetMobielNumberController();
    resetOtpControllers();
    Navigator.pushReplacementNamed(
      context,
      NamedRoutes.splashRoute,
    );
  }



  /// Reset the value of [_mobileNumberController] and [_isGetOtpButtonActive]
  void resetMobielNumberController() {
    _mobileNumberController.clear();
    _isGetOtpButtonActive = false;
    notifyListeners();
  }

  /// Reset otp text controllers and [_isVerifyOtpButtonActive]
  void resetOtpControllers() {
    _otpDigitOneController.clear();
    _otpDigitTwoController.clear();
    _otpDigitThreeController.clear();
    _otpDigitFourController.clear();
    _otpDigitFiveController.clear();
    _otpDigitSixController.clear();
    _isVerifyOtpButtonActive = false;
    notifyListeners();
  }

  /// Clear the value of [_userNameController]
  void clearUsernameController() {
    _userNameController.clear();
    _selectedGender = '';
    notifyListeners();
  }
}
