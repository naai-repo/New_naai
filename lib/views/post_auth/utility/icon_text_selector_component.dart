import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';

class IconTextSelectorComponent extends StatelessWidget {
  final String text;
  final String iconPath;
  final bool isSelected;
  final bool showSelector;

  const IconTextSelectorComponent({
    super.key,
    required this.text,
    required this.iconPath,
    this.isSelected = false,
    this.showSelector = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              color: isSelected ? ColorsConstant.appColor : null,
              height: 15.h,
            ),
            SizedBox(width: 2.w),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? ColorsConstant.appColor
                    : ColorsConstant.textLight,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Visibility(
          visible: showSelector,
          child: SvgPicture.asset(
            isSelected
                ? ImagePathConstant.selectedOption
                : ImagePathConstant.unselectedOption,
            width: 5.w,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
