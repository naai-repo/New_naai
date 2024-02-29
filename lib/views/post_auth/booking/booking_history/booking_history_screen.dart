import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/controllers/appointments/appointments_bookings_controller.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/home/home_screen.dart';
import 'package:naai/views/post_auth/utility/bookings_card_component.dart';
import 'package:provider/provider.dart';

class BookingHistoryContainer extends StatelessWidget {
  const BookingHistoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final refAuth = Provider.of<AuthenticationProvider>(context,listen: false);
    bool isGuest = refAuth.authData.isGuest ?? false;

    return FutureBuilder(
      future: BookingAppointmentsController.getBookings(context), 
      builder: (context,snapshot){
         if(isGuest) return const SizedBox();

         if(snapshot.hasData){
            final commingsBookings = snapshot.data?.upcommingBookings ?? [];
            final prevsBookings = snapshot.data?.prevBooking ?? [];
            if(commingsBookings.isEmpty && prevsBookings.isEmpty) return const SizedBox();

            return SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleWithLine(
                        lineHeight: 25.h,
                        lineWidth: 5.w,
                        fontSize: 20.sp,
                        text: StringConstant.appointment.toUpperCase(),
                    ),
                    SizedBox(height: 10.h),
                    ...List.generate(commingsBookings.length, (index) {
                        return Container(
                           margin: EdgeInsets.only(bottom: 10.h),
                           child: UpcommingBookingsCard(bookingData: commingsBookings[index]),
                        );
                    }),
                    ...List.generate(prevsBookings.length, (index) {
                        return Container(
                           margin: EdgeInsets.only(bottom: 10.h),
                           child: PrevBookingCard(bookingData: prevsBookings[index]),
                        );
                    }),
                  ],
                ),
              );
  
         }

         return SizedBox(
            child: Center(child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 5.w)),
         );
      }
    );
   
  }


}


