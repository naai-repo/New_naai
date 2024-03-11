import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/controllers/appointments/appointments_bookings_controller.dart';
import 'package:naai/models/utility/booking_info_model.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/utility/bookings_card_component.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              CommonWidget.appScreenCommonBackground(),
              CustomScrollView(
                slivers: [
                  CommonWidget.transparentFlexibleSpace(),
                  titleContainer(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          color: Colors.white,
                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
                          child: FutureBuilder(
                            future: BookingAppointmentsController.getBookingsForHistory(context, 1, 20),

                            builder: (context, snapshot) {
                              if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                                 final upcurrBooking = [...snapshot.data!.upcommingBookings!,...snapshot.data!.currentBookings!];
                                 final prevBookings = snapshot.data?.prevBooking ?? [];

                                 return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 20.h),
                                        if(upcurrBooking.isNotEmpty) UpcommingAndCurrentBookingsContainer(bookingInfoModel: snapshot.data!),
                                        SizedBox(height: 20.h),
                                        if(prevBookings.isNotEmpty) PrevBookingsContainer(bookingInfoModel: snapshot.data!),
                                      ],
                                  );
                              }

                              return SizedBox(
                                  child: Center(
                                  child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
                                  ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Widget titleContainer(){
   return SliverAppBar(
          elevation: 10,
          automaticallyImplyLeading: false,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.h),
              topRight: Radius.circular(30.h),
            ),
          ),
          backgroundColor: Colors.white,
          pinned: false,
          floating: false,
          centerTitle: false,
          surfaceTintColor: Colors.white,
          title: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SizedBox(
              child: Text(
                StringConstant.bookingHistory,
                style:TextStyle(
                    color: ColorsConstant.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 25.sp,
                  ),
              ),
            ),
          ),
        );
  }
  
}

class UpcommingAndCurrentBookingsContainer extends StatelessWidget {
  final BookingInfoModel bookingInfoModel;
  const UpcommingAndCurrentBookingsContainer({super.key, required this.bookingInfoModel});

  @override
  Widget build(BuildContext context) {
    List<BookingInfoItemModel> bookings = [...bookingInfoModel.upcommingBookings!, ...bookingInfoModel.currentBookings!];
    bookings.sort((a, b) {
      final aa = DateTime.parse(a.appointmentData!.bookingDate!);
      final bb = DateTime.parse(b.appointmentData!.bookingDate!);
      
      return bb.day - aa.day;
    });
    return SizedBox(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            TitleWithLine(
              lineHeight: 25.h,
              lineWidth: 5.w,
              fontSize: 20.sp,
              text: "UPCOMMING BOOKINGS",
            ),
            SizedBox(height: 10.h),
            ...List.generate(bookings.length, (index) => UpcommingBookingsCard(bookingData: bookings[index])),
         ]
      )
    );
  }
}


class PrevBookingsContainer extends StatelessWidget {
  final BookingInfoModel bookingInfoModel;
  const PrevBookingsContainer({super.key, required this.bookingInfoModel});

  @override
  Widget build(BuildContext context) {
    List<BookingInfoItemModel> bookings = [...bookingInfoModel.upcommingBookings!, ...bookingInfoModel.currentBookings!];
    bookings.sort((a, b) {
      final aa = DateTime.parse(a.appointmentData!.bookingDate!);
      final bb = DateTime.parse(b.appointmentData!.bookingDate!);
      
      return bb.day - aa.day;
    });

    return SizedBox(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            TitleWithLine(
              lineHeight: 25.h,
              lineWidth: 5.w,
              fontSize: 20.sp,
              text: "PREVIOUS BOOKINGS",
            ),
            SizedBox(height: 10.h),
            ...List.generate(bookings.length, (index) => PrevBookingCard(bookingData: bookings[index])),
         ]
      )
    );
  }
}


class TitleWithLine extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;
  final double fontSize;
  final String text;
  final Color? textColor;
  final Color? lineColor;

  const TitleWithLine({
    required this.lineHeight,
    required this.lineWidth,
    required this.fontSize,
    required this.text,
    this.textColor,
    this.lineColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 5.w),
          height: lineHeight,
          width: lineWidth,
          decoration: BoxDecoration(
            color: lineColor ?? ColorsConstant.appColor,
            borderRadius: BorderRadius.circular(1.h),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? ColorsConstant.textDark,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
