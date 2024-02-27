import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextWithPrefixIcon extends StatelessWidget {
  final String text;
  final String iconPath;
  final double? iconHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? iconColor;

  const TextWithPrefixIcon({
    super.key,
    required this.iconPath,
    required this.text,
    this.iconHeight,
    this.iconColor,
    this.fontSize,
    this.fontWeight,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconPath,
          height: iconHeight,
          color: iconColor,
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
