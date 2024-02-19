import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/constants/image_path_constant.dart';


class CommonWidget {

 static Widget appScreenCommonBackground() {
    return Container(
      height: double.maxFinite,
      color: const Color(0xFF212121),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
           //   color: Colors.grey.shade600,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
            //  color: Colors.grey.shade600,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
           //   color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

 static SliverAppBar transparentFlexibleSpace() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true,
      expandedHeight: 50.h,
      collapsedHeight: 0,
      flexibleSpace: const FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
      ),
      toolbarHeight: 0,
    );
  }

}