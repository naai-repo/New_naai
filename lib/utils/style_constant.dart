import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StyleConstant {
  static TextStyle headingTextStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
    fontSize: 17.sp,
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
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle userProfileOptionsStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
  );

  static InputDecoration searchBoxInputDecoration(
    BuildContext context, {
    required String hintText,
    required bool isExploreScreenSearchBar,
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
        suffixIcon: isExploreScreenSearchBar
            ? SizedBox()
            : SizedBox(
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
                      width: 22.w,
                      child: Marquee(
                        text:
                            "${context.read<UserProvider>().getHomeAddressText()}",
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
