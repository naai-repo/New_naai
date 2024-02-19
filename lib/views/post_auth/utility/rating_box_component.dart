import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';

class RatingBox extends StatelessWidget {
  final double rating;
  final double? fontSize;
  final FontWeight? fontWeight;

  const RatingBox({
    super.key,
    required this.rating,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final formattedRating = double.parse(rating.toStringAsFixed(1));
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 1.5.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.h),
        color: const Color(0xFFF8F8F8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$formattedRating',
            style: TextStyle(
              fontSize: fontSize ?? 11.5.sp,
              fontWeight: fontWeight ?? FontWeight.w600,
              color: ColorsConstant.textDark,
            ),
          ),
          SizedBox(width: 1.w),
          SvgPicture.asset(
            ImagePathConstant.starIcon,
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
