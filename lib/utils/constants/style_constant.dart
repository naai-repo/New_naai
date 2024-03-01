import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';

class StyleConstant {
  static TextStyle headingTextStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
  );

  static TextStyle greySemiBoldTextStyle = const TextStyle(
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
    fontSize: 16.sp,
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
    fontSize: 22.sp,
    color: ColorsConstant.textDark,
  );

  static TextStyle bookingDateTimeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static InputDecoration searchBoxInputDecoration(
    BuildContext context, {
    required String hintText,
    required String address,
  }) =>
      InputDecoration(
        filled: true,
        fillColor: ColorsConstant.graphicFillDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20.w,right: 10.w),
          child: SvgPicture.asset(
            ImagePathConstant.searchIcon,
            fit: BoxFit.scaleDown,
            height: 20.h,
          ),
        ),
        suffixIcon: SizedBox(
                width: 120.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: SvgPicture.asset(
                        ImagePathConstant.blackLocationIcon,
                        fit: BoxFit.scaleDown,
                        height: 20.h,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 30.h,
                      width: 90.w,
                      child: Marquee(
                        text: address,
                        velocity: 40.0,
                        pauseAfterRound: const Duration(seconds: 1),
                        blankSpace: 30.0,
                        style: TextStyle(
                          color: const Color(0xFF555555),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        suffixIconConstraints: BoxConstraints(minWidth: 20.w),
        prefixIconConstraints: BoxConstraints(minWidth: 20.w),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorsConstant.textLight,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.h),
          borderSide: BorderSide.none,
        ),
      );
}
