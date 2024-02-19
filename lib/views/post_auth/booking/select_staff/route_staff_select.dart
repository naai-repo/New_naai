import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/views/post_auth/booking/select_staff/multiple_staff_select.dart';
import 'package:naai/views/post_auth/booking/select_staff/single_staff_select.dart';

class SelectStaff extends StatelessWidget {
  const SelectStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SingleStaffSelect(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: ColorsConstant.divider,
                  thickness: 2.w,
                ),
              ),
              SizedBox(width: 5.w),
              Text("OR",style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600
              )),
              SizedBox(width: 5.w),
              Expanded(
                child: Divider(
                  color: ColorsConstant.divider,
                  thickness: 2.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const MultipleStaffSelect()
        ],
      ),
    );
  }
}