import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';

class SignInContainer extends StatelessWidget {
  final String text;
  const SignInContainer({super.key,this.text = "Please create your account to see your profile"});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/app_logo.png",
                  height: 80.h,
                  width: 80.w,
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                  fontSize: 16.sp),
                ),
              ),
              SizedBox(height:20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const StadiumBorder(),
                          ),
                        ),
                      onPressed: () async {
                          await AuthenticationConroller.logout(context);
                      },
                      child: const Text("SIGN IN", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}