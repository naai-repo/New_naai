import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/update_user_controller.dart';
import '../../utils/routing/named_routes.dart';
import '../../view_model/pre_auth/loginResult.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: IconButton(
            onPressed: () {
              provider.clearUsernameController();
              Navigator.pushReplacementNamed(
                context,
                NamedRoutes.authenticationRoute,
              );
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
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    StringConstant.addName,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    StringConstant.addNameSubtext,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.textLight,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  userNameTextField(),
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          StringConstant.Optional,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: ColorsConstant.textLight,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          StringConstant.chooseYourGender,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: ColorsConstant.textLight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: <Widget>[
                            genderSelector(
                              text: StringConstant.male,
                              isSelected:
                                  provider.selectedGender == StringConstant.male,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            genderSelector(
                              text: StringConstant.female,
                              isSelected: provider.selectedGender ==
                                  StringConstant.female,
                            ),
                          ],
                        ),
                    SizedBox(height: 3.h),
                    authenticationOptionsDivider(),
                    Text(
                    StringConstant.Optional,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.textLight,
                    ),
                  ),
                        SizedBox(height: 3.h),
                        emailTextField(),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  ReusableWidgets.redFullWidthButton(
                    buttonText: StringConstant.continueText,
                    onTap: () async {
                       try {
                         final loginResult = Provider.of<LoginResultProvider>(context, listen: false).loginResult;
                         final userId = loginResult?['userId'];
                         final name = provider.userNameController.text;
                        final gender = provider.selectedGender;
                        final email = provider.emailController.text;
                        final userData = {
                          'name': name,
                          'gender': gender,
                          'email': email,
                        };
                        final updateController = UpdateUserController();
                        final response = await updateController.updateUser(userId, userData, context);

                        if (response.status == 'success') {
                          Navigator.pushReplacementNamed(
                            context,
                            NamedRoutes.bottomNavigationRoute,
                          );
                        } else {
                          // Handle update user failure, show an error message or perform any other actions
                          print('Update user failed: ${response.message}');
                          ReusableWidgets.showFlutterToast(context, 'Update user failed: ${response.message}');
                        }
                      } catch (error) {
                        print('Error during update user: $error');
                        // Handle error, show an error message or perform any other actions
                        ReusableWidgets.showFlutterToast(context, 'Error during update user');
                      }
                    },
                    isActive: provider.isUsernameButtonActive,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget authenticationOptionsDivider() {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.w),
        Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            StringConstant.or,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }
  Widget genderSelector({
    required String text,
    bool isSelected = false,
  }) {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => provider.setGender(text),
          child: Row(
            children: <Widget>[
              Container(
                height: 2.5.h,
                width: 2.5.h,
                margin: EdgeInsets.only(right: 5.w),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    width: 1.5,
                    color: const Color(0xFF344054),
                  ),
                ),
                child: Visibility(
                  visible: isSelected,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsConstant.appColor,
                    ),
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF344054),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget userNameTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: provider.userNameController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          cursorColor: ColorsConstant.appColor,
          maxLength: 20,
          onChanged: (value) => provider.setUsernameButtonActive(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp('[0-9]'))
          ],
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterYourName,
            hintStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: ColorsConstant.enterMobileTextColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            counterText: '',
          ),
        );
      },
    );
  }

  Widget emailTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: provider.emailController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.emailAddress,
          cursorColor: ColorsConstant.appColor,
          maxLength: 20,
          onChanged: (value) => provider.setUsernameButtonActive(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp('[0-9]'))
          ],
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterYourEmail,
            hintStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: ColorsConstant.enterMobileTextColor,),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            counterText: '',
          ),
        );
      },
    );
  }
}
