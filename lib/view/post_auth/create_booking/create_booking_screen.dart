import 'dart:developer';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

import '../../../models/Profile_model.dart';
import '../../../models/Time_Slot_model.dart';
import '../../../models/artist_services.dart';
import '../../../models/service_detail.dart';
import '../../../utils/access_token.dart';
import '../../../utils/loading_indicator.dart';
import '../../../utils/routing/named_routes.dart';
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



  @override
  void initState() {
 //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //    context.read<ProfileProvider>().getUserDataFromUserProvider(context);
 //   });
    _getUserDetails();
    super.initState();
  }

  Future<void> _getUserDetails() async {
    final loginResult = Provider.of<LoginResultProvider>(context, listen: false).loginResult;
    if (loginResult != null && loginResult['status'] == 'success') {
      final userId = loginResult['userId'];
      try {
        final response = await Dio().get(
          'http://13.235.49.214:8800/customer/user/$userId',
        );

        if (response.data != null && response.data is Map<String, dynamic>) {
          ProfileResponse apiResponse = ProfileResponse.fromJson(response.data);

          if (apiResponse != null && apiResponse.data != null) {
            // Save the user details in the provider
            context.read<ProfileProvider>().setUserData(apiResponse.data);
          } else {
            // Handle the case where the response or data is null
            print('Failed to fetch user details: Invalid response format');
          }
        } else {
          // Handle the case where the response is null or not of the expected type
          print('Failed to fetch user details: Invalid response format');
        }
      } catch (error) {
        Loader.hideLoader(context);
        // Handle the case where the API call was not successful
        // You can show an error message or take appropriate action
        print('Failed to fetch user details: $error');
      }
    }
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
                                        Padding(
                                          padding: EdgeInsets.all(2.h),
                                          child: selectMingleStaffCard(),
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
                              onTap: () {
                                if (provider.isOnSelectStaffType) {
                                  provider.setSchedulingStatus(
                                      selectStaffFinished: true);
                                } else if (provider.isOnSelectSlot) {
                                  provider.setSchedulingStatus(
                                      selectSlotFinished: true);
                                }
                              },
                              isActive: provider.isNextButtonActive,
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
                          await context.read<SalonDetailsProvider>().createBooking(
                            context,
                            "Paid not yet", // Set your desired transaction status
                            paymentId: null,
                            orderId: null,
                            errorMessage: null,
                            // Set your desired error message or null//      );
                          // After creating the booking, navigate to the BookingConfirmedScreen
                         // Navigator.of(context).push(
                         //   MaterialPageRoute(builder: (context) => BookingConfirmedScreen()),
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
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
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
                      value: context.read<HomeProvider>().userData.name ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.currentBooking.selectedDate ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value:
                          '${provider.convertSecondsToTimeString(provider.currentBooking.startTime ?? 0)} Hrs',
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
                    ...(provider.currentBooking.serviceIds?.map(
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
                                              provider.getServiceDetails(
                                                        serviceId: element,
                                                        getGender: true,
                                                      ) ==
                                                      Gender.MEN
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
                                        Text(
                                          provider.getSelectedArtistName(
                                              provider.currentBooking.artistId ??
                                                  '',
                                              context),
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
                                          ' ₹ ${provider.getServiceDetails(
                                            serviceId: element,
                                            getServiceCharge: true,
                                          )}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?GestureDetector(
                                          onTap: () => provider.setSelectedService(
                                            element,
                                            removeService: true,
                                          ),
                                          child: SvgPicture.asset(
                                            ImagePathConstant.deleteIcon,
                                            height: 2.5.h,
                                          ),
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
                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?const SizedBox():Row(
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
                            Text('(${provider.selectedSalonData.discountPercentage ?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
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
                                  '${DateFormat.E().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.morning,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible: element <= 43200,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.afternoon,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible:
                                          element > 43200 && element <= 57600,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.evening,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible: element > 57600,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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

  Widget timeCard(int element) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
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
          color: provider.artistAvailabilityToDisplay.contains(element)
              ? element == (provider.currentBooking.startTime)  // Previous in bracket provider.currentBooking.startTime ?? 0
                  ? ColorsConstant.appColor
                  : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          provider.convertSecondsToTimeString(element),
          style: TextStyle(
            fontSize: 9.sp,
            color: provider.artistAvailabilityToDisplay.contains(element)
                ? element == (provider.currentBooking.startTime ?? 0)
                    ? Colors.white
                    : ColorsConstant.textDark
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
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
                        onTap: () => provider.showDialogue(
                          context,
                          SizedBox(
                            height: 35.h,
                            width: 40.h,
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionColor: ColorsConstant.appColor,
                              backgroundColor: Colors.white,
                              headerStyle: const DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                              ),
                              initialSelectedDate: provider.currentBooking
                                  .selectedDateInDateTimeFormat,
                              initialDisplayDate: DateTime.now().toLocal(),
                              showNavigationArrow: true,
                              enablePastDates: false,
                              onSelectionChanged: (date) {
                                provider.setBookingData(
                                  context,
                                  setSelectedDate: true,
                                  selectedDate: date.value,
                                );
                                provider.resetTime();
                                provider.getArtistBooking(context);
                                Navigator.pop(context);
                              },
                              selectionMode:
                              DateRangePickerSelectionMode.single,

                            ),
                          ),
                        ),
                        fillColor:
                        provider.currentBooking.selectedDate?.isNotEmpty ==
                            true
                            ? ColorsConstant.appColor
                            : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.currentBooking.selectedDate ??
                                  StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.currentBooking.selectedDate
                                    ?.isNotEmpty ==
                                    true
                                    ? Colors.white
                                    : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.currentBooking.selectedDate?.isNotEmpty ==
                          true)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot, // This thing need to be correct.
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
                              provider.currentBooking.startTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.currentBooking.startTime != null
                                        ? provider.convertSecondsToTimeString(
                                        provider.currentBooking
                                            .startTime ??
                                            0) +
                                        ' HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.currentBooking.startTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.currentBooking.startTime !=
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

  // Widget slotSelectionWidget() {
  //   return Consumer<SalonDetailsProvider>(
  //     builder: (context, provider, child) {
  //       return Padding(
  //         padding: EdgeInsets.all(2.h),
  //         child: Column(
  //           children: <Widget>[
  //             CurvedBorderedCard(
  //               removeBottomPadding: false,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 5.w),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       StringConstant.selectData,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 11.sp,
  //                         color: ColorsConstant.textDark,
  //                       ),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     CurvedBorderedCard(
  //                       onTap: () => provider.showDialogue(
  //                         context,
  //                         Container(
  //                           height: 50.h,
  //                           width: 100.w,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5.h),
  //                             child: SfDateRangePicker(
  //                               selectionColor: ColorsConstant.appColor,
  //                               backgroundColor: Colors.white,
  //                               headerStyle: DateRangePickerHeaderStyle(
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               initialSelectedDate: provider.currentBooking
  //                                   .selectedDateInDateTimeFormat,
  //                               initialDisplayDate: DateTime.now().toLocal(),
  //                               showNavigationArrow: true,
  //                               enablePastDates: false,
  //                               onSelectionChanged: (date) {
  //                                 provider.setBookingData(
  //                                   context,
  //                                   setSelectedDate: true,
  //                                   selectedDate: date.value,
  //                                 );
  //                                 provider.resetTime();
  //                                 provider.getArtistBooking(context);
  //                                 Navigator.pop(context);
  //                               },
  //                               selectionMode:
  //                               DateRangePickerSelectionMode.single,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       fillColor:
  //                       provider.currentBooking.selectedDate?.isNotEmpty ==
  //                           true
  //                           ? ColorsConstant.appColor
  //                           : null,
  //                       removeBottomPadding: false,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           SvgPicture.asset(
  //                             ImagePathConstant.calendarIcon,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : null,
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           Text(
  //                             provider.currentBooking.selectedDate ??
  //                                 StringConstant.datePlaceholder,
  //                             style: TextStyle(
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w500,
  //                               color: provider.currentBooking.selectedDate
  //                                   ?.isNotEmpty ==
  //                                   true
  //                                   ? Colors.white
  //                                   : ColorsConstant.textLight,
  //                             ),
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           SvgPicture.asset(
  //                             ImagePathConstant.downArrow,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : ColorsConstant.textLight,
  //                             height: 1.h,
  //                             fit: BoxFit.fitHeight,
  //                           )
  //                         ],
  //                       ),
  //                       cardSelected: true,
  //                     ),
  //                     if (provider.currentBooking.selectedDate?.isNotEmpty ==
  //                         true)
  //                       Column(
  //                         children: <Widget>[
  //                           SizedBox(height: 4.h),
  //                           Text(
  //                             StringConstant.selectTimeSlot,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 11.sp,
  //                               color: ColorsConstant.textDark,
  //                             ),
  //                           ),
  //                           SizedBox(height: 2.h),
  //                           CurvedBorderedCard(
  //                             onTap: () {
  //                               setState(() {
  //                                 showArtistSlotDialogue = true;
  //                               });
  //                             },
  //                             fillColor:
  //                             provider.currentBooking.startTime != null
  //                                 ? ColorsConstant.appColor
  //                                 : null,
  //                             removeBottomPadding: false,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.timeIcon,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : null,
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 Text(
  //                                   provider.currentBooking.startTime != null
  //                                       ? provider.convertSecondsToTimeString(
  //                                       provider.currentBooking
  //                                           .startTime ??
  //                                           0) +
  //                                       ' HRS'
  //                                       : StringConstant.timePlaceholder,
  //                                   style: TextStyle(
  //                                     fontSize: 11.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color:
  //                                     provider.currentBooking.startTime !=
  //                                         null
  //                                         ? Colors.white
  //                                         : ColorsConstant.textLight,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.downArrow,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : ColorsConstant.textLight,
  //                                   height: 1.h,
  //                                   fit: BoxFit.fitHeight,
  //                                 )
  //                               ],
  //                             ),
  //                             cardSelected: true,
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }



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
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
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
                child: provider.salonDetails?.data.data.images.isNotEmpty ?? false
                    ? Image.network(
                  provider.salonDetails!.data.data.images[0].url,
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : Image.network(
                  'https://naaibucket.s3.ap-south-1.amazonaws.com/salons/654ab25da137ad67bc2be5c5/e2e2a345496585e3f86edd2bf7b5dc74ce45746d02ee5f8573f10bb7556a48a8',  // Replace this with the URL of your dummy image
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
                                });
                          },
                        ),
                      ],
                    ),
                    if(multipleStaffListExpanded)
                             ...(provider.artistServiceList!.services?.map(
                                       (element) => Scrollbar(
                                         thumbVisibility: true,
                                         interactive: true,
                                         showTrackOnHover: true,
                                         child: Container(
                                           constraints: BoxConstraints(maxHeight: 20.h),
                                    // margin: EdgeInsets.symmetric(vertical: 2.w),
                                     child: SingleChildScrollView
                                         (
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
                                                           provider.selectedService?.targetGender == Gender.MEN
                                                               ? ImagePathConstant.manIcon
                                                               : ImagePathConstant.womanIcon,
                                                           height: 3.h,
                                                         ),
                                                         SizedBox(width: 2.w),
                                                         Text(
                                                          provider.selectedService?.serviceTitle ?? '',
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
                  //  singleStaffListExpanded
                   InsideMultipleStaffExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        showTrackOnHover: true,
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
  const CreateBookingScreen2({Key? key,this.artistName}) : super(key: key);

  @override
  State<CreateBookingScreen2> createState() => _CreateBookingScreen2State();
}

class _CreateBookingScreen2State extends State<CreateBookingScreen2> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  // Razorpay _razorpay = Razorpay();



  @override
  void initState() {
 //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //    context.read<ProfileProvider>().getUserDataFromUserProvider(context);
  //  });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("success");
    context.read<SalonDetailsProvider>().createBooking(
      context,
      "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    context.read<SalonDetailsProvider>().createBooking(
      context,
      "error",
      errorMessage: response.message,
    );
    ReusableWidgets.showFlutterToast(context, '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String? walletName = response.walletName;
    ReusableWidgets.showFlutterToast(context, 'External Wallet: $walletName');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.resetCurrentBooking();
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
                              provider.resetCurrentBooking();
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
                        onTap: () {
                          if (provider.isOnSelectStaffType) {
                            provider.setSchedulingStatus(
                                selectStaffFinished: true);
                          } else if (provider.isOnSelectSlot) {
                            provider.setSchedulingStatus(
                                selectSlotFinished: true);
                          }
                        },
                        isActive: provider.isNextButtonActive,
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
                    await context.read<SalonDetailsProvider>().createBooking(
                      context,
                      "Paid not yet", // Set your desired transaction status
                      paymentId: null,
                      orderId: null,
                      errorMessage: null,
                      // Set your desired error message or null//      );
                      // After creating the booking, navigate to the BookingConfirmedScreen
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => BookingConfirmedScreen()),
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
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
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
                      value: context.read<HomeProvider>().userData.name ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.currentBooking.selectedDate ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value:
                      '${provider.convertSecondsToTimeString(provider.currentBooking.startTime ?? 0)} Hrs',
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
                    ...(provider.currentBooking.serviceIds?.map(
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
                                          provider.getServiceDetails(
                                            serviceId: element,
                                            getGender: true,
                                          ) ==
                                              Gender.MEN
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
                                    Text(
                                      provider.getSelectedArtistName(
                                          provider.currentBooking.artistId ??
                                              '',
                                          context),
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
                                      ' ₹ ${provider.getServiceDetails(
                                        serviceId: element,
                                        getServiceCharge: true,
                                      )}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?GestureDetector(
                                      onTap: () => provider.setSelectedService(
                                        element,
                                        removeService: true,
                                      ),
                                      child: SvgPicture.asset(
                                        ImagePathConstant.deleteIcon,
                                        height: 2.5.h,
                                      ),
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
                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?const SizedBox():Row(
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
                            Text('(${provider.selectedSalonData.discountPercentage ?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
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
                                  '${DateFormat.E().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.morning,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible: element <= 43200,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.afternoon,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible:
                                  element > 43200 && element <= 57600,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.evening,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible: element > 57600,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
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

  Widget timeCard(int element) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
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
          color: provider.artistAvailabilityToDisplay.contains(element)
              ? element == (provider.currentBooking.startTime)  // Previous in bracket provider.currentBooking.startTime ?? 0
              ? ColorsConstant.appColor
              : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          provider.convertSecondsToTimeString(element),
          style: TextStyle(
            fontSize: 9.sp,
            color: provider.artistAvailabilityToDisplay.contains(element)
                ? element == (provider.currentBooking.startTime ?? 0)
                ? Colors.white
                : ColorsConstant.textDark
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
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
                        onTap: () => provider.showDialogue(
                          context,
                          SizedBox(
                            height: 35.h,
                            width: 40.h,
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionColor: ColorsConstant.appColor,
                              backgroundColor: Colors.white,
                              headerStyle: const DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                              ),
                              initialSelectedDate: provider.currentBooking
                                  .selectedDateInDateTimeFormat,
                              initialDisplayDate: DateTime.now().toLocal(),
                              showNavigationArrow: true,
                              enablePastDates: false,
                              onSelectionChanged: (date) {
                                provider.setBookingData(
                                  context,
                                  setSelectedDate: true,
                                  selectedDate: date.value,
                                );
                                provider.resetTime();
                                provider.getArtistBooking(context);
                                Navigator.pop(context);
                              },
                              selectionMode:
                              DateRangePickerSelectionMode.single,

                            ),
                          ),
                        ),
                        fillColor:
                        provider.currentBooking.selectedDate?.isNotEmpty ==
                            true
                            ? ColorsConstant.appColor
                            : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.currentBooking.selectedDate ??
                                  StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.currentBooking.selectedDate
                                    ?.isNotEmpty ==
                                    true
                                    ? Colors.white
                                    : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.currentBooking.selectedDate?.isNotEmpty ==
                          true)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot, // This thing need to be correct.
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
                              provider.currentBooking.startTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.currentBooking.startTime != null
                                        ? provider.convertSecondsToTimeString(
                                        provider.currentBooking
                                            .startTime ??
                                            0) +
                                        ' HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.currentBooking.startTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.currentBooking.startTime !=
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

  // Widget slotSelectionWidget() {
  //   return Consumer<SalonDetailsProvider>(
  //     builder: (context, provider, child) {
  //       return Padding(
  //         padding: EdgeInsets.all(2.h),
  //         child: Column(
  //           children: <Widget>[
  //             CurvedBorderedCard(
  //               removeBottomPadding: false,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 5.w),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       StringConstant.selectData,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 11.sp,
  //                         color: ColorsConstant.textDark,
  //                       ),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     CurvedBorderedCard(
  //                       onTap: () => provider.showDialogue(
  //                         context,
  //                         Container(
  //                           height: 50.h,
  //                           width: 100.w,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5.h),
  //                             child: SfDateRangePicker(
  //                               selectionColor: ColorsConstant.appColor,
  //                               backgroundColor: Colors.white,
  //                               headerStyle: DateRangePickerHeaderStyle(
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               initialSelectedDate: provider.currentBooking
  //                                   .selectedDateInDateTimeFormat,
  //                               initialDisplayDate: DateTime.now().toLocal(),
  //                               showNavigationArrow: true,
  //                               enablePastDates: false,
  //                               onSelectionChanged: (date) {
  //                                 provider.setBookingData(
  //                                   context,
  //                                   setSelectedDate: true,
  //                                   selectedDate: date.value,
  //                                 );
  //                                 provider.resetTime();
  //                                 provider.getArtistBooking(context);
  //                                 Navigator.pop(context);
  //                               },
  //                               selectionMode:
  //                               DateRangePickerSelectionMode.single,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       fillColor:
  //                       provider.currentBooking.selectedDate?.isNotEmpty ==
  //                           true
  //                           ? ColorsConstant.appColor
  //                           : null,
  //                       removeBottomPadding: false,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           SvgPicture.asset(
  //                             ImagePathConstant.calendarIcon,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : null,
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           Text(
  //                             provider.currentBooking.selectedDate ??
  //                                 StringConstant.datePlaceholder,
  //                             style: TextStyle(
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w500,
  //                               color: provider.currentBooking.selectedDate
  //                                   ?.isNotEmpty ==
  //                                   true
  //                                   ? Colors.white
  //                                   : ColorsConstant.textLight,
  //                             ),
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           SvgPicture.asset(
  //                             ImagePathConstant.downArrow,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : ColorsConstant.textLight,
  //                             height: 1.h,
  //                             fit: BoxFit.fitHeight,
  //                           )
  //                         ],
  //                       ),
  //                       cardSelected: true,
  //                     ),
  //                     if (provider.currentBooking.selectedDate?.isNotEmpty ==
  //                         true)
  //                       Column(
  //                         children: <Widget>[
  //                           SizedBox(height: 4.h),
  //                           Text(
  //                             StringConstant.selectTimeSlot,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 11.sp,
  //                               color: ColorsConstant.textDark,
  //                             ),
  //                           ),
  //                           SizedBox(height: 2.h),
  //                           CurvedBorderedCard(
  //                             onTap: () {
  //                               setState(() {
  //                                 showArtistSlotDialogue = true;
  //                               });
  //                             },
  //                             fillColor:
  //                             provider.currentBooking.startTime != null
  //                                 ? ColorsConstant.appColor
  //                                 : null,
  //                             removeBottomPadding: false,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.timeIcon,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : null,
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 Text(
  //                                   provider.currentBooking.startTime != null
  //                                       ? provider.convertSecondsToTimeString(
  //                                       provider.currentBooking
  //                                           .startTime ??
  //                                           0) +
  //                                       ' HRS'
  //                                       : StringConstant.timePlaceholder,
  //                                   style: TextStyle(
  //                                     fontSize: 11.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color:
  //                                     provider.currentBooking.startTime !=
  //                                         null
  //                                         ? Colors.white
  //                                         : ColorsConstant.textLight,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.downArrow,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : ColorsConstant.textLight,
  //                                   height: 1.h,
  //                                   fit: BoxFit.fitHeight,
  //                                 )
  //                               ],
  //                             ),
  //                             cardSelected: true,
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }



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
                child: Image.network(
                  provider.selectedSalonData.imageList![0].toString(),
                  height: 15.h,//15.h
                  width: 28.w,//15.w
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
                      provider.selectedSalonData.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      provider.selectedSalonData.address?.addressString ?? '',
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
                              //Code for MultiService
                              /*
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
                                        Padding(
                                          padding: EdgeInsets.all(2.h),
                                          child: selectMingleStaffCard(),
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
              */
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
                          if(provider.selectedTime != null) {
                            try {
                              String? selectedTime = provider.selectedTime;

                              // Convert the selected time to minutes since midnight
                              int selectedTimeValue =
                                  TimeOfDay
                                      .fromDateTime(
                                      DateFormat.Hm().parse(selectedTime!))
                                      .hour * 60 +
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(selectedTime))
                                          .minute;

                              // Find the time slot that contains the selected time
                              TimeSlotResponseTimeSlot? selectedTimeSlot;
                              for (var timeSlot in provider.timeslot!
                                  .timeSlots) {
                                for (var slot in timeSlot.timeSlot) {
                                  int startSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(slot.slot[0]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[0]))
                                              .minute;
                                  int endSlotValue =
                                      TimeOfDay
                                          .fromDateTime(
                                          DateFormat.Hm().parse(slot.slot[1]))
                                          .hour * 60 +
                                          TimeOfDay
                                              .fromDateTime(
                                              DateFormat.Hm().parse(
                                                  slot.slot[1]))
                                              .minute;

                                  if (selectedTimeValue >= startSlotValue &&
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
                                List<String> timeSlot = selectedTimeSlot
                                    .timeSlot[0].slot;

                                Map<String, dynamic> bookingRequestBody = {
                                  "key": 1,
                                  "timeSlot": timeSlot,
                                  "bookingDate": DateFormat('MM-dd-yyyy')
                                      .format(provider.selectedDate!),
                                  "salonId": provider.timeslot!.salonId,
                                  "timeSlots": provider.timeslot!.timeSlots
                                      .map((ts) => ts.toJson()).toList(),
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
                                Response bookingResponse = await dio.post(
                                  'http://13.235.49.214:8800/appointments/book',
                                  data: bookingRequestBody,
                                );
                                print("data is :$bookingRequestBody");
                                Loader.hideLoader(context);

                                if (bookingResponse.statusCode == 200) {
                                  Map<String,
                                      dynamic> responseData = bookingResponse
                                      .data;
                                  if (responseData['status'] == 'failed') {
                                    // Show the error message and stop further processing
                                    ReusableWidgets.showFlutterToast(
                                        context, responseData['message']);
                                    provider.setSchedulingStatus(
                                        selectSlotFinished: false);
                                    provider.setSchedulingStatus(
                                        selectStaffFinished: false);
                                    provider.setSchedulingStatus(
                                        onSelectStaff: false);
                                    return;
                                  }
                                  print("Appointment booked successfully!");
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
                            } catch (error) {
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
                  onTap: () {
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
                    ...( provider.getSelectedServices().map(
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
                                          element.targetGender == Gender.MEN
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
                                      child: SvgPicture.asset(
                                        ImagePathConstant.deleteIcon,
                                        height: 2.5.h,
                                      ),
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
                            _buildTimeSlotCategory([990,1020,1050, 1080,1110,1140,1170,1200], "Evening", provider),
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
        timeSlot.timeSlot.any((slot) => slot.slot.contains(element))) ?? false;
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
  bool isTimeSlotInCategory(TimeSlotResponseTimeSlot element, String category, SalonDetailsProvider provider) {
    // Implement your logic to check if the time slot belongs to the specified category (morning, afternoon, evening, night)
    // Return true if in the category, false otherwise
    // Example: return element.key == 1 && category == "Morning";
    // Adjust this logic based on your data structure
    switch (category) {
      case "Morning":
        return element.key >= 1 && element.key <= 5;
      case "Afternoon":
        return element.key >= 6 && element.key <= 10;
      case "Evening":
        return element.key >= 11 && element.key <= 14;
      case "Night":
        return element.key >= 15 && element.key <= 18;
      default:
        return false;
    }
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
                                    List<String> selectedServiceIds = provider.getSelectedServices()
                                        .map((service) => service.id)
                                        .toList();
                                    String selectedArtistId = provider.artistServiceList!.selectedArtist?.artistId ?? "";
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
                child: provider.salonDetails?.data.data.images.isNotEmpty ?? false
                    ? Image.network(
                  provider.salonDetails!.data.data.images[0].url,
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : Placeholder(),
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
                                                Gender.MEN
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


