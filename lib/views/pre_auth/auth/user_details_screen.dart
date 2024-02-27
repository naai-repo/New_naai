import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';

class UserDetailsEnterScreen extends StatefulWidget {
  const UserDetailsEnterScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsEnterScreen> createState() => _UserDetailsEnterScreenState();
}

class _UserDetailsEnterScreenState extends State<UserDetailsEnterScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String genderSelected = "none";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
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
              Navigator.pushReplacementNamed(context,NamedRoutes.authenticationRoute);
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstant.addName,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    StringConstant.addNameSubtext,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsConstant.textLight,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  userNameTextField(),
                
                    SizedBox(height: 10.h),
                    authenticationOptionsDivider(),
                    // SizedBox(height: 10.h),
                    // Text(
                    //   StringConstant.Optional,
                    //   style: TextStyle(
                    //     fontSize: 14.sp,
                    //     color: ColorsConstant.textLight,
                    //   ),
                    // ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${StringConstant.chooseYourGender} ${StringConstant.Optional}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsConstant.textLight,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        
                        Row(
                          children: [
                            genderSelector(
                              text: StringConstant.male,
                              isSelected: genderSelected == StringConstant.male,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            genderSelector(
                              text: StringConstant.female,
                              isSelected: genderSelected == StringConstant.female,
                            ),
                          ],
                        ),
                    
                      SizedBox(height: 10.h),
                      emailTextField(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 25.h),
                  CustomButtons.redFullWidthButton(
                    buttonText: StringConstant.continueText,
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      try {
                        Loading.showLoding(context);
                        String userId = await ref.getUserId();
                        await UserServices.updateUserByID(userId: userId, name: _nameTextController.text, gender: genderSelected, email: _emailTextController.text);
                        if(!context.mounted) return;

                        await AuthenticationConroller.setUserDetails(context, userId);
                        if(!context.mounted) return;
                        
                        
                        Future.delayed(Durations.medium1,(){
                          Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
                        });
                  
                      } catch (e) {
                         if(context.mounted){
                            showErrorSnackBar(context, "Something Went Wrong");
                         }
                      }finally{
                        if(context.mounted){
                          Loading.closeLoading(context);
                        }
                      }
                    },
                    isActive: (_nameTextController.text.isNotEmpty),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget authenticationOptionsDivider() {
    return Row(
      children: [
        SizedBox(width: 10.w),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            StringConstant.or,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget genderSelector({required String text,bool isSelected = false}) {

    return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async{ 
             setState(() {
                genderSelected = text;
             });
          },
          child: Row(
            children: [
              Radio(
                value: isSelected ? 1 : 0, 
                groupValue: 1, 
                activeColor: ColorsConstant.appColor,
                onChanged: (v){
                   setState(() {
                        genderSelected = text;
                   });
                }
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
            ],
          ),
        );
  }

  Widget userNameTextField() {
    return TextFormField(
          controller: _nameTextController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          cursorColor: ColorsConstant.appColor,
          maxLength: 20,
          onChanged: (value){
             setState(() {});
          },
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[0-9]'))
          ],
          style: TextStyle(
            fontSize: 16.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterYourName,
            hintStyle: TextStyle(
              fontSize: 16.sp,
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
  }

  Widget emailTextField() {
    return TextFormField(
          controller: _emailTextController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.emailAddress,
          cursorColor: ColorsConstant.appColor,
          onChanged: (value) => {},
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp('[0-9]'))
          ],
          style: TextStyle(
            fontSize: 16.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: "${StringConstant.enterYourEmail} ${StringConstant.Optional}",
            hintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: ColorsConstant.enterMobileTextColor
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            counterText: '',
          ),
        );
  }

}