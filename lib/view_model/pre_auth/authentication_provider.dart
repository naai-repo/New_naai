import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naai/services/database.dart';
import 'package:naai/view/utils/loading_indicator.dart';
import 'package:naai/view/utils/routing/named_routes.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isGetOtpButtonActive = false;
  bool _isVerifyOtpButtonActive = false;
  bool _isOtpLoaderActive = false;
  bool _isUsernameButtonActive = false;

  String _verificationId = "";
  String _enteredOtp = "000000";
  String? _phoneNumber;

  TextEditingController _userNameController = TextEditingController();
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

  TextEditingController get userNameController => _userNameController;
  TextEditingController get mobileNumberController => _mobileNumberController;
  TextEditingController get otpDigitOneController => _otpDigitOneController;
  TextEditingController get otpDigitTwoController => _otpDigitTwoController;
  TextEditingController get otpDigitThreeController => _otpDigitThreeController;
  TextEditingController get otpDigitFourController => _otpDigitFourController;
  TextEditingController get otpDigitFiveController => _otpDigitFiveController;
  TextEditingController get otpDigitSixController => _otpDigitSixController;

  /// Method to trigger the social login flow depending upon which social login method is chosen
  void socialLogin({
    required bool isGoogle,
    required BuildContext context,
  }) async {
    Loader.showLoader(context);
    try {
      isGoogle ? await googleLogIn(context) : await appleLogin(context);
      Loader.hideLoader(context);
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamed(context, NamedRoutes.navigationBar);
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Triggers Google authentication flow
  Future<void> googleLogIn(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleUser = GoogleSignIn().currentUser ??
        await GoogleSignIn(scopes: <String>['email'])
            .signIn()
            .onError((error, stackTrace) {
          throw Exception('Something went wrong!');
        });

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? user = (await FirebaseAuth.instance
            .signInWithCredential(credential)
            .onError((error, stackTrace) {
      throw Exception('Something went wrong!');
    }))
        .user;

    final currentUser = FirebaseAuth.instance.currentUser;

    final _token =
        await currentUser?.getIdToken(true).onError((error, stackTrace) {
      throw Exception('Something went wrong!');
    });
    await DatabaseService(uid: user!.uid)
        .setUserData(name: user.displayName, gmailId: user.email);

    print("Id token ===> $_token");
    notifyListeners();
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
        print(error);
        throw Exception('$error');
      });

      print(
          "Apple credential ===>\nEmail - ${credential.email}\nid_Token - ${credential.identityToken}\nAuthorization code - ${credential.authorizationCode}\nUser identifier - ${credential.userIdentifier}");
    }
  }

  /// Method to verify phone number authentication
  void phoneNumberLogin(BuildContext context) async {
    _isOtpLoaderActive = true;
    notifyListeners();
    try {
      _phoneNumber = "+91${_mobileNumberController.text}";

      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseException e) {
          _isOtpLoaderActive = false;
          notifyListeners();
          if (e.message!.contains('too-many-requests')) {
            ReusableWidgets.showFlutterToast(
              context,
              'OTP generated too many times. Please wait before trying again!',
            );
          } else {
            ReusableWidgets.showFlutterToast(
              context,
              '${e.message}',
            );
          }
        },
        codeSent: (String verificationId, int? resendCode) {
          setVerificationId(value: verificationId);
          resetOtpControllers();
          _isOtpLoaderActive = false;
          notifyListeners();
          Navigator.pushNamed(context, NamedRoutes.verifyOtpRoute);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .onError((error, stackTrace) {
        throw Exception('$error');
      });
    } catch (e) {
      _isOtpLoaderActive = false;
      notifyListeners();
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Verify the OTP entered by user.
  void verifyOtp(BuildContext context) async {
    Loader.showLoader(context);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _enteredOtp,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .onError((error, stackTrace) {
        print('$error');
        throw Exception('$error');
      });

      resetMobielNumberController();
      resetOtpControllers();

      User? user = FirebaseAuth.instance.currentUser;

      await DatabaseService(uid: user!.uid)
          .setUserData(phoneNumber: _phoneNumber);

      Loader.hideLoader(context);
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, NamedRoutes.addUserNameRoute);
      }
    } catch (e) {
      Loader.hideLoader(context);
      print('ERROR \t $e');
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Update user name of the user in the Firebase collection
  void updateUserNameInCollection(BuildContext context) async {
    Loader.showLoader(context);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await DatabaseService(uid: user!.uid).updateUserData(data: {
        'name': _userNameController.text.trim(),
      });
      _userNameController.clear();
      Loader.hideLoader(context);
      Navigator.pushReplacementNamed(context, NamedRoutes.navigationBar);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
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
  void isUsernameValid() {
    _isUsernameButtonActive = _userNameController.text.trim().length > 0;
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
    }

    _isVerifyOtpButtonActive = (otpDigitOneController.text.isNotEmpty &&
        otpDigitTwoController.text.isNotEmpty &&
        otpDigitThreeController.text.isNotEmpty &&
        otpDigitFourController.text.isNotEmpty &&
        otpDigitFiveController.text.isNotEmpty &&
        otpDigitSixController.text.isNotEmpty);
    notifyListeners();
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
}
