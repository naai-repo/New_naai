import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/icon_text_selector_component.dart';
import 'package:naai/utils/components/process_status_indicator_text.dart';
import 'package:naai/utils/components/rating_box.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../../models/Time_Slot_model.dart';
import '../../../models/artist_detail.dart';
import '../../../models/artist_request.dart';
import '../../../models/artist_services.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_detail.dart';
import '../../../utils/access_token.dart';
import '../../../utils/loading_indicator.dart';
import '../../../utils/routing/named_routes.dart';
import '../../../view_model/post_auth/barber/barber_provider.dart';
import '../../../view_model/pre_auth/loginResult.dart';
import 'booking_confirmed_screen.dart';

class CreateBookingScreen extends StatefulWidget {

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  bool multipleStaffListExpanded = false;
  bool InsideMultipleStaffExpanded = false;
  int selectedRadio = 0; // Assuming 0 as the default value
 // Razorpay _razorpay = Razorpay();
  int? expandedServiceIndex;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDetails(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.setSchedulingStatus(onSelectStaff: true);
          provider.resetCurrentBooking2();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
             //   physics: const BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.h),
                        topRight: Radius.circular(3.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                            // provider.setSchedulingStatus(onSelectStaff: true);
                              provider.resetCurrentBooking2();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                                height: 2.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            StringConstant.yourAppointment,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          height:MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              salonOverviewCard(),
                              SizedBox(height: 2.h),
                              //Code for MultiService

                              if (provider.isOnPaymentPage) paymentComponent() else Column(
                                      children: <Widget>[
                                        schedulingStatus(),
                                        SizedBox(height: 2.h),
                                        if (provider.isOnSelectStaffType)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal:2.h),
                                            child: selectSingleStaffCard(),
                                          ),
                                        if (provider.isOnSelectStaffType  && !singleStaffListExpanded  )
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(2.w),
                                                  color: const Color(
                                                      0xffFFB6C1),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    StringConstant.Staff,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      //     fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        if (provider.isOnSelectStaffType)
                                        SizedBox(height: 2.h),
                                        if (provider.isOnSelectStaffType)
                                        authenticationOptionsDivider(),
                                        if (provider.isOnSelectStaffType)
                                        Padding
                                          (
                                          padding: EdgeInsets.all(2.h),
                                          child: selectMingleStaffCard(),
                                        ),
                                        if (provider.isOnSelectSlot)
                                          slotSelectionWidget(),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              /*
                              provider.isOnPaymentPage
                                  ? paymentComponent()
                                  : Column(
                                children: <Widget>[
                                  schedulingStatus(),
                                  SizedBox(height: 2.h),
                                  if (provider.isOnSelectStaffType)
                                    Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: ForNowselectSingleStaffCard(),
                                    ),
                                  if (provider.isOnSelectSlot)
                                    slotSelectionWidget(),
                                ],
                              ),
                              */
                              SizedBox(height: 35.h),
              !provider.isOnPaymentPage
                  ? Positioned(
                      bottom: 3.h,
                      right: 3.h,
                      left: 3.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 3.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          boxShadow: <BoxShadow>[
                            const BoxShadow(
                              offset: Offset(0, 2.0),
                              color: Colors.grey,
                              spreadRadius: 0.2,
                              blurRadius: 15,
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  StringConstant.total,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                                Text('Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}',
                                    style: StyleConstant.appColorBoldTextStyle),
                              ],
                            ),
                            VariableWidthCta(
                              onTap: () async {
                                provider.artistServiceList!.selectedArtistMap.values.forEach((artist) {
                                  print('Selected artist ID: ${artist?.artistId}');
                                });
                                if (provider.artistServiceList!.selectedArtist != null) {
                                  provider.setSchedulingStatus(selectStaffFinished: true);
                                }
                                List<String> selectedServiceIds = provider.getSelectedServices()
                                    .map<String>((service) => service.id.toString())
                                    .toList();
                                if (selectedServiceIds.isNotEmpty &&
                                    provider.getSelectedServices().every((service) => provider.artistServiceList!.selectedArtistMap[service.id]?.artist != null)) {
                                  provider.setSchedulingStatus(selectStaffFinished: true);
                                }
                                if (provider.isOnSelectSlot) {
                                  provider.setSchedulingStatus(
                                      selectSlotFinished: true);
                                }
                              },
                              isActive: (provider.artistServiceList!.selectedArtist != null &&
                                  provider.isOnSelectStaffType)
                                  ||
                                  (provider.selectedTime != null && provider.isOnSelectSlot && provider.selectedDate != null)
                                  ||
                                    (provider.getSelectedServices().every((service) =>
                                  provider.artistServiceList!.selectedArtistMap[service.id]?.artist !=
                                      null &&
                                      provider.isOnSelectStaffType)),
                              buttonText: StringConstant.next,
                              horizontalPadding: 7.w,
                            )
                          ],
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 2.h,
                      right: 2.h,
                      left: 2.h,
                      child: ReusableWidgets.redFullWidthButton(
                        buttonText: StringConstant.payNow,
                        onTap: () async{
                          if(provider.selectedTime != null) {
                            try {
                              String? selectedTime = provider
                                  .selectedTime;

                              // Convert the selected time to minutes since midnight
                              int selectedTimeValue =
                                  TimeOfDay
                                      .fromDateTime(
                                      DateFormat.Hm().parse(
                                          selectedTime!))
                                      .hour * 60 +
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              selectedTime))
                                          .minute;

                              // Find the time slot that contains the selected time
                              TimeSlotResponseTimeSlot? selectedTimeSlot;
                              for (var timeSlot in provider.timeslot!
                                  .timeSlots) {
                                for (var slot in timeSlot.timeSlot) {
                                  int startSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[0]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[0]))
                                              .minute;
                                  int endSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[1]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[1]))
                                              .minute;

                                  if (selectedTimeValue >=
                                      startSlotValue &&
                                      selectedTimeValue < endSlotValue) {
                                    selectedTimeSlot = timeSlot;
                                    break;
                                  }
                                }
                                if (selectedTimeSlot != null) {
                                  break;
                                }
                              }

                              // Check if a valid time slot was found
                              if (selectedTimeSlot != null) {
                                // Find the selected slot using the selected time
                                var selectedSlot = selectedTimeSlot.timeSlot.firstWhereOrNull((slot) =>
                                TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).hour * 60 +
                                    TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).minute == selectedTimeValue);

                                if (selectedSlot != null) {
                                  // Use the selected slot to get the corresponding time slot
                                  List<String> timeSlot = selectedSlot.slot;

                                  Map<String,
                                      dynamic> bookingRequestBody = {
                                    "key": 1,
                                    "timeSlot": timeSlot,
                                    "bookingDate": DateFormat(
                                        'MM-dd-yyyy')
                                        .format(provider.selectedDate!),
                                    "salonId": provider.timeslot!.salonId,
                                    "timeSlots": provider.timeslot!
                                        .timeSlots
                                        .map((ts) => ts.toJson())
                                        .toList(),
                                  };
                                  Loader.showLoader(context);
                                  Dio dio = Dio();
                                  dio.interceptors.add(LogInterceptor(
                                      requestBody: true,
                                      responseBody: true,
                                      logPrint: print));
                                  String? authToken = await AccessTokenManager
                                      .getAccessToken();

                                  if (authToken != null) {
                                    dio.options.headers['Authorization'] =
                                    'Bearer $authToken';
                                  } else {
                                    Loader.hideLoader(context);
                                  }
                                  Response bookingResponse = await dio
                                      .post(
                                    'http://13.235.49.214:8800/appointments/book',
                                    data: bookingRequestBody,
                                  );
                                  print("data is :$bookingRequestBody");
                                  Loader.hideLoader(context);

                                  if (bookingResponse.statusCode == 200) {
                                    Map<String,
                                        dynamic> responseData = bookingResponse
                                        .data;
                                    if (responseData['status'] ==
                                        'failed') {
                                      // Show the error message and stop further processing
                                      ReusableWidgets.showFlutterToast(
                                          context,
                                          responseData['message']);
                                      provider.setSchedulingStatus(
                                          selectSlotFinished: false);
                                      provider.setSchedulingStatus(
                                          selectStaffFinished: false);
                                      provider.setSchedulingStatus(
                                          onSelectStaff: false);
                                      return;
                                    }
                                    print(
                                        "Appointment booked successfully!");
                                  } else {
                                    Loader.hideLoader(context);
                                    print("Failed to book appointment");
                                    print(bookingResponse.data);
                                    provider.setSchedulingStatus(
                                        selectSlotFinished: false);
                                    provider.setSchedulingStatus(
                                        selectStaffFinished: false);
                                    provider.setSchedulingStatus(
                                        onSelectStaff: false);
                                  }
                                }
                              }
                            }catch (error) {
                              Loader.hideLoader(context);
                              // Handle booking errors
                              print('Error during appointment booking: $error');
                              provider.setSchedulingStatus(
                                  selectSlotFinished: false);
                              provider.setSchedulingStatus(
                                  selectStaffFinished: false);
                              provider.setSchedulingStatus(
                                  onSelectStaff: false);
                            }
                          }
                          Navigator.pushNamed(
                            context,
                            NamedRoutes.bookingConfirmedRoute,
                          );
                        },
                        isActive: true,
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: showArtistSlotDialogue
                    ? artistSlotPickerDialogueBox()
                    : const SizedBox(),
              ),
       ],
          ),
      ),
      );
    });
  }

  Widget authenticationOptionsDivider() {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.w),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            StringConstant.or,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget paymentComponent() {
    return Consumer2<SalonDetailsProvider, ProfileProvider>(
      builder: (context, provider, profileProvider, child) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1.h),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                color: ColorsConstant.lightAppColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BookingOverviewPart(
                      title: StringConstant.bookingFor,
                      value:  profileProvider.userData?.name ?? 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.selectedDate != null
                          ? DateFormat('MM-dd-yyyy').format(provider.selectedDate!)
                          : 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value: provider.selectedTime != null
                          ? '${(provider.selectedTime!)} Hrs'
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CurvedBorderedCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2.w),
                    Text(
                      StringConstant.services.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...( provider.getSelectedServicesCombined().map(
                          (element) => Container(
                        margin: EdgeInsets.symmetric(vertical: 2.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          element.targetGender == 'male'
                                              ? ImagePathConstant.manIcon
                                              : ImagePathConstant.womanIcon,
                                          height: 3.h,
                                        ),

                                        SizedBox(width: 2.w),
                                        Text(
                                          element.serviceTitle ?? '',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.w),
                                    Text(
                                      provider.artistServiceList!.selectedArtist?.artist ??
                                          (provider.artistServiceList!.selectedArtistMap[element.id]?.artist ?? ''),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textLight,
                                      ),
                                    ),
                                    Text(
                                      ' ₹ ${element.basePrice}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?GestureDetector(
                                    ):const SizedBox(),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),
                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?const SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Discount ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            Text('(${ provider.salonDetails!.data.data.discount?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color:  provider.salonDetails!.data.data.discount==0|| provider.salonDetails!.data.data.discount==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textLight,
                              ),
                            ),
                            Text(
                              ' ₹ ${provider.showPrice==null||provider.showPrice==0?"0":provider.totalPrice-provider.showPrice}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),

                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 2.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             StringConstant.tax,
                    //             style: TextStyle(
                    //               fontSize: 10.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ${StringConstant.gst} 18%',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xFF47CB7C),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             '+',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: ColorsConstant.textLight,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ₹ ${provider.totalPrice * 0.18}',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                      // ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }

  Widget artistSlotPickerDialogueBox() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => setState(() {
            showArtistSlotDialogue = false;
          }),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.5.h),
                      child: Container(
                        width: 80.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 3.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(provider.selectedDate ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.selectedDate ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            _buildTimeSlotCategory([540,570,600,630,660,690,720], "Morning", provider),
                            _buildTimeSlotCategory([750,780,810,840,870,900,930,960], "Afternoon", provider),
                            _buildTimeSlotCategory([990,1020,1050, 1080,1110,1140,1170,1200,1230,1260], "Evening", provider),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                    "Hi ok", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  String formatTime(int timeValue) {
    // Assuming timeValue is in minutes since midnight
    int hours = timeValue ~/ 60;
    int minutes = timeValue % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  Widget _buildTimeSlotCategory(List<int> timeSlots, String category, SalonDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 1.w),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
        Wrap(
          children: timeSlots
              .map(
                (element) => GestureDetector(
              onTap: () {
                if (isTimeSlotAvailable(element.toString(), provider)) {
                  provider.setBookingData(
                    context,
                    setSelectedTime: true,
                    startTime: element,
                  );
                }
              },
              child: timeCard(formatTime(element), provider),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  bool isTimeSlotAvailable(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.any((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element)) ?? false;

  }

  TimeSlotResponseTimeSlot? getAvailableTimeSlot(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.firstWhereOrNull((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element));
  }


  Widget timeCard(String element, SalonDetailsProvider provider) {
    bool isAvailable = isTimeSlotAvailable(element, provider);
    bool isSelected = provider.selectedTime == (element);

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          provider.setSelectedTime(element);
        }
      },
      child: Container(
        width: 15.w,
        padding: EdgeInsets.symmetric(vertical: 1.w),
        margin: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.5.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 214, 214, 214),
          ),
          color: isAvailable
              ? isSelected
              ? ColorsConstant.appColor
              : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          element,
          style: TextStyle(
            fontSize: 9.sp,
            color: isAvailable
                ? isSelected
                ? Colors.white
                : ColorsConstant.textDark
                : ColorsConstant.textDark,
          ),
        ),
      ),
    );
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        DateRangePickerController _datePickerController = DateRangePickerController();
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: <Widget>[
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: <Widget>[
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CurvedBorderedCard(
                        onTap: () async {
                          provider.showDialogue(
                            context,
                            SizedBox(
                              height: 35.h,
                              width: 40.h,
                              child: SfDateRangePicker(
                                controller: _datePickerController,
                                view: DateRangePickerView.month,
                                selectionColor: ColorsConstant.appColor,
                                backgroundColor: Colors.white,
                                headerStyle: const DateRangePickerHeaderStyle(
                                  textAlign: TextAlign.center,
                                ),
                                initialSelectedDate: provider.selectedDate,
                                initialDisplayDate: DateTime.now().toLocal(),
                                showNavigationArrow: true,
                                enablePastDates: false,

                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                                  provider.setSelectedDate(args.value);
                                  Navigator.pop(context);

                                  if (provider.selectedDate != null &&
                                      provider.salonDetails != null) {
                                    DateTime selectedDate = provider
                                        .selectedDate!;
                                    String formattedDate = DateFormat(
                                        'MM-dd-yyyy').format(selectedDate);
/*
                                    List<String> selectedServiceIds = provider
                                        .getSelectedServices()
                                        ?.map((service) => service.id)
                                        ?.toList() ?? [];

                                    ArtistService? selectedArtist = provider
                                        .artistServiceList!.selectedArtistMap[
                                    selectedServiceIds.first] ??
                                        provider.artistServiceList!
                                            .selectedArtist;

                                    if (selectedServiceIds.isNotEmpty &&
                                        selectedArtist != null) {
                                      ArtistRequest apiAResponse =
                                      await callApiA(
                                          selectedServiceIds, selectedArtist);

                                      List<Map<String,
                                          dynamic>> requestsB = apiAResponse
                                          .requests.map((request) {
                                        return {
                                          "service": request.service,
                                          "artist": request.artist,
                                        };
                                      }).toList();


                                      try {
                                        Loader.showLoader(context);
                                        Dio dio = Dio();
                                        dio.interceptors.add(LogInterceptor(
                                            requestBody: true,
                                            responseBody: true,
                                            logPrint: print));

                                        String? authToken = await AccessTokenManager
                                            .getAccessToken();

                                        if (authToken != null) {
                                          dio.options.headers['Authorization'] =
                                          'Bearer $authToken';
                                        } else {
                                          Loader.hideLoader(context);
                                          print('Error: Auth token is null');
                                          return; // Handle the case where the user is not authenticated
                                        }

                                        Map<String, dynamic> requestBodyB = {
                                          "salonId": provider.salonDetails!.data
                                              .data.id ?? "",
                                          "requests": requestsB,
                                          "date": formattedDate,
                                        };

                                        print('Request Body: $requestBodyB');

                                        Response response = await dio.post(
                                          'http://13.235.49.214:8800/appointments/schedule',
                                          data: requestBodyB,
                                        );

                                        Loader.hideLoader(context);
                                        print(
                                            'Response Data: ${response.data}');

                                        if (response.statusCode == 200) {
                                          TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
                                          provider.setTimeSlot(timeSlotResponse);
                                        } else {
                                          print("Failed to fetch time slots");
                                          print(response.data);
                                          // TODO: Handle errors appropriately
                                        }
                                      }catch (error) {
                                        print(
                                            'Error parsing response: $error');
                                        // TODO: Handle errors appropriately
                                      }
                                    }
                                  }
                                },
                                */
                                    List<String> selectedServiceIds = provider.getSelectedServicesCombined()
                                        .map((service) => service.id.toString())
                                        .toList();
                                    if (provider.artistServiceList!.selectedArtist != null) {
                                      // Call API A and schedule appointment
                                      await callApiAAndSchedule(provider, selectedServiceIds, formattedDate);
                                    } else {
                                      // For selectedArtistMap, collect service IDs and their corresponding artist IDs
                                      List<Map<String, String>> requests = [];

                                      for (String serviceId in selectedServiceIds) {
                                        String? selectedArtistId = provider.artistServiceList!.selectedArtistMap[serviceId]?.artistId;
                                        if (selectedArtistId != null) {
                                          requests.add({
                                            "service": serviceId,
                                            "artist": selectedArtistId,
                                          });
                                        }
                                      }

                                      if (requests.isNotEmpty) {
                                        // Schedule appointment with the collected service IDs and artist IDs
                                        await scheduleWithArtistMap(provider, requests, formattedDate);
                                      }
                                    }
                                  }
                                },
                                selectionMode: DateRangePickerSelectionMode.single,
                                  ),
                            ),
                          );
                        },
                        fillColor: provider.selectedDate != null ? ColorsConstant.appColor : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.selectedDate != null ? Colors.white : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.selectedDate != null
                                  ? DateFormat('dd-MM-yyyy').format(provider.selectedDate!)
                                  : StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.selectedDate != null)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CurvedBorderedCard(
                              onTap: () {
                                setState(() {
                                  showArtistSlotDialogue = true;
                                });
                              },
                              fillColor:
                              provider.selectedTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.selectedTime != null
                                        ? '${provider.selectedTime} HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.selectedTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
                              cardSelected: true,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> callApiAAndSchedule(SalonDetailsProvider  provider, List<String> selectedServiceIds, String formattedDate) async {
    ArtistService selectedArtist = provider.artistServiceList!.selectedArtist!;
    ArtistRequest apiAResponse = await callApiA(selectedServiceIds, selectedArtist);

    List<Map<String, dynamic>> requestsB = apiAResponse.requests.map((request) {
      return {
        "service": request.service,
        "artist": request.artist,

      };
    }).toList();

    try {
      Loader.showLoader(context);
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        Loader.hideLoader(context);
        print('Error: Auth token is null');
        return; // Handle the case where the user is not authenticated
      }

      Map<String, dynamic> requestBodyB = {
        "salonId": provider.salonDetails!.data.data.id ?? "",
        "requests": requestsB,
        "date": formattedDate,
      };

      print('Request Body: $requestBodyB');

      Response response = await dio.post(
        'http://13.235.49.214:8800/appointments/schedule',
        data: requestBodyB,
      );

      Loader.hideLoader(context);
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
        provider.setTimeSlot(timeSlotResponse);
      } else {
        print("Failed to fetch time slots");
        print(response.data);
        // TODO: Handle errors appropriately
      }
    } catch (error) {
      print('Error parsing response: $error');
      // TODO: Handle errors appropriately
    }
  }

  Future<void> scheduleWithArtistMap(SalonDetailsProvider provider, List<Map<String, String>> requests, String formattedDate) async {
    try {
      Loader.showLoader(context);
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        Loader.hideLoader(context);
        print('Error: Auth token is null');
        return; // Handle the case where the user is not authenticated
      }

      Map<String, dynamic> requestBodyB = {
        "salonId": provider.salonDetails!.data.data.id ?? "",
        "requests": requests,
        "date": formattedDate,
      };

      print('Request Body: $requestBodyB');

      Response response = await dio.post(
        'http://13.235.49.214:8800/appointments/schedule',
        data: requestBodyB,
      );

      Loader.hideLoader(context);
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
        provider.setTimeSlot(timeSlotResponse);
      } else {
        print("Failed to fetch time slots");
        print(response.data);
        // TODO: Handle errors appropriately
      }
    } catch (error) {
      print('Error parsing response: $error');
      // TODO: Handle errors appropriately
    }
  }

  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
              onTap: () => provider.setSchedulingStatus(onSelectStaff: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
              onTap: () =>
                  provider.setSchedulingStatus(selectStaffFinished: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
              onTap: () =>
                  provider.setSchedulingStatus(selectSlotFinished: true),
            ),
          ],
        );
      },
    );
  }

  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
            //    singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(singleStaffListExpanded)
                          Text(
                            provider.artistServiceList!.selectedArtist != null
                                ?  provider.artistServiceList!.selectedArtist!.artist ?? ''
                                : StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        if(!singleStaffListExpanded)
                          Text(
                            provider.artistServiceList!.selectedArtist != null
                                ?  provider.artistServiceList!.selectedArtist!.artist ?? ''
                                : StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        Radio(
                          activeColor:  const Color(0xFFAA2F4C),
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                              // Clear the selected artists in the provider
                              provider.artistServiceList!.selectedArtistMap.clear();
                              singleStaffListExpanded = true;
                              multipleStaffListExpanded = false;
                              provider.currentBooking.artistId = null;
                            });
                          },
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Scrollbar(
                      thumbVisibility: true,
                      interactive: true,
                      showTrackOnHover: true,
                          child: Container(
                              constraints: BoxConstraints(maxHeight: 20.h),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: provider.artistServiceList!.artistsProvidingServices.length,
                                itemBuilder: (context, index) {
                                  ArtistService artist =
                                  provider.artistServiceList!.artistsProvidingServices[index];
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() {
                                        // Set the selected artist
                                        provider.artistServiceList!.selectedArtist = artist;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text.rich(
                                            TextSpan(
                                              children: <InlineSpan>[
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 2.w),
                                                    child: SvgPicture.asset(
                                                      artist ==
                                                          provider.artistServiceList!.selectedArtist
                                                          ? ImagePathConstant
                                                          .selectedOption
                                                          : ImagePathConstant
                                                          .unselectedOption,
                                                      width: 5.w,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: artist.artist ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.sp,
                                                    color: const Color(0xFF727272),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RatingBox(
                                            rating: artist.rating ?? 0.0,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const Divider(),
                              ),
                            ),
                        )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget salonOverviewCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(1.h),
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: ColorsConstant.lightAppColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(1.h),
                child: provider.salonDetails!.data.data.images.isNotEmpty && provider.salonDetails?.data.data.images !=null
                    ? Image.network(
                  provider.salonDetails!.data.data.images[0].url,
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : Image.asset(
                  'assets/images/salon_dummy_image.png',
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon.toUpperCase(),
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.address ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<ArtistService>> fetchArtists(String? salonId, String serviceId) async {
    final Dio _dio = Dio();
    try {
      String url = 'http://13.235.49.214:8800/appointments/singleArtist/list';
      Map<String, dynamic> requestBody = {
        "salonId": salonId,
        "services": [serviceId]
      };
print('request body :- $requestBody');
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Response response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: options,
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Parse response data
        dynamic responseData = response.data;
        List<dynamic>? artistsData = responseData['artistsProvidingServices'] as List<dynamic>?;

        if (artistsData != null) {
          // Map artists data to ArtistService objects
          List<ArtistService> artists = artistsData.map((artistData) => ArtistService.fromJson(artistData)).toList();
          return artists;
        } else {
          // Return an empty list if no artists are available
          return [];
        }
      } else {
        throw Exception('Failed to fetch artists: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch artists: $error');
    }
  }

  Widget selectMingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            CurvedBorderedCard(
              onTap: () => setState(() {
                // multipleStaffListExpanded = !multipleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconTextSelectorComponent(
                          text: StringConstant.multipleStaffText,
                          iconPath: ImagePathConstant.multipleStaffIcon,
                          isSelected: false,
                        ),
                        Radio(
                          activeColor: const Color(0xFFAA2F4C),
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                              singleStaffListExpanded = false;
                              multipleStaffListExpanded = true;
                              // Clear the selected artist in the provider
                              provider.artistServiceList!.selectedArtist = null;
                              if (!multipleStaffListExpanded) {
                                provider.artistServiceList!.selectedArtistMap.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (multipleStaffListExpanded)
                      Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        showTrackOnHover: true,
                        child: Container(
                          height: 25.h, // Set a fixed height for the container
                          child: ListView.builder(
                            itemCount: provider.getSelectedServices().length,
                            itemBuilder: (context, index) {
                              var element = provider.getSelectedServices().toList()[index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                element.targetGender == 'male'
                                                    ? ImagePathConstant.manIcon
                                                    : ImagePathConstant.womanIcon,
                                                height: 3.h,
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                element.serviceTitle ?? '',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: ColorsConstant.textDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.w),
                                          Text(
                                            '₹ ${element.basePrice}',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: ColorsConstant.lightGreyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(height: 1.5.h),
                                      CurvedBorderedCard(
                                        onTap: () {
                                          setState(() {
                                            expandedServiceIndex =
                                            expandedServiceIndex == index ? null : index;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(1.5.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1.h),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    provider.artistServiceList!.selectedArtistMap[element.id]?.artist ??
                                                        StringConstant.chooseAStaff,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    ImagePathConstant.downArrow,
                                                    width: 3.w,
                                                    color: Colors.black,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
                                              ),
                                              if (expandedServiceIndex == index)
                                                Container(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: FutureBuilder<List<ArtistService>>(
                                                    future: fetchArtists( provider.salonDetails?.data.data.id , element.id),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Center(child: CircularProgressIndicator());
                                                      } else if (snapshot.hasError) {
                                                        return Center(child: Text('Error: ${snapshot.error}'));
                                                      } else if (snapshot.hasData) {
                                                        List<ArtistService> artists = snapshot.data!;
                                                        return Scrollbar(
                                                          interactive: true,
                                                          thumbVisibility: true,
                                                          showTrackOnHover: true,
                                                          child: ListView.separated(
                                                            shrinkWrap: true,
                                                            itemCount: artists.length,
                                                            itemBuilder: (context, index) {
                                                              ArtistService artist = artists[index];
                                                              return GestureDetector(
                                                                behavior: HitTestBehavior.opaque,
                                                                onTap: () {
                                                                  setState(() {
                                                                    provider.artistServiceList!.selectedArtistMap[element.id] = artist;
                                                                    print('Selected artist ID: ${artist.artistId}');
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          children: <InlineSpan>[
                                                                            WidgetSpan(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(right: 2.w),
                                                                                child: SvgPicture.asset(
                                                                                  provider.artistServiceList!.selectedArtistMap[element.id] == artist
                                                                                      ? ImagePathConstant.selectedOption
                                                                                      : ImagePathConstant.unselectedOption,
                                                                                  width: 5.w,
                                                                                  fit: BoxFit.fitWidth,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            TextSpan(
                                                                              text: artist.artist ?? '',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 10.sp,
                                                                                color: const Color(0xFF727272),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      RatingBox(
                                                                        rating: artist.rating ?? 0.0,
                                                                        fontSize: 10.sp,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            separatorBuilder: (context, index) => const Divider(),
                                                          ),
                                                        );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    },
                                                  ),
                                                )
                                              else
                                                const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<ArtistRequest> callApiA(List<String> selectedServiceIds, ArtistService selectedArtist) async {
    try {
      // Create Dio instance
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

      // Retrieve the access token from local storage
      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        // Handle the case where the user is not authenticated
        throw Exception('User is not authenticated');
      }

      // Create the request body for API A
      Map<String, dynamic> requestBody = {
        "services": selectedServiceIds,
        "artist": {
          "artistId": selectedArtist.artistId,
          "artist": selectedArtist.artist,
          "serviceList": selectedArtist.serviceList.map((service) {
            return {
              "serviceId": service.serviceId,
              "price": service.price,
              "_id": service.id,
            };
          }).toList(),
          "rating": selectedArtist.rating,
        },
      };

      // Make the request to API A
      Response responseA = await dio.post(
        'http://13.235.49.214:8800/appointments/singleArtist/request',
        data: requestBody,
      );

      // Handle the response from API A
      print(responseA.data);

      if (responseA.statusCode == 200) {
        ArtistRequest artistRequest = ArtistRequest.fromJson(responseA.data);
        return artistRequest;
      } else {
        // Handle the error from API A
        print("Failed to fetch artist requests from API A");
        print(responseA.data);
        throw Exception('Failed to fetch artist requests from API A');
      }
    } catch (error) {
      // Handle errors
      print('Error in API A: $error');
      throw error;
    }
  }
}

class BookingOverviewPart extends StatelessWidget {
  final String value;
  final String title;

  const BookingOverviewPart({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstant.textLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: ColorsConstant.textDark,
          ),
        ),
      ],
    );
  }
}

class CreateBookingScreen2 extends StatefulWidget {
  final String? artistName;
  final String? artistId;
  const CreateBookingScreen2({Key? key,this.artistName,this.artistId}) : super(key: key);

  @override
  State<CreateBookingScreen2> createState() => _CreateBookingScreen2State();
}

class _CreateBookingScreen2State extends State<CreateBookingScreen2> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  // Razorpay _razorpay = Razorpay();



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDetails(context);
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.setSchedulingStatus(onSelectStaff: true);
          provider.resetCurrentBooking2();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.h),
                        topRight: Radius.circular(3.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              provider.setSchedulingStatus(onSelectStaff: true);
                              provider.resetCurrentBooking2();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                                height: 2.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            StringConstant.yourAppointment,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          height: 100.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              salonOverviewCard(),
                              SizedBox(height: 2.h),
                              provider.isOnPaymentPage
                                  ? paymentComponent()
                                  : Column(
                                children: <Widget>[
                                  schedulingStatus(),
                                  SizedBox(height: 2.h),
                                  if (provider.isOnSelectStaffType)
                                    Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: selectSingleStaffCard(),
                                    ),
                                  if (provider.isOnSelectSlot)
                                    slotSelectionWidget(),
                                ],
                              ),
                              SizedBox(height: 35.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              !provider.isOnPaymentPage
                  ? Positioned(
                bottom: 3.h,
                right: 3.h,
                left: 3.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    boxShadow: <BoxShadow>[
                      const BoxShadow(
                        offset: Offset(0, 2.0),
                        color: Colors.grey,
                        spreadRadius: 0.2,
                        blurRadius: 15,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.total,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Text('Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}',
                              style: StyleConstant.appColorBoldTextStyle),
                        ],
                      ),
                      VariableWidthCta(
                        onTap: () async {
                          if (provider.artistServiceList!.selectedArtist !=
                              null) {
                            provider.setSchedulingStatus(
                                selectStaffFinished: true);
                          }
                          /*
                          if(provider.selectedTime != null) {
                            try {
                              String? selectedTime = provider
                                  .selectedTime;

                              // Convert the selected time to minutes since midnight
                              int selectedTimeValue =
                                  TimeOfDay
                                      .fromDateTime(
                                      DateFormat.Hm().parse(
                                          selectedTime!))
                                      .hour * 60 +
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              selectedTime))
                                          .minute;

                              // Find the time slot that contains the selected time
                              TimeSlotResponseTimeSlot? selectedTimeSlot;
                              for (var timeSlot in provider.timeslot!
                                  .timeSlots) {
                                for (var slot in timeSlot.timeSlot) {
                                  int startSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[0]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[0]))
                                              .minute;
                                  int endSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[1]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[1]))
                                              .minute;

                                  if (selectedTimeValue >=
                                      startSlotValue &&
                                      selectedTimeValue < endSlotValue) {
                                    selectedTimeSlot = timeSlot;
                                    break;
                                  }
                                }
                                if (selectedTimeSlot != null) {
                                  break;
                                }
                              }

                              // Check if a valid time slot was found
                              if (selectedTimeSlot != null) {
                                // Find the selected slot using the selected time
                                var selectedSlot = selectedTimeSlot.timeSlot.firstWhereOrNull((slot) =>
                                TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).hour * 60 +
                                    TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).minute == selectedTimeValue);

                                if (selectedSlot != null) {
                                  // Use the selected slot to get the corresponding time slot
                                  List<String> timeSlot = selectedSlot.slot;

                                  Map<String,
                                      dynamic> bookingRequestBody = {
                                    "key": 1,
                                    "timeSlot": timeSlot,
                                    "bookingDate": DateFormat(
                                        'MM-dd-yyyy')
                                        .format(provider.selectedDate!),
                                    "salonId": provider.timeslot!.salonId,
                                    "timeSlots": provider.timeslot!
                                        .timeSlots
                                        .map((ts) => ts.toJson())
                                        .toList(),
                                  };
                                  Loader.showLoader(context);
                                  Dio dio = Dio();
                                  dio.interceptors.add(LogInterceptor(
                                      requestBody: true,
                                      responseBody: true,
                                      logPrint: print));
                                  String? authToken = await AccessTokenManager
                                      .getAccessToken();

                                  if (authToken != null) {
                                    dio.options.headers['Authorization'] =
                                    'Bearer $authToken';
                                  } else {
                                    Loader.hideLoader(context);
                                  }
                                  Response bookingResponse = await dio
                                      .post(
                                    'http://13.235.49.214:8800/appointments/book',
                                    data: bookingRequestBody,
                                  );
                                  print("data is :$bookingRequestBody");
                                  Loader.hideLoader(context);

                                  if (bookingResponse.statusCode == 200) {
                                    Map<String,
                                        dynamic> responseData = bookingResponse
                                        .data;
                                    if (responseData['status'] ==
                                        'failed') {
                                      // Show the error message and stop further processing
                                      ReusableWidgets.showFlutterToast(
                                          context,
                                          responseData['message']);
                                      provider.setSchedulingStatus(
                                          selectSlotFinished: false);
                                      provider.setSchedulingStatus(
                                          selectStaffFinished: false);
                                      provider.setSchedulingStatus(
                                          onSelectStaff: false);
                                      return;
                                    }
                                    print(
                                        "Appointment booked successfully!");
                                  } else {
                                    Loader.hideLoader(context);
                                    print("Failed to book appointment");
                                    print(bookingResponse.data);
                                    provider.setSchedulingStatus(
                                        selectSlotFinished: false);
                                    provider.setSchedulingStatus(
                                        selectStaffFinished: false);
                                    provider.setSchedulingStatus(
                                        onSelectStaff: false);
                                  }
                                }
                              }
                            }catch (error) {
                              Loader.hideLoader(context);
                              // Handle booking errors
                              print('Error during appointment booking: $error');
                              provider.setSchedulingStatus(
                                  selectSlotFinished: false);
                              provider.setSchedulingStatus(
                                  selectStaffFinished: false);
                              provider.setSchedulingStatus(
                                  onSelectStaff: false);
                            }
                          }
                          */
                          if (provider.isOnSelectSlot) {
                            provider.setSchedulingStatus(
                                selectSlotFinished: true);
                          }
                        },
                        isActive: (provider.artistServiceList!.selectedArtist != null &&
                            provider.isOnSelectStaffType) ||
                            (provider.selectedTime != null && provider.isOnSelectSlot),
                        buttonText: StringConstant.next,
                        horizontalPadding: 7.w,
                      )
                    ],
                  ),
                ),
              )
                  : Positioned(
                bottom: 2.h,
                right: 2.h,
                left: 2.h,
                child: ReusableWidgets.redFullWidthButton(
                  buttonText: StringConstant.payNow,
                  onTap: () async{
                    if(provider.selectedTime != null) {
                      try {
                        String? selectedTime = provider
                            .selectedTime;

                        // Convert the selected time to minutes since midnight
                        int selectedTimeValue =
                            TimeOfDay
                                .fromDateTime(
                                DateFormat.Hm().parse(
                                    selectedTime!))
                                .hour * 60 +
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        selectedTime))
                                    .minute;

                        // Find the time slot that contains the selected time
                        TimeSlotResponseTimeSlot? selectedTimeSlot;
                        for (var timeSlot in provider.timeslot!
                            .timeSlots) {
                          for (var slot in timeSlot.timeSlot) {
                            int startSlotValue =
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        slot.slot[0]))
                                    .hour * 60 +
                                    TimeOfDay
                                        .fromDateTime(
                                        DateFormat.Hm().parse(
                                            slot.slot[0]))
                                        .minute;
                            int endSlotValue =
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        slot.slot[1]))
                                    .hour * 60 +
                                    TimeOfDay
                                        .fromDateTime(
                                        DateFormat.Hm().parse(
                                            slot.slot[1]))
                                        .minute;

                            if (selectedTimeValue >=
                                startSlotValue &&
                                selectedTimeValue < endSlotValue) {
                              selectedTimeSlot = timeSlot;
                              break;
                            }
                          }
                          if (selectedTimeSlot != null) {
                            break;
                          }
                        }

                        // Check if a valid time slot was found
                        if (selectedTimeSlot != null) {
                          // Find the selected slot using the selected time
                          var selectedSlot = selectedTimeSlot.timeSlot.firstWhereOrNull((slot) =>
                          TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).hour * 60 +
                              TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).minute == selectedTimeValue);

                          if (selectedSlot != null) {
                            // Use the selected slot to get the corresponding time slot
                            List<String> timeSlot = selectedSlot.slot;

                            Map<String,
                                dynamic> bookingRequestBody = {
                              "key": 1,
                              "timeSlot": timeSlot,
                              "bookingDate": DateFormat(
                                  'MM-dd-yyyy')
                                  .format(provider.selectedDate!),
                              "salonId": provider.timeslot!.salonId,
                              "timeSlots": provider.timeslot!
                                  .timeSlots
                                  .map((ts) => ts.toJson())
                                  .toList(),
                            };
                            Loader.showLoader(context);
                            Dio dio = Dio();
                            dio.interceptors.add(LogInterceptor(
                                requestBody: true,
                                responseBody: true,
                                logPrint: print));
                            String? authToken = await AccessTokenManager
                                .getAccessToken();

                            if (authToken != null) {
                              dio.options.headers['Authorization'] =
                              'Bearer $authToken';
                            } else {
                              Loader.hideLoader(context);
                            }
                            Response bookingResponse = await dio
                                .post(
                              'http://13.235.49.214:8800/appointments/book',
                              data: bookingRequestBody,
                            );
                            print("data is :$bookingRequestBody");
                            Loader.hideLoader(context);

                            if (bookingResponse.statusCode == 200) {
                              Map<String,
                                  dynamic> responseData = bookingResponse
                                  .data;
                              if (responseData['status'] ==
                                  'failed') {
                                // Show the error message and stop further processing
                                ReusableWidgets.showFlutterToast(
                                    context,
                                    responseData['message']);
                                provider.setSchedulingStatus(
                                    selectSlotFinished: false);
                                provider.setSchedulingStatus(
                                    selectStaffFinished: false);
                                provider.setSchedulingStatus(
                                    onSelectStaff: false);
                                return;
                              }
                              print(
                                  "Appointment booked successfully!");
                            } else {
                              Loader.hideLoader(context);
                              print("Failed to book appointment");
                              print(bookingResponse.data);
                              provider.setSchedulingStatus(
                                  selectSlotFinished: false);
                              provider.setSchedulingStatus(
                                  selectStaffFinished: false);
                              provider.setSchedulingStatus(
                                  onSelectStaff: false);
                            }
                          }
                        }
                      }catch (error) {
                        Loader.hideLoader(context);
                        // Handle booking errors
                        print('Error during appointment booking: $error');
                        provider.setSchedulingStatus(
                            selectSlotFinished: false);
                        provider.setSchedulingStatus(
                            selectStaffFinished: false);
                        provider.setSchedulingStatus(
                            onSelectStaff: false);
                      }
                    }
                     Navigator.pushNamed(
                      context,
                      NamedRoutes.bookingConfirmedRoute,
                    );
                  },
                  isActive: true,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: showArtistSlotDialogue
                    ? artistSlotPickerDialogueBox()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget paymentComponent() {
    return Consumer2<SalonDetailsProvider, ProfileProvider>(
      builder: (context, provider, profileProvider, child) {
        Data? serviceDetail3 =  context.read<BarberProvider>().artistDetails;
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1.h),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                color: ColorsConstant.lightAppColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BookingOverviewPart(
                      title: StringConstant.bookingFor,
                      value:  profileProvider.userData?.name ?? 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.selectedDate != null
                          ? DateFormat('MM-dd-yyyy').format(provider.selectedDate!)
                          : 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value: provider.selectedTime != null
                          ? '${(provider.selectedTime!)} Hrs'
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CurvedBorderedCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2.w),
                    Text(
                      StringConstant.services.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(provider.selectedServices.map(
                          (element) =>Container(
                        margin: EdgeInsets.symmetric(vertical: 2.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          element.targetGender == 'male'
                                              ? ImagePathConstant.manIcon
                                              : ImagePathConstant.womanIcon,
                                          height: 3.h,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          element.serviceTitle,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.w),
                                    Text(
                                     widget.artistName ??
                                          'jsdv skljdk',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textLight,
                                      ),
                                    ),
                                    Text(
                                      ' ₹ ${element.basePrice}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?GestureDetector(
                                    ):const SizedBox(),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),
                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?const SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Discount ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            Text('(${ provider.salonDetails!.data.data.discount?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color:  provider.salonDetails!.data.data.discount==0|| provider.salonDetails!.data.data.discount==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textLight,
                              ),
                            ),
                            Text(
                              ' ₹ ${provider.showPrice==null||provider.showPrice==0?"0":provider.totalPrice-provider.showPrice}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),

                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 2.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             StringConstant.tax,
                    //             style: TextStyle(
                    //               fontSize: 10.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ${StringConstant.gst} 18%',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xFF47CB7C),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             '+',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: ColorsConstant.textLight,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ₹ ${provider.totalPrice * 0.18}',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                      // ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }

  Widget artistSlotPickerDialogueBox() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => setState(() {
            showArtistSlotDialogue = false;
          }),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.5.h),
                      child: Container(
                        width: 80.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 3.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(provider.selectedDate ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.selectedDate ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            _buildTimeSlotCategory([540,570,600,630,660,690,720], "Morning", provider),
                            _buildTimeSlotCategory([750,780,810,840,870,900,930,960], "Afternoon", provider),
                            _buildTimeSlotCategory([990,1020,1050, 1080,1110,1140,1170,1200,1230,1260], "Evening", provider),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                    "Hi ok", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  String formatTime(int timeValue) {
    // Assuming timeValue is in minutes since midnight
    int hours = timeValue ~/ 60;
    int minutes = timeValue % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  Widget _buildTimeSlotCategory(List<int> timeSlots, String category, SalonDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 1.w),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
        Wrap(
          children: timeSlots
              .map(
                (element) => GestureDetector(
              onTap: () {
                if (isTimeSlotAvailable(element.toString(), provider)) {
                  provider.setBookingData(
                    context,
                    setSelectedTime: true,
                    startTime: element,
                  );
                }
              },
              child: timeCard(formatTime(element), provider),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  bool isTimeSlotAvailable(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.any((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element)) ?? false;
  }

  TimeSlotResponseTimeSlot? getAvailableTimeSlot(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.firstWhereOrNull((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element));
  }

  Widget timeCard(String element, SalonDetailsProvider provider) {
    bool isAvailable = isTimeSlotAvailable(element, provider);
    bool isSelected = provider.selectedTime == (element);

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          provider.setSelectedTime(element);
        }
      },
      child: Container(
        width: 15.w,
        padding: EdgeInsets.symmetric(vertical: 1.w),
        margin: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.5.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 214, 214, 214),
          ),
          color: isAvailable
              ? isSelected
              ? ColorsConstant.appColor
              : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          element,
          style: TextStyle(
            fontSize: 9.sp,
            color: isAvailable
                ? isSelected
                ? Colors.white
                : ColorsConstant.textDark
                : ColorsConstant.textDark,
          ),
        ),
      ),
    );
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        DateRangePickerController _datePickerController = DateRangePickerController();
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: <Widget>[
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: <Widget>[
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CurvedBorderedCard(
                        onTap: () async {
                          provider.showDialogue(
                            context,
                            SizedBox(
                              height: 35.h,
                              width: 40.h,
                              child: SfDateRangePicker(
                                controller: _datePickerController,
                                view: DateRangePickerView.month,
                                selectionColor: ColorsConstant.appColor,
                                backgroundColor: Colors.white,
                                headerStyle: const DateRangePickerHeaderStyle(
                                  textAlign: TextAlign.center,
                                ),
                                initialSelectedDate: provider.selectedDate,
                                initialDisplayDate: DateTime.now().toLocal(),
                                showNavigationArrow: true,
                                enablePastDates: false,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async{
                                  provider.setSelectedDate(args.value);
                                  Navigator.pop(context);
                                  if (provider.selectedDate != null && provider.salonDetails != null) {
                                    DateTime selectedDate = provider.selectedDate!;
                                    String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
                                    List<Map<String, String>> requests = [];
                                    List<String> selectedServiceIds = provider.barbergetSelectedServices()
                                        .map((service) => service.serviceId)
                                        .toList();
                                    String selectedArtistId = widget.artistId ?? "";
                                    for (String serviceId in selectedServiceIds) {
                                      requests.add({
                                        "service": serviceId,
                                        "artist": selectedArtistId,
                                      });
                                    }
                                    Map<String, dynamic> requestBody = {
                                      "salonId": provider.salonDetails!.data.data.id ?? "",
                                      "requests": requests,
                                      "date": formattedDate,
                                    };
                                    print('salonid is : ${provider.salonDetails!.data.data.id ?? ""}');
                                    print('request is :$requests');
                                    print('date is : $formattedDate');
                                    try {
                                      // Create Dio instance
                                      Loader.showLoader(context);
                                      Dio dio = Dio();
                                      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

                                      // Retrieve the access token from local storage
                                      String? authToken = await AccessTokenManager.getAccessToken();

                                      if (authToken != null) {
                                        dio.options.headers['Authorization'] = 'Bearer $authToken';
                                      } else {
                                        Loader.hideLoader(context); // Handle the case where the user is not authenticated
                                      }
                                      Map<String, dynamic> requestBody = {
                                        "salonId": provider.salonDetails!.data.data.id ?? "",
                                        "requests": requests,
                                        "date": formattedDate,
                                      };
                                      print("request body is :- $requestBody");
                                      // Make the request
                                      Response response = await dio.post(
                                        'http://13.235.49.214:8800/appointments/schedule?page=1&limit=10',
                                        data: requestBody,
                                        );

                                      Loader.hideLoader(context);
                                      // Handle the response
                                      print(response.data);
                                      // TODO: Process the response as needed
                                      if (response.statusCode == 200) {
                                        TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
                                        provider.setTimeSlot(timeSlotResponse);

                                        if (timeSlotResponse.timeSlots.isNotEmpty &&
                                            timeSlotResponse.timeSlots[0].order != null) {
                                          provider.setSelectedServices(
                                            timeSlotResponse.timeSlots[0].order!
                                                .map((order) => order.service)
                                                .toList(),
                                          );
                                        }
                                        print("Time Slot Response: $timeSlotResponse");
                                        // TODO: Process the response as needed
                                      }
                                    else {
                                        // Handle the error
                                        print("Failed to fetch time slots");
                                        print(response.data);
                                        // TODO: Handle errors appropriately
                                      }

                                    } catch (error) {
                                      Loader.hideLoader(context);
                                      // Handle errors
                                      print('Error is $error');
                                      // TODO: Handle errors appropriately
                                    }
                                  }
                                },
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
                          );
                        },
                        fillColor: provider.selectedDate != null ? ColorsConstant.appColor : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.selectedDate != null ? Colors.white : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.selectedDate != null
                                  ? DateFormat('dd-MM-yyyy').format(provider.selectedDate!)
                                  : StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.selectedDate != null)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CurvedBorderedCard(
                              onTap: () {
                                setState(() {
                                  showArtistSlotDialogue = true;
                                });
                              },
                              fillColor:
                              provider.selectedTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.selectedTime != null
                                        ? '${provider.selectedTime} HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.selectedTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
                              cardSelected: true,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
              onTap: () => provider.setSchedulingStatus(onSelectStaff: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
              onTap: () =>
                  provider.setSchedulingStatus(selectStaffFinished: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
              onTap: () =>
                  provider.setSchedulingStatus(selectSlotFinished: true),
            ),
          ],
        );
      },
    );
  }
  Widget selectMultipleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return CurvedBorderedCard(
          removeBottomPadding: false,
          onTap: () =>
              provider.setStaffSelectionMethod(selectedSingleStaff: false),
          cardSelected: provider.selectedMultipleStaff,
          child: Container(
            padding: EdgeInsets.fromLTRB(3.w, 0.5.h, 3.w, 2.h),
            child: IconTextSelectorComponent(
              text: StringConstant.multipleStaffText,
              iconPath: ImagePathConstant.multipleStaffIcon,
              isSelected: provider.selectedMultipleStaff,
            ),
          ),
        );
      },
    );
  }

  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: context
                            .read<HomeProvider>()
                            .artistList
                            .where((artist) => artist.salonId == provider.selectedSalonData.id)
                            .where((artist) => artist.name == widget.artistName) // Filter by selected category
                            .length,
                        itemBuilder: (context, index) {
                          Artist artist = context
                              .read<HomeProvider>()
                              .artistList
                              .where((artist) => artist.salonId == provider.selectedSalonData.id)
                              .where((artist) => artist.name == widget.artistName)// Filter by selected category
                              .toList()[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget salonOverviewCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(1.h),
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: ColorsConstant.lightAppColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(1.h),
                child: provider.salonDetails!.data.data.images.isNotEmpty && provider.salonDetails?.data.data.images !=null
                    ? Image.network(
                  provider.salonDetails!.data.data.images[0].url,
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : Image.asset(
                  'assets/images/salon_dummy_image.png',
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon.toUpperCase(),
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.address ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
/*
  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: context
                            .read<HomeProvider>()
                            .artistList
                            .where((artist) => artist.salonId == provider.selectedSalonData.id)
                            .where((artist) => artist.name == widget.artistName) // Filter by selected category
                            .length,
                        itemBuilder: (context, index) {
                          Artist artist = context
                              .read<HomeProvider>()
                              .artistList
                              .where((artist) => artist.salonId == provider.selectedSalonData.id)
                              .where((artist) => artist.name == widget.artistName)// Filter by selected category
                              .toList()[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      ),
                    )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 */


//code for Single Services

class CreateBookingScreen3 extends StatefulWidget {


  @override
  State<CreateBookingScreen3> createState() => _CreateBookingScreen3State();
}

class _CreateBookingScreen3State extends State<CreateBookingScreen3> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  bool multipleStaffListExpanded = false;
  bool InsideMultipleStaffExpanded = false;
  int selectedRadio = 0; // Assuming 0 as the default value
  // Razorpay _razorpay = Razorpay();



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDetails(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.setSchedulingStatus(onSelectStaff: true);
          provider.resetCurrentBooking2();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.h),
                        topRight: Radius.circular(3.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              provider.setSchedulingStatus(onSelectStaff: true);
                              provider.resetCurrentBooking2();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                                height: 2.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            StringConstant.yourAppointment,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          height:MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              salonOverviewCard(),
                              SizedBox(height: 2.h),
                              provider.isOnPaymentPage
                                  ? paymentComponent()
                                  : Column(
                                children: <Widget>[
                                  schedulingStatus(),
                                  SizedBox(height: 2.h),
                                  if (provider.isOnSelectStaffType)
                                    Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: ForNowselectSingleStaffCard(),
                                    ),
                                  if (provider.isOnSelectSlot)
                                    slotSelectionWidget(),
                                ],
                              ),
                              SizedBox(height: 35.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              !provider.isOnPaymentPage
                  ? Positioned(
                bottom: 3.h,
                right: 3.h,
                left: 3.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    boxShadow: <BoxShadow>[
                      const BoxShadow(
                        offset: Offset(0, 2.0),
                        color: Colors.grey,
                        spreadRadius: 0.2,
                        blurRadius: 15,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.total,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Text('Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}',
                              style: StyleConstant.appColorBoldTextStyle),
                        ],
                      ),

                      VariableWidthCta(
                        onTap: () async {
                          if (provider.artistServiceList!.selectedArtist !=
                              null) {
                            provider.setSchedulingStatus(
                                selectStaffFinished: true);
                          }
                          /*
                          if(provider.selectedTime != null) {
                            try {
                              String? selectedTime = provider
                                  .selectedTime;

                              // Convert the selected time to minutes since midnight
                              int selectedTimeValue =
                                  TimeOfDay
                                      .fromDateTime(
                                      DateFormat.Hm().parse(
                                          selectedTime!))
                                      .hour * 60 +
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              selectedTime))
                                          .minute;

                              // Find the time slot that contains the selected time
                              TimeSlotResponseTimeSlot? selectedTimeSlot;
                              for (var timeSlot in provider.timeslot!
                                  .timeSlots) {
                                for (var slot in timeSlot.timeSlot) {
                                  int startSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[0]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[0]))
                                              .minute;
                                  int endSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(
                                              slot.slot[1]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[1]))
                                              .minute;

                                  if (selectedTimeValue >=
                                      startSlotValue &&
                                      selectedTimeValue < endSlotValue) {
                                    selectedTimeSlot = timeSlot;
                                    break;
                                  }
                                }
                                if (selectedTimeSlot != null) {
                                  break;
                                }
                              }

                              // Check if a valid time slot was found
                              if (selectedTimeSlot != null) {
                                // Find the selected slot using the selected time
                                var selectedSlot = selectedTimeSlot.timeSlot.firstWhereOrNull((slot) =>
                                TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).hour * 60 +
                                    TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).minute == selectedTimeValue);

                                if (selectedSlot != null) {
                                  // Use the selected slot to get the corresponding time slot
                                  List<String> timeSlot = selectedSlot.slot;

                                  Map<String,
                                      dynamic> bookingRequestBody = {
                                    "key": 1,
                                    "timeSlot": timeSlot,
                                    "bookingDate": DateFormat(
                                        'MM-dd-yyyy')
                                        .format(provider.selectedDate!),
                                    "salonId": provider.timeslot!.salonId,
                                    "timeSlots": provider.timeslot!
                                        .timeSlots
                                        .map((ts) => ts.toJson())
                                        .toList(),
                                  };
                                  Loader.showLoader(context);
                                  Dio dio = Dio();
                                  dio.interceptors.add(LogInterceptor(
                                      requestBody: true,
                                      responseBody: true,
                                      logPrint: print));
                                  String? authToken = await AccessTokenManager
                                      .getAccessToken();

                                  if (authToken != null) {
                                    dio.options.headers['Authorization'] =
                                    'Bearer $authToken';
                                  } else {
                                    Loader.hideLoader(context);
                                  }
                                  Response bookingResponse = await dio
                                      .post(
                                    'http://13.235.49.214:8800/appointments/book',
                                    data: bookingRequestBody,
                                  );
                                  print("data is :$bookingRequestBody");
                                  Loader.hideLoader(context);

                                  if (bookingResponse.statusCode == 200) {
                                    Map<String,
                                        dynamic> responseData = bookingResponse
                                        .data;
                                    if (responseData['status'] ==
                                        'failed') {
                                      // Show the error message and stop further processing
                                      ReusableWidgets.showFlutterToast(
                                          context,
                                          responseData['message']);
                                      provider.setSchedulingStatus(
                                          selectSlotFinished: false);
                                      provider.setSchedulingStatus(
                                          selectStaffFinished: false);
                                      provider.setSchedulingStatus(
                                          onSelectStaff: false);
                                      return;
                                    }
                                    print(
                                        "Appointment booked successfully!");
                                  } else {
                                    Loader.hideLoader(context);
                                    print("Failed to book appointment");
                                    print(bookingResponse.data);
                                    provider.setSchedulingStatus(
                                        selectSlotFinished: false);
                                    provider.setSchedulingStatus(
                                        selectStaffFinished: false);
                                    provider.setSchedulingStatus(
                                        onSelectStaff: false);
                                  }
                                }
                              }
                            }catch (error) {
                              Loader.hideLoader(context);
                              // Handle booking errors
                              print('Error during appointment booking: $error');
                              provider.setSchedulingStatus(
                                  selectSlotFinished: false);
                              provider.setSchedulingStatus(
                                  selectStaffFinished: false);
                              provider.setSchedulingStatus(
                                  onSelectStaff: false);
                            }
                          }
                          */
                          if (provider.isOnSelectSlot) {
                            provider.setSchedulingStatus(
                                selectSlotFinished: true);
                          }
                        },
                        isActive: (provider.artistServiceList!.selectedArtist != null &&
                            provider.isOnSelectStaffType) ||
                            (provider.selectedTime != null && provider.isOnSelectSlot),
                        buttonText: StringConstant.next,
                        horizontalPadding: 7.w,
                      )
                    ],
                  ),
                ),
              )
                  : Positioned(
                bottom: 2.h,
                right: 2.h,
                left: 2.h,
                child: ReusableWidgets.redFullWidthButton(
                  buttonText: StringConstant.payNow,
                  onTap: () async {
                    if(provider.selectedTime != null) {
                      try {
                        String? selectedTime = provider
                            .selectedTime;

                        // Convert the selected time to minutes since midnight
                        int selectedTimeValue =
                            TimeOfDay
                                .fromDateTime(
                                DateFormat.Hm().parse(
                                    selectedTime!))
                                .hour * 60 +
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        selectedTime))
                                    .minute;

                        // Find the time slot that contains the selected time
                        TimeSlotResponseTimeSlot? selectedTimeSlot;
                        for (var timeSlot in provider.timeslot!
                            .timeSlots) {
                          for (var slot in timeSlot.timeSlot) {
                            int startSlotValue =
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        slot.slot[0]))
                                    .hour * 60 +
                                    TimeOfDay
                                        .fromDateTime(
                                        DateFormat.Hm().parse(
                                            slot.slot[0]))
                                        .minute;
                            int endSlotValue =
                                TimeOfDay
                                    .fromDateTime(
                                    DateFormat.Hm().parse(
                                        slot.slot[1]))
                                    .hour * 60 +
                                    TimeOfDay
                                        .fromDateTime(
                                        DateFormat.Hm().parse(
                                            slot.slot[1]))
                                        .minute;

                            if (selectedTimeValue >=
                                startSlotValue &&
                                selectedTimeValue < endSlotValue) {
                              selectedTimeSlot = timeSlot;
                              break;
                            }
                          }
                          if (selectedTimeSlot != null) {
                            break;
                          }
                        }

                        // Check if a valid time slot was found
                        if (selectedTimeSlot != null) {
                          // Find the selected slot using the selected time
                          var selectedSlot = selectedTimeSlot.timeSlot.firstWhereOrNull((slot) =>
                          TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).hour * 60 +
                              TimeOfDay.fromDateTime(DateFormat.Hm().parse(slot.slot[0])).minute == selectedTimeValue);

                          if (selectedSlot != null) {
                            // Use the selected slot to get the corresponding time slot
                            List<String> timeSlot = selectedSlot.slot;

                            Map<String, dynamic> bookingRequestBody = {
                              "key": 1,
                              "timeSlot": timeSlot,
                              "bookingDate": DateFormat(
                                  'MM-dd-yyyy')
                                  .format(provider.selectedDate!),
                              "salonId": provider.timeslot!.salonId,
                              "timeSlots": provider.timeslot!
                                  .timeSlots
                                  .map((ts) => ts.toJson())
                                  .toList(),
                            };
                            Loader.showLoader(context);
                            Dio dio = Dio();
                            dio.interceptors.add(LogInterceptor(
                                requestBody: true,
                                responseBody: true,
                                logPrint: print));
                            String? authToken = await AccessTokenManager
                                .getAccessToken();

                            if (authToken != null) {
                              dio.options.headers['Authorization'] =
                              'Bearer $authToken';
                            } else {
                              Loader.hideLoader(context);
                            }
                            Response bookingResponse = await dio
                                .post(
                              'http://13.235.49.214:8800/appointments/book',
                              data: bookingRequestBody,
                            );
                            print("data is :$bookingRequestBody");
                            Loader.hideLoader(context);

                            if (bookingResponse.statusCode == 200) {
                              Map<String,
                                  dynamic> responseData = bookingResponse
                                  .data;
                              if (responseData['status'] ==
                                  'failed') {
                                // Show the error message and stop further processing
                                ReusableWidgets.showFlutterToast(
                                    context,
                                    responseData['message']);
                                provider.setSchedulingStatus(
                                    selectSlotFinished: false);
                                provider.setSchedulingStatus(
                                    selectStaffFinished: false);
                                provider.setSchedulingStatus(
                                    onSelectStaff: false);
                                return;
                              }
                              print(
                                  "Appointment booked successfully!");
                            } else {
                              Loader.hideLoader(context);
                              print("Failed to book appointment");
                              print(bookingResponse.data);
                              provider.setSchedulingStatus(
                                  selectSlotFinished: false);
                              provider.setSchedulingStatus(
                                  selectStaffFinished: false);
                              provider.setSchedulingStatus(
                                  onSelectStaff: false);
                            }
                          }
                        }
                      }catch (error) {
                        Loader.hideLoader(context);
                        // Handle booking errors
                        print('Error during appointment booking: $error');
                        provider.setSchedulingStatus(
                            selectSlotFinished: false);
                        provider.setSchedulingStatus(
                            selectStaffFinished: false);
                        provider.setSchedulingStatus(
                            onSelectStaff: false);
                      }
                    }
                   Navigator.pushNamed(
                     context,
                     NamedRoutes.bookingConfirmedRoute,
                   );
                  },
                  isActive: true,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: showArtistSlotDialogue
                    ? artistSlotPickerDialogueBox()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget authenticationOptionsDivider() {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.w),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            StringConstant.or,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget paymentComponent() {
    return Consumer2<SalonDetailsProvider, ProfileProvider>(
    builder: (context, provider, profileProvider, child) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1.h),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                color: ColorsConstant.lightAppColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BookingOverviewPart(
                      title: StringConstant.bookingFor,
                      value:  profileProvider.userData?.name ?? 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.selectedDate != null
                          ? DateFormat('MM-dd-yyyy').format(provider.selectedDate!)
                          : 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value: provider.selectedTime != null
                          ? '${(provider.selectedTime!)} Hrs'
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CurvedBorderedCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2.w),
                    Text(
                      StringConstant.services.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...( provider.getSelectedServicesCombined().map(
                          (element) => Container(
                        margin: EdgeInsets.symmetric(vertical: 2.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          element.targetGender == 'male'
                                              ? ImagePathConstant.manIcon
                                              : ImagePathConstant.womanIcon,
                                          height: 3.h,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          element.serviceTitle ?? '',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.w),
                                    Text(
                                          provider.artistServiceList!.selectedArtist!.artist ??
                                              '',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textLight,
                                      ),
                                    ),
                                    Text(
                                      ' ₹ ${element.basePrice}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?GestureDetector(
                                      onTap: (){},
                                    ):const SizedBox(),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),
                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?const SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Discount ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            Text('(${ provider.salonDetails!.data.data.discount?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color:  provider.salonDetails!.data.data.discount==0|| provider.salonDetails!.data.data.discount==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textLight,
                              ),
                            ),
                            Text(
                              ' ₹ ${provider.showPrice==null||provider.showPrice==0?"0":provider.totalPrice-provider.showPrice}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),

                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 2.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             StringConstant.tax,
                    //             style: TextStyle(
                    //               fontSize: 10.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ${StringConstant.gst} 18%',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xFF47CB7C),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             '+',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: ColorsConstant.textLight,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ₹ ${provider.totalPrice * 0.18}',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                      // ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }

  Widget artistSlotPickerDialogueBox() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => setState(() {
            showArtistSlotDialogue = false;
          }),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.5.h),
                      child: Container(
                        width: 80.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 3.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(provider.selectedDate ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.selectedDate ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            _buildTimeSlotCategory([540,570,600,630,660,690,720], "Morning", provider),
                            _buildTimeSlotCategory([750,780,810,840,870,900,930,960], "Afternoon", provider),
                            _buildTimeSlotCategory([990,1020,1050, 1080,1110,1140,1170,1200,1230,1260], "Evening", provider),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                    "Hi ok", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  String formatTime(int timeValue) {
    // Assuming timeValue is in minutes since midnight
    int hours = timeValue ~/ 60;
    int minutes = timeValue % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  Widget _buildTimeSlotCategory(List<int> timeSlots, String category, SalonDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 1.w),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
        Wrap(
          children: timeSlots
              .map(
                (element) => GestureDetector(
              onTap: () {
                if (isTimeSlotAvailable(element.toString(), provider)) {
                  provider.setBookingData(
                    context,
                    setSelectedTime: true,
                    startTime: element,
                  );
                }
              },
              child: timeCard(formatTime(element), provider),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  bool isTimeSlotAvailable(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.any((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element)) ?? false;
  }

  TimeSlotResponseTimeSlot? getAvailableTimeSlot(String element, SalonDetailsProvider provider) {
    return provider.timeslot?.timeSlots.firstWhereOrNull((timeSlot) =>
        timeSlot.timeSlot.any((slot) => slot.slot[0] == element));
  }

  Widget timeCard(String element, SalonDetailsProvider provider) {
    bool isAvailable = isTimeSlotAvailable(element, provider);
    bool isSelected = provider.selectedTime == (element);

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          provider.setSelectedTime(element);
        }
      },
      child: Container(
        width: 15.w,
        padding: EdgeInsets.symmetric(vertical: 1.w),
        margin: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.5.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 214, 214, 214),
          ),
          color: isAvailable
              ? isSelected
              ? ColorsConstant.appColor
              : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          element,
          style: TextStyle(
            fontSize: 9.sp,
            color: isAvailable
                ? isSelected
                ? Colors.white
                : ColorsConstant.textDark
                : ColorsConstant.textDark,
          ),
        ),
      ),
    );
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        DateRangePickerController _datePickerController = DateRangePickerController();
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: <Widget>[
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: <Widget>[
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CurvedBorderedCard(
                        onTap: () async {
                      provider.showDialogue(
                            context,
                            SizedBox(
                              height: 35.h,
                              width: 40.h,
                              child: SfDateRangePicker(
                                controller: _datePickerController,
                                view: DateRangePickerView.month,
                                selectionColor: ColorsConstant.appColor,
                                backgroundColor: Colors.white,
                                headerStyle: const DateRangePickerHeaderStyle(
                                  textAlign: TextAlign.center,
                                ),
                                initialSelectedDate: provider.selectedDate,
                                initialDisplayDate: DateTime.now().toLocal(),
                                showNavigationArrow: true,
                                enablePastDates: false,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async{
                                  provider.setSelectedDate(args.value);
                                  Navigator.pop(context);
                                  if (provider.selectedDate != null && provider.salonDetails != null) {
                                    DateTime selectedDate = provider.selectedDate!;
                                    String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
                                    List<Map<String, dynamic>> requests = [];
                                    List<String> selectedServiceIds = provider.getSelectedServicesCombined()
                                        .map((service) => service.id.toString())
                                        .toList();
                                    String selectedArtistId = provider.artistServiceList!.selectedArtist?.artistId ?? "";
/*
                                    for (String serviceId in selectedServiceIds) {
                                        requests.add({
                                          "service": serviceId,
                                          "artist": selectedArtistId,
                                        });
                                      }
*/
                                    for (var service in provider.getSelectedServicesCombined()) {
                                      Map<String, dynamic> request = {
                                        "service": service.id.toString(),
                                        "artist": selectedArtistId,
                                      };

                                      // Check if the service has a variable associated with it
                                      if (service.variables.isNotEmpty) {
                                        // If yes, add the variable to the request
                                        FluffyVariable variable = service.variables.first; // Assuming there's only one variable per service
                                        request["variable"] = {
                                          "variableType": variable.variableType,
                                          "variableName": variable.variableName,
                                          "variablePrice": variable.variablePrice,
                                          "variableCutPrice": variable.variableCutPrice,
                                          "variableTime": variable.variableTime,
                                          "_id": variable.id,
                                        };
                                      }

                                      requests.add(request);
                                    }
                                    Map<String, dynamic> requestBody = {
                                      "salonId": provider.salonDetails!.data.data.id ?? "",
                                      "requests": requests,
                                      "date": formattedDate,
                                    };
                                    print('salonid is : ${provider.salonDetails!.data.data.id ?? ""}');
                                    print('request is :$requests');
                                    print('date is : $formattedDate');
                                    try {
                                      // Create Dio instance
                                      Loader.showLoader(context);
                                      Dio dio = Dio();
                                      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

                                      // Retrieve the access token from local storage
                                      String? authToken = await AccessTokenManager.getAccessToken();

                                      if (authToken != null) {
                                        dio.options.headers['Authorization'] = 'Bearer $authToken';
                                      } else {
                                       Loader.hideLoader(context); // Handle the case where the user is not authenticated
                                      }
                                      Map<String, dynamic> requestBody = {
                                        "salonId": provider.salonDetails!.data.data.id ?? "",
                                        "requests": requests,
                                        "date": formattedDate,
                                      };
                                      // Make the request
                                      Response response = await dio.post(
                                        'http://13.235.49.214:8800/appointments/schedule',
                                        data: requestBody,
                                      );
                                      Loader.hideLoader(context);
                                      // Handle the response
                                      print(response.data);
                                      // TODO: Process the response as needed

                                      if (response.statusCode == 200) {
                                        TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
                                        provider.setTimeSlot(timeSlotResponse);
                                        print("Time Slot Response: $timeSlotResponse");
                                        // TODO: Process the response as needed
                                      } else {
                                        // Handle the error
                                        print("Failed to fetch time slots");
                                        print(response.data);
                                        // TODO: Handle errors appropriately
                                      }

                                    } catch (error) {
                                      Loader.hideLoader(context);
                                      // Handle errors
                                      print('Error is $error');
                                      // TODO: Handle errors appropriately
                                    }
                                  }
                                },
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
                          );
                        },
                        fillColor: provider.selectedDate != null ? ColorsConstant.appColor : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.selectedDate != null ? Colors.white : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.selectedDate != null
                                  ? DateFormat('dd-MM-yyyy').format(provider.selectedDate!)
                                  : StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.selectedDate != null ? Colors.white : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.selectedDate != null)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CurvedBorderedCard(
                              onTap: () {
                                setState(() {
                                  showArtistSlotDialogue = true;
                                });
                              },
                              fillColor:
                              provider.selectedTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.selectedTime != null
                                        ? '${provider.selectedTime} HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.selectedTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.selectedTime !=
                                        null
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
                              cardSelected: true,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
              onTap: () => provider.setSchedulingStatus(onSelectStaff: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
              onTap: () =>
                  provider.setSchedulingStatus(selectStaffFinished: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
              onTap: () =>
                  provider.setSchedulingStatus(selectSlotFinished: true),
            ),
          ],
        );
      },
    );
  }

  Widget selectMultipleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return CurvedBorderedCard(
          removeBottomPadding: false,
          onTap: () =>
              provider.setStaffSelectionMethod(selectedSingleStaff: false),
          cardSelected: provider.selectedMultipleStaff,
          child: Container(
            padding: EdgeInsets.fromLTRB(3.w, 0.5.h, 3.w, 2.h),
            child: IconTextSelectorComponent(
              text: StringConstant.multipleStaffText,
              iconPath: ImagePathConstant.multipleStaffIcon,
              isSelected: provider.selectedMultipleStaff,
            ),
          ),
        );
      },
    );
  }

  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(singleStaffListExpanded)
                          Text(
                            provider.currentBooking.artistId != null
                                ? provider.getSelectedArtistName(
                                provider.currentBooking.artistId ?? '',
                                context)
                                : StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),

                          ),
                        if(!singleStaffListExpanded)
                          Text(
                            StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        Radio(
                          activeColor:  const Color(0xFFAA2F4C),
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                              // Handle logic for single staff selection
                              singleStaffListExpanded = true;
                              multipleStaffListExpanded = false;
                              provider.currentBooking.artistId = null;
                            });
                          },
                        ),
                        /*
                        Radio(
                          value:  singleStaffListExpanded, // Unique value for this radio button
                          groupValue: singleStaffListExpanded,
                          onChanged: (value) {
                            setState(() {
                              singleStaffListExpanded =  singleStaffListExpanded;
                              // Handle the logic when this radio button is selected
                            });
                          },
                        ),
                        */
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        /* itemCount: context
                                  .read<HomeProvider>()
                                  .artistList
                                  .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  .length,
                              itemBuilder: (context, index) {
                                Artist artist = context
                                    .read<HomeProvider>()
                                    .artistList
                                    .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  // .where((artist) => artist.category == provider.selectedServiceCategories) // Filter by selected category
                                    .toList()[index];*/
                        itemCount: provider.artistList.length,
                        itemBuilder: (context, index) {
                          Artist artist =
                          provider.artistList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget salonOverviewCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(1.h),
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: ColorsConstant.lightAppColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(1.h),
                child: provider.salonDetails!.data.data.images.isNotEmpty && provider.salonDetails?.data.data.images !=null
                    ? Image.network(
                  provider.salonDetails!.data.data.images[0].url,
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : Image.asset(
                  'assets/images/salon_dummy_image.png',
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon.toUpperCase(),
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      provider.salonDetails?.data.data.address ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget selectMingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            CurvedBorderedCard(
              onTap: () => setState(() {
                //  singleStaffListExpanded = !singleStaffListExpanded;
                multipleStaffListExpanded = !multipleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconTextSelectorComponent(
                          text: StringConstant.multipleStaffText,
                          iconPath: ImagePathConstant.multipleStaffIcon,
                          isSelected: false,
                        ),
                        Radio(
                          activeColor:  const Color(0xFFAA2F4C),
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                              singleStaffListExpanded = false;
                              multipleStaffListExpanded = true;
                              provider.currentBooking.artistId = null;
                            });
                          },
                        ),
                      ],
                    ),
                    if(multipleStaffListExpanded)
                      ...(provider.currentBooking.serviceIds?.map(
                            (element) => Container(
                          constraints: BoxConstraints(maxHeight: 20.h),
                          // margin: EdgeInsets.symmetric(vertical: 2.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            provider.getServiceDetails(
                                              serviceId: element,
                                              getGender: true,
                                            ) ==
                                                Gender.MALE
                                                ? ImagePathConstant.manIcon
                                                : ImagePathConstant.womanIcon,
                                            height: 3.h,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            provider.getServiceDetails(
                                              serviceId: element,
                                              getServiceName: true,
                                            ),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: ColorsConstant.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.w),
                                      Text('  Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}'
                                        ,style:(TextStyle(
                                          fontSize: 10.sp,
                                          color: ColorsConstant.lightGreyText,
                                        ))
                                        ,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              selectInsideStaffCard()
                            ],
                          ),
                        ),
                      ) ??
                          []),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget selectInsideStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                InsideMultipleStaffExpanded = !InsideMultipleStaffExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    //  singleStaffListExpanded
                    InsideMultipleStaffExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.artistList.length,
                        itemBuilder: (context, index) {
                          Artist artist =
                          provider.artistList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget ForNowselectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.artistServiceList!.selectedArtist != null
                              ?  provider.artistServiceList!.selectedArtist!.artist ?? ''
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Scrollbar(
                      thumbVisibility: true,
                      interactive: true,
                      showTrackOnHover: true,
                          child: Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.artistServiceList!.artistsProvidingServices.length,
                          itemBuilder: (context, index) {
                            ArtistService artist =
                            provider.artistServiceList!.artistsProvidingServices[index];
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  // Set the selected artist
                                  provider.artistServiceList!.selectedArtist = artist;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 2.w),
                                              child: SvgPicture.asset(
                                                artist ==
                                                    provider.artistServiceList!.selectedArtist
                                                    ? ImagePathConstant
                                                    .selectedOption
                                                    : ImagePathConstant
                                                    .unselectedOption,
                                                width: 5.w,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: artist.artist ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp,
                                              color: Color(0xFF727272),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RatingBox(
                                      rating:  artist.rating,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                      ),
                    ),
                        )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


