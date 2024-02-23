import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/auth/otp_service.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  bool buttonStatus = false;
  TextEditingController otpDigitOneController = TextEditingController();
  TextEditingController otpDigitTwoController = TextEditingController();
  TextEditingController otpDigitThreeController = TextEditingController();
  TextEditingController otpDigitFourController = TextEditingController();
  TextEditingController otpDigitFiveController = TextEditingController();
  TextEditingController otpDigitSixController = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    otpDigitOneController.dispose();
    otpDigitTwoController.dispose();
    otpDigitThreeController.dispose();
    otpDigitFourController.dispose();
    otpDigitFiveController.dispose();
    otpDigitSixController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<AuthenticationProvider>(context,listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: IconButton(
            onPressed: () {
             Navigator.pop(context);
            },
            splashRadius: 0.1,
            splashColor: Colors.transparent,
            icon: SvgPicture.asset(
              ImagePathConstant.backArrowIos,
            ),
          ),
          centerTitle: false,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringConstant.enterVerificationCode,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  children: [
                    Text(
                      StringConstant.enterOtpSubtext,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorsConstant.lightGreyText,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      '+91-${ref.mobileNumber}',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                otpTextBoxRow(),
                CustomButtons.redFullWidthButton(
                  buttonText: StringConstant.verifyNumber,
                  onTap: () async {
                    try {
                        String userId = ref.authData.getOtpData?.data.userId ?? "";
                        String otp = ref.authData.getOtpData?.data.otp ?? "";
                        String enteredOtp = otpDigitOneController.text + otpDigitTwoController.text + otpDigitThreeController.text + otpDigitFourController.text +
                                           otpDigitFiveController.text +
                                           otpDigitSixController.text;

                        if(enteredOtp.isEmpty) return;
                        
                        Loading.showLoding(context);

                        final response = await LoginController.verifyOtp(userId, otp);

                        if (response.status == 'success') {

                          await ref.setAccessToken(response.data.accessToken ?? "");
                          await ref.setIsGuest(false);
                          
                          final bool isNewUser = response.data.newUser ?? false;

                          print('IsNewUser: $isNewUser');
                          
                          if(!context.mounted) return;

                          if (isNewUser) {
                            Navigator.pushReplacementNamed(context,NamedRoutes.addUserNameRoute);

                          } else {
                            await AuthenticationConroller.setUserDetails(context, userId);
                            if(!context.mounted) return;
                            
                            Navigator.pushReplacementNamed(context,NamedRoutes.bottomNavigationRoute);
                          }
                        } else {
                          throw ErrorDescription(response.message);
                        }
                    } catch (error) {
                        print('Error During OTP verification: $error');

                        Loading.closeLoading(context);
                        if(context.mounted){
                          showErrorSnackBar(context, error.toString());
                        }
                    }
                  },
                  isActive: buttonStatus,
                ),
              ],

            ),
          ),
        ),
      );
  }

  Widget otpTextBoxRow() {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            otpTextBox(
              controller: otpDigitOneController,
              onChanged: (value) => changeValue(0, value),
            ),
            otpTextBox(
              controller: otpDigitTwoController,
              onChanged: (value) => changeValue(1, value),
            ),
            otpTextBox(
              controller: otpDigitThreeController,
              onChanged: (value) => changeValue(2, value),
            ),
            otpTextBox(
              controller: otpDigitFourController,
              onChanged: (value) => changeValue(3, value),
            ),
            otpTextBox(
              controller: otpDigitFiveController,
              onChanged: (value) => changeValue(4, value),
            ),
            otpTextBox(
              controller: otpDigitSixController,
              onChanged: (value) => changeValue(5, value),
            ),
          ],
        ),
      );
    });
  }

  Widget otpTextBox({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: 60.h,
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        cursorColor: ColorsConstant.appColor,
        keyboardType: TextInputType.phone,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsConstant.appColorAccent,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorsConstant.appColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
  
  void changeValue(int index,String value){
      if (value.isNotEmpty) {
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

      setState(() {
         buttonStatus = otpDigitOneController.text.isNotEmpty &&
                        otpDigitTwoController.text.isNotEmpty &&
                        otpDigitThreeController.text.isNotEmpty &&
                        otpDigitFourController.text.isNotEmpty &&
                        otpDigitFiveController.text.isNotEmpty &&
                        otpDigitSixController.text.isNotEmpty;
      });
  }

}