import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/views/post_auth/utility/text_with_prefix_icon_component.dart';


class BookedSalonAndArtistName extends StatelessWidget {
  final String nameText;
  final String headerText;
  final String headerIconPath;

  const BookedSalonAndArtistName({
    super.key,
    required this.nameText,
    required this.headerText,
    required this.headerIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWithPrefixIcon(
            iconPath: headerIconPath,
            iconHeight: 20.h,
            text: headerText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            textColor: ColorsConstant.appColor,
          ),
          SizedBox(height: 5.h),
          Text(
            nameText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
