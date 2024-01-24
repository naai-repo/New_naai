import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utils/access_token.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }

  void checkIfUserExists() {
    Timer(const Duration(seconds: 2), () async {
      String? accessToken = await AccessTokenManager.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          NamedRoutes.bottomNavigationRoute,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          NamedRoutes.authenticationRoute,
        );
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
          children: <Widget>[
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
