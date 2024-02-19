import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/constants/colors_constant.dart';

class CurvedBorderedCard extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final bool removeBottomPadding;
  final bool cardSelected;
  final bool removeTopPadding;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;

  const CurvedBorderedCard({
    super.key,
    required this.child,
    this.removeBottomPadding = true,
    this.removeTopPadding = true,
    this.cardSelected = false,
    this.onTap,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: removeBottomPadding
            ? EdgeInsets.only(top: removeBottomPadding ? 0 : 15.h)
            : EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.h),
          border: Border.all(
            width: 1,
            color: borderColor ?? const Color(0xFFE7E7E7),
          ),
          color: fillColor ?? (cardSelected ? const Color(0xFFEBEBEB) : Colors.white),
        ),
        child: child,
      ),
    );
  }
}


class ColorfulInformationCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final Color color;

  const ColorfulInformationCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 13.w),
      padding: EdgeInsets.symmetric(
        vertical: 3.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.14),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SvgPicture.asset(
            imagePath,
            color: Colors.white,
            height: 15.h,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TimeDateCard extends StatelessWidget {
  final Widget child;
  final Color? fillColor;

  const TimeDateCard({
    super.key,
    required this.child,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: fillColor ?? const Color(0xFFEBEBEB),
      ),
      child: child,
    );
  }
}


class VariableWidthCta extends StatelessWidget {
  final Function() onTap;
  final String buttonText;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool isActive;

  const VariableWidthCta({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.horizontalPadding,
    this.verticalPadding,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 17.h,
          horizontal: horizontalPadding ?? 10.w,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? ColorsConstant.appColor
              : ColorsConstant.appColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15.h),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


