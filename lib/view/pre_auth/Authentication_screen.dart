import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../controller/login_controller.dart';
import '../../models/login_model.dart';
import '../../utils/loading_indicator.dart';
import '../../utils/no_internet.dart';
import '../../utils/routing/named_routes.dart';
import 'package:naai/view_model/pre_auth/loginResult.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform your actions before closing the app (if any)
        // You can add conditions here if you want to handle back press differently
        SystemNavigator.pop(animated: true);
        return true; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.1.h), // Adjust the height as needed
          child: AppBar(
            elevation: 0,
            backgroundColor: ColorsConstant.appColor,

          ),
        ),
        backgroundColor: Colors.white,
        body: Consumer<AuthenticationProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
                  children: <Widget>[
                    Column(
                        children: <Widget>[
                          Container(
                            width: 70.h,
                            decoration: BoxDecoration(
                              color: ColorsConstant.appColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
                                bottomRight: Radius.circular(20.0), // Adjust the radius as needed
                              ),
                            ),
                            child: SvgPicture.asset(
                              ImagePathConstant.loginScreen,
                              height: 50.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 4.h),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 2.w),
                            child: Align(
                              alignment:Alignment.topLeft,
                              child: Text(
                                StringConstant.loginSignup,
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          mobileNumberTextField(),
                          SizedBox(height: 4.h),
                          Padding(
                         padding:EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.1.h),
                            child: ReusableWidgets.redFullWidthButton(
                              buttonText: StringConstant.getOtp,
                              onTap: () async {
                                FocusManager.instance.primaryFocus!.unfocus();
                                final loginModel = LoginModel(
                                  phoneNumber: provider.mobileNumberController
                                      .text,
                                );
                                final loginResult = await LoginController().login(loginModel, context);
                                if (loginResult['status'] == 'success') {
                                  final box = await Hive.openBox('userBox');
                                  box.put('userId', loginResult['userId']);
                                  Provider.of<LoginResultProvider>(context, listen: false).setLoginResult(loginResult);

                                  Navigator.pushReplacementNamed(
                                    context,
                                    NamedRoutes.verifyOtpRoute,
                                  );
                                }
                              },
                              isActive: provider.isGetOtpButtonActive,
                            ),
                          ),
                          SizedBox(height: 4.h),
                            authenticationOptionsDivider(),
                            SizedBox(height: 4.h),
                            TextButton(
                              onPressed: ()  async{
                              await saveIsGuestStatus(true);
                              Navigator.pushReplacementNamed(
                                  context,
                                  NamedRoutes.bottomNavigationRoute2,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.1,
                                ),
                                child:Text(StringConstant.Continueguest,
                                  style: TextStyle(color: Colors.grey,
                                    fontSize: 10.5.sp,

                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                    if (provider.isOtpLoaderActive)
                      Container(
                        height: 80.h,
                        width: 100.h,
                        color: Colors.white.withOpacity(0.3),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Future<void> saveIsGuestStatus(bool isGuest) async {
    final box = await Hive.openBox('userBox');
    box.put('isGuest', isGuest);
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

  Widget mobileNumberTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return Padding(
       padding:   EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.1.h),
          child: TextFormField(
            controller: provider.mobileNumberController,
            keyboardType: TextInputType.phone,
            cursorColor: ColorsConstant.appColor,
            maxLength: 10,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
            ],
            onChanged: (value) {
              if (value.length == 10) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
              provider.setIsGetOtpButtonActive(value);
            },
            style: TextStyle(
              fontSize: 12.sp,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w500,
            ),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.2.h),
              filled: true,
              fillColor: ColorsConstant.appColorAccent,
              hintText: StringConstant.enterMobileNumber,
              hintStyle: TextStyle(
                fontSize: 12.sp,
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
          ),
        );
      },
    );
  }
}