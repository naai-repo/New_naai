import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/api_models/location_item_model.dart';
import 'package:naai/models/utility/booking_info_model.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/views/post_auth/appointment_details/appointment_details_screen.dart';
import 'package:naai/views/post_auth/home/home_screen.dart';
import 'package:naai/views/post_auth/utility/booked_salon_artist_name_component.dart';
import 'package:naai/views/post_auth/utility/text_with_prefix_icon_component.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcommingBookingsCard extends StatelessWidget {
  final BookingInfoItemModel bookingData;
  const UpcommingBookingsCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    String salonName = bookingData.salonDetails?.data?.data?.name ?? "Salon Name";
    DateTime date = DateTime.parse(bookingData.appointmentData!.bookingDate.toString());
    //String serviceDate = "${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)} ${DateFormat.y().format(date).substring(2)}";
    String serviceDate = "${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)}";
    String serviceStartTime = bookingData.appointmentData?.timeSlot?.start ?? "00:00";
    String serviceTime = DateFormat.jm().format(DateTime(1999,9,7,int.parse(serviceStartTime.substring(0,2)),int.parse(serviceStartTime.substring(3))));
    String weekDay = DateFormat('EEEE').format(date);
    List<double> coords = bookingData.salonDetails?.data?.data?.location?.coordinates ?? [0,0];
    
    return GestureDetector(
        onTap: () async {
             Navigator.push(context, MaterialPageRoute(builder: (_) => AppointMentDetailsScreen(bookingData: bookingData,isUpcomming: true,)));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(15.w),
          decoration:  BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            borderRadius: BorderRadius.circular(10.r),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWithLine(
                    lineHeight: 25.h,
                    lineWidth: 5.w,
                    fontSize: 16.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAppointment.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 25.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(salonName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                TimeDateCard(
                                  fillColor: ColorsConstant.textDark,
                                  child: Text(serviceDate,
                                    style: StyleConstant.bookingDateTimeTextStyle,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                TimeDateCard(
                                  fillColor: ColorsConstant.textDark,
                                  child: Text(weekDay,
                                    style: StyleConstant.bookingDateTimeTextStyle,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                TimeDateCard(
                                  fillColor: ColorsConstant.textDark,
                                  child: Text(serviceTime,
                                    style: StyleConstant.bookingDateTimeTextStyle,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              navigateTo(coords[1],coords[0]);
                            },
                            child: Container(
                                padding: EdgeInsets.all(15.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: ColorsConstant.appColor,width: 1.w),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(ImagePathConstant.currentLocationPointer,height: 25.sp),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    
  }

  void navigateTo(double lat, double lng) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}

class PrevBookingCard extends StatelessWidget {
  final BookingInfoItemModel bookingData;
  const PrevBookingCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    String salonName = bookingData.salonDetails?.data?.data?.name ?? "Salon Name";
    String artistName = bookingData.artistMapServices?.first.artist?.data?.name ?? "Artist Name";
    String servicesNames = "";
    for(var e in bookingData.artistMapServices!){
      servicesNames +=  "${(e.serviceArtist?.data?.serviceTitle ?? "Service Name")}, ";
    }
    if(servicesNames.isNotEmpty) servicesNames = servicesNames.substring(0,servicesNames.length-2);

    return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        margin: EdgeInsets.only(bottom: 10.h),
        borderRadius: 10.r,
        child: Container(
          padding: EdgeInsets.all(20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 30.h,
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText: salonName.toUpperCase(),
                  ),
                  BookedSalonAndArtistName(
                    headerText: StringConstant.artist,
                    headerIconPath: ImagePathConstant.artistIcon,
                    nameText: artistName.toUpperCase(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              Text(
                  servicesNames,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: const Color(0xFF212121),
                  ),
              ),
              // ConstrainedBox(
              //   constraints: BoxConstraints(maxHeight: 50.h),
              //   child: ListView.separated(
              //     padding: EdgeInsets.zero,
              //     shrinkWrap: true,
              //     physics: const ScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) => ,
              //     separatorBuilder: (context, index) => const Text(', '),
              //     itemCount: 2
              //   ),
              // ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: () => {},
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    fontSize: 16.sp,
                    borderRadius: 10.r,
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 50.w),
                  RedButtonWithText(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AppointMentDetailsScreen(bookingData: bookingData,isUpcomming: false)));
                    },
                    buttonText: StringConstant.seeDetails,
                    fontSize: 16.sp,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    borderRadius: 10.r,
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  
  }
}

