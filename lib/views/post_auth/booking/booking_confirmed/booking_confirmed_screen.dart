import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:provider/provider.dart';

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: false);
    String salonName = ref.salonDetails.data?.data?.name ?? "Salon Name";
    String salonaddress = ref.salonDetails.data?.data?.address ?? "Salon Name";
    String serviceStartTime = ref.selectedArtistTimeSlot[0];
    String timeSlot = DateFormat.jm().format(DateTime(1999,9,7,int.parse(serviceStartTime.substring(0,2)),int.parse(serviceStartTime.substring(3))));
    

     return SafeArea(
       child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //SizedBox(height: 10.h),
                    Image.asset(
                      width: 350.w,
                      ImagePathConstant.bookingConfirmationImage,
                    ),
                    Text(
                      StringConstant.bookingConfirmed,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      StringConstant.bookingConfirmedSubtext,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 80.h),
                    Text(salonName,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 300.w,
                      child: Text(
                        salonaddress,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorsConstant.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      "Time Slot",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.blackAvailableStaff,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      timeSlot,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      onTap: () {
                         Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              color: ColorsConstant.dropShadowColor,
                            ),
                          ],
                          color: ColorsConstant.appColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              height: 20.h,
                              ImagePathConstant.backArrowIos,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Back to salon page',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
     );
      
  }
}