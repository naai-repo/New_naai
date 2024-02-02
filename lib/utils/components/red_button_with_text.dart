import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class RedButtonWithText extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final Color? fillColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final Border? border;
  final bool shouldShowBoxShadow;
  final Widget? icon;
  final bool isIconSuffix;
  final double? borderRadius;

  const RedButtonWithText({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.fillColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.border,
    this.shouldShowBoxShadow = true,
    this.icon,
    this.isIconSuffix = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 1.h),
          boxShadow: shouldShowBoxShadow
              ? <BoxShadow>[
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: ColorsConstant.dropShadowColor,
                  ),
                ]
              : null,
          border: border ?? null,
          color: fillColor ?? ColorsConstant.appColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: icon != null && !isIconSuffix,
              child: Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: icon ?? SizedBox(),
              ),
            ),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: fontSize ?? 12.sp,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ),
            Visibility(
              visible: icon != null && isIconSuffix,
              child: Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: icon ?? SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color bgColor;
  final BoxBorder? border;

  const FilterButton(
      {super.key,
      required this.onTap,
      required this.child,
      this.padding,
      this.margin,
      this.width,
      this.height,
      this.borderRadius,
      required this.bgColor,this.border});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      color: bgColor,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(borderRadius: borderRadius, border: border),
          child: child,
        ),
      ),
    );
  }
}
