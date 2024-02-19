import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';

class ProcessStatusIndicatorText extends StatelessWidget {
  final String text;
  final bool isActive;
  final Function() onTap;

  const ProcessStatusIndicatorText({
    super.key,
    required this.text,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: isActive
                    ? ColorsConstant.appColor
                    : ColorsConstant.textLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            if (isActive)
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(1.h),
                  right: Radius.circular(1.h),
                ),
                child: const Divider(
                  height: 3,
                  thickness: 3,
                  color: ColorsConstant.appColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
