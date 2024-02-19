import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/auth/mobile_otp_model.dart';
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


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool buttonStatus = false;
  final textController = TextEditingController();
  late String mobileNumber;

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );
    mobileNumber = context.read<AuthenticationProvider>().mobileNumber.toString();
  }

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<AuthenticationProvider>(context,listen: false);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.1.h), // Adjust the height as needed
          child: AppBar(
            elevation: 0,
            backgroundColor: ColorsConstant.appColor,
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(ImagePathConstant.loginScreen,fit: BoxFit.fill),
                          SizedBox(height: 40.h),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                                StringConstant.loginSignup,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          SizedBox(height: 10.h),
                          mobileNumberTextField(),
                          SizedBox(height: 20.h),
                          Padding(
                            padding:EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
                              child: CustomButtons.redFullWidthButton(
                                buttonText: StringConstant.getOtp,
                                onTap: () async {
                                  try {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    mobileNumber = textController.text;
                                    if(mobileNumber.length != 10) throw ErrorDescription("Invalid Mobile Number");
                                    
                                    Loading.showLoding(context);
                                    await Future.delayed(const Duration(seconds: 2));
                                    GetOTPModel loginResult = await LoginController.login(mobileNumber);
                                    
                          

                                    if (loginResult.status == 'pending'){
                                      await ref.setUserId(loginResult.data.userId);
                                      ref.setMobileNumber(int.parse(mobileNumber));
                                      
                                      ref.setGetOTP(loginResult);
                                      if(context.mounted){
                                          Loading.closeLoading(context);
                                          Future.delayed(Durations.short1,() => Navigator.pushNamed(context, NamedRoutes.verifyOtpRoute));
                                      }
                                    }else{
                                       throw ErrorDescription(loginResult.message);
                                    }
                                  } catch (e) {
                                    print("AuthScreen Error : ${e.toString()}");
                                    if(context.mounted){
                                        Loading.closeLoading(context);
                                        showErrorSnackBar(context, e.toString());
                                    }
                                  }
                                },
                                isActive: buttonStatus,
                              ),
                          ),
                          SizedBox(height: 40.h),
                            authenticationOptionsDivider(),
                            SizedBox(height: 40.h),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () async{
                                     await context.read<AuthenticationProvider>().setIsGuest(true);
                                     if(context.mounted){
                                      Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
                                     }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  child: const Text(StringConstant.continueguest,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  
                  ],
                ),
              ),
            ),
      
      );
  }



  Widget authenticationOptionsDivider() {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.w),
       Expanded(
          child: Divider(
            thickness: 2.sp,
            color: ColorsConstant.divider,
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
            thickness: 2.0.sp,
            color: ColorsConstant.divider,
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget mobileNumberTextField() {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
              child: TextFormField(
                controller: textController,
                keyboardType: TextInputType.phone,
                cursorColor: ColorsConstant.appColor,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                onChanged: (value){
                  if (value.length == 10) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                  setState((){
                      buttonStatus = (value.length == 10);
                  });
                },
                style: TextStyle(
                  fontSize: 16.sp,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w500,
                ),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
                  filled: true,
                  fillColor: ColorsConstant.appColorAccent,
                  hintText: StringConstant.enterMobileNumber,
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    color: ColorsConstant.enterMobileTextColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  counterText: '',
                ),
              ),
            );
  }
  
}