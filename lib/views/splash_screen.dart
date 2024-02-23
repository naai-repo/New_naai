import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/views/post_auth/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: ColorsConstant.appColor),
    );
    checkIfUserExists();
  }


  void checkIfUserExists() {
    Timer(const Duration(seconds: 2), () async {
      String? accessToken = await context.read<AuthenticationProvider>().getAccessToken();
      if(!context.mounted) return;
      
      bool isGuest = await context.read<AuthenticationProvider>().getIsGuest();
      if(!context.mounted) return;

      await context.read<LocationProvider>().intit();
      if(!context.mounted) return;

      print("Auth Data : $accessToken - $isGuest");
     
      if (accessToken.isNotEmpty) {
          String userId = await context.read<AuthenticationProvider>().getUserId();
          if(!context.mounted) return;

          await AuthenticationConroller.setUserDetails(context, userId);
          if(!context.mounted) return;

          Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
      }else if (isGuest){
          Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
      } else {
          Navigator.pushReplacementNamed(context,NamedRoutes.authenticationRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: ColorsConstant.appColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImagePathConstant.splashLogo),
            SizedBox(height: 2.h),
            Text(
              StringConstant.splashScreenText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
