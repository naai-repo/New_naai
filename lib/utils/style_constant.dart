import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StyleConstant {
  static TextStyle headingTextStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  );

  static TextStyle greySemiBoldTextStyle = TextStyle(
    color: ColorsConstant.greySalonAddress,
    fontWeight: FontWeight.w500,
  );

  static TextStyle searchTextStyle = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle appColorBoldTextStyle = TextStyle(
    color: ColorsConstant.appColor,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textLight11sp400Style = TextStyle(
    fontSize: 11.sp,
    color: ColorsConstant.textLight,
  );

  static TextStyle textDark12sp600Style = TextStyle(
    fontSize: 12.sp,
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textDark11sp600Style = TextStyle(
    fontSize: 11.sp,
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textDark12sp500Style = TextStyle(
    fontSize: 12.sp,
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w500,
  );
  static TextStyle textDark12sp500StyleLineThrough = TextStyle(
    fontSize: 12.sp,
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w500,
      decoration: TextDecoration.lineThrough
  );

  static TextStyle textDark15sp600Style = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15.sp,
    color: ColorsConstant.textDark,
  );

  static TextStyle bookingDateTimeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle userProfileOptionsStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
  );

  static InputDecoration searchBoxInputDecoration(
    BuildContext context, {
    required String hintText,
  }) =>
      InputDecoration(
        filled: true,
        fillColor: ColorsConstant.graphicFillDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 3.5.w),
          child: SvgPicture.asset(
            ImagePathConstant.searchIcon,
            fit: BoxFit.scaleDown,
          ),
        ),
        suffixIcon: SizedBox(
                width: 30.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: SvgPicture.asset(
                        ImagePathConstant.blackLocationIcon,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                      width: 20.w,
                      child: Marquee(
                        text:
                            context.read<HomeProvider>().userAddress ??
                                'No Address Found! Please SignIn',
                        velocity: 40.0,
                        pauseAfterRound: const Duration(seconds: 1),
                        blankSpace: 30.0,
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        suffixIconConstraints: BoxConstraints(minWidth: 11.w),
        prefixIconConstraints: BoxConstraints(minWidth: 11.w),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorsConstant.textLight,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.h),
          borderSide: BorderSide.none,
        ),
      );
}
