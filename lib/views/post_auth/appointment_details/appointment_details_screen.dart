import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/utility/booking_info_model.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointMentDetailsScreen extends StatelessWidget {
  final BookingInfoItemModel bookingData;
  final bool isUpcomming;
  const AppointMentDetailsScreen({super.key,required this.bookingData,this.isUpcomming = true});

  @override
  Widget build(BuildContext context) {
    final services = bookingData.artistMapServices ?? [];
    double subTotal = bookingData.appointmentData?.amount ?? 9999;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.white,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 0.1,
                  splashColor: Colors.transparent,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorsConstant.textDark,
                  ),
                ),
                Text(
                  StringConstant.appointmentDetails,
                  style: StyleConstant.textDark15sp600Style,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: (isUpcomming)
                        ? const Color(0xFFF6DE86)
                        : const Color(0xFF52D185).withOpacity(0.08),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((isUpcomming)
                            ? StringConstant.upcoming.toUpperCase()
                            : StringConstant.completed.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: (isUpcomming)
                              ? ColorsConstant.textDark
                              : const Color(0xFF52D185),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsConstant.textLight,
                                )),
                            TextSpan(
                              text: (isUpcomming) ? "Booked" : "Completed",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appointmentOverview(),
                      SizedBox(height: 30.h),
                      ...List.generate(services.length,(index){
                           String serviceName = services[index].serviceArtist?.data?.serviceTitle ?? "Servce Name";
                           String artistName = services[index].artist?.data?.name ?? "Servce Name";
      
                           return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                             child: textInRow(
                              textOne: serviceName.toUpperCase(),
                              textTwo: artistName.toUpperCase(),
                             ),
                           );
                      }),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: RedButtonWithText(
                              fontSize: 16.sp,
                              fillColor: Colors.white,
                              buttonText: " Call",
                              textColor: Colors.black,
                              onTap: () async {
                                 launchUrl(
                                    Uri(
                                      scheme: 'tel',
                                      path: StringConstant.generalContantNumber,
                                    ),
                                  );
                              },
                              shouldShowBoxShadow: false,
                              padding: EdgeInsets.all(15.w),
                              border: Border.all(),
                              borderRadius: 10.r,
                              icon: SvgPicture.asset(ImagePathConstant.phoneIcon),
                            ),
                          ),
                          // SizedBox(width: 5.w),
                          // Expanded(
                          //   flex: 1,
                          //   child: RedButtonWithText(
                          //     fontSize: 16.sp,
                          //     fillColor: Colors.white,
                          //     buttonText: StringConstant.addToFavourites,
                          //     textColor: Colors.black,
                          //     onTap: () {},
                          //     shouldShowBoxShadow: false,
                          //     border: Border.all(),
                          //     icon: const Icon(Icons.star_border),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringConstant.invoice,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: ColorsConstant.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        //  IconButton(onPressed: generateInvoice, icon: Icon(Icons.save_alt_outlined))
                        ],
                      ),
                      SizedBox(height: 20.h),
                      textInRow(
                        textOne: StringConstant.subtotal,
                        textTwo:'Rs ${subTotal.toString()}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Visibility(
              visible: true,
              replacement: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: RedButtonWithText(
                  buttonText: StringConstant.askForReview,
                  onTap: () {},
                  fillColor: Colors.white,
                  textColor: ColorsConstant.textDark,
                  border: Border.all(),
                  shouldShowBoxShadow: false,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  // (isUpcomming) ? RedButtonWithText(
                  //   buttonText: "Reschedule",
                  //   onTap: () {},
                  //   fillColor: ColorsConstant.textDark,
                  //   shouldShowBoxShadow: false,
                  //   fontSize: 16.sp,
                  //   padding: EdgeInsets.symmetric(vertical: 15.h),
                  //   border: Border.all(color: ColorsConstant.textDark),
                  // ) :
                  // RedButtonWithText(
                  //   buttonText: StringConstant.bookAgain,
                  //   onTap: () {},
                  //   fillColor: ColorsConstant.textDark,
                  //   shouldShowBoxShadow: false,
                  //   fontSize: 16.sp,
                  //   padding: EdgeInsets.symmetric(vertical: 15.h),
                  //   border: Border.all(color: ColorsConstant.textDark),
                  // ),
      
                 // SizedBox(height: 10.h),
                 if(isUpcomming)
                  RedButtonWithText(
                    buttonText: StringConstant.cancel,
                    onTap: () async{
                       try {
                         Loading.showLoding(context);
                         String token = await context.read<AuthenticationProvider>().getAccessToken();
                         final res = await BookingServices.deleteBooking(bookingId: bookingData.appointmentData?.id ?? "", accessToken: token);
                         if(res.data?.acknowledged ?? false){
                            final ref = context.read<LocationProvider>();
                            await ref.setLatLng(ref.latLng);
                            Navigator.pop(context);
                            return;
                         }
                         throw ErrorDescription(res.message ?? "Error");
                       } catch (e) {
                         if(context.mounted){
                          showErrorSnackBar(context, "Something went wrong");
                         }
                       }finally{
                          if(context.mounted){
                            Loading.closeLoading(context);
                          }
                       }
                    },
                    fillColor: Colors.white,
                    textColor: ColorsConstant.textDark,
                    border: Border.all(),
                    shouldShowBoxShadow: false,
                    icon: const Icon(Icons.close),
                    fontSize: 16.sp,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget textInRow({required String textOne,required String textTwo}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            textOne,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsConstant.textLight,
            ),
          ),
        ),
        Text(
          textTwo,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstant.textDark,
          ),
        ),
      ],
    );
  }

  Widget appointmentOverview() {

    DateTime date = DateTime.parse(bookingData.appointmentData!.bookingDate.toString());
    String serviceDate = "${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)} ${DateFormat.y().format(date)}";

    String serviceStartTime = bookingData.appointmentData?.timeSlot?.start ?? "00:00";
    String serviceTimeStart = DateFormat.jm().format(DateTime(1999,9,7,int.parse(serviceStartTime.substring(0,2)),int.parse(serviceStartTime.substring(3))));
    String serviceStartEnd = bookingData.appointmentData?.timeSlot?.end ?? "00:00";
    String serviceTimeEnd= DateFormat.jm().format(DateTime(1999,9,7,int.parse(serviceStartEnd.substring(0,2)),int.parse(serviceStartEnd.substring(3))));
    String serviceTime = "$serviceTimeStart - $serviceTimeEnd";

    String salonName = bookingData.salonDetails?.data?.data?.name ?? "Salon Name";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EDF7),
            borderRadius: BorderRadius.circular(10.r)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringConstant.salon,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsConstant.textLight,
                ),
              ),
              SizedBox(height: 10.h),
              Text( salonName.toUpperCase(),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: ColorsConstant.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                StringConstant.appointmentDateAndTime,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsConstant.textLight,
                ),
              ),
              SizedBox(height: 10.h),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: serviceDate,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' | ',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    TextSpan(
                      text: serviceTime,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              // SizedBox(height: 20.h),
              // Text(
              //   StringConstant.salon,
              //   style: TextStyle(
              //     fontSize: 16.sp,
              //     color: ColorsConstant.textLight,
              //   ),
              // ),
              // SizedBox(height: 5.h),
              // Text(
              //   salonName.toUpperCase(),
              //   style: TextStyle(
              //     fontSize: 18.sp,
              //     color: ColorsConstant.textDark,
              //     fontWeight: FontWeight.w600,
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }

}