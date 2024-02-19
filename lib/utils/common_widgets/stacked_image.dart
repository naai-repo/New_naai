import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackedImageText extends StatelessWidget {
  final String imagePath;
  final String text;
  final Function() onTap;

  const StackedImageText({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Stack(
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 150.h,
              fit: BoxFit.fitHeight,
            ),
            Positioned(
              bottom: 0,
              left: 10.w,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
