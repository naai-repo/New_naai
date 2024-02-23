import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/views/post_auth/booking/select_staff/multiple_staff_select.dart';
import 'package:naai/views/post_auth/booking/select_staff/single_staff_select.dart';
import 'package:provider/provider.dart';

class SelectStaff extends StatefulWidget {
  const SelectStaff({super.key});

  @override
  State<SelectStaff> createState() => _SelectStaffState();
}

class _SelectStaffState extends State<SelectStaff>{
  bool isFromArtistScreen = false;

  @override
  void initState() {
    super.initState();
    isFromArtistScreen = context.read<BookingServicesSalonProvider>().isFromArtistScreen;
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Column(
        children: [
          const SingleStaffSelect(),
          if(!isFromArtistScreen) SizedBox(height: 20.h),
          if(!isFromArtistScreen) Row(
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
          if(!isFromArtistScreen)  SizedBox(height: 20.h),
          if(!isFromArtistScreen) const MultipleStaffSelect()
        ],
      ),
    );
  }
}