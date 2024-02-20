import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/views/post_auth/utility/icon_text_selector_component.dart';
import 'package:naai/views/post_auth/utility/progress_indicator_text_component.dart';
import 'package:naai/views/post_auth/utility/rating_box_component.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<BookingScreen> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  bool multipleStaffListExpanded = false;
  bool insideMultipleStaffExpanded = false;
  int selectedRadio = 0; // Assuming 0 as the default value
 // Razorpay _razorpay = Razorpay();
  int? expandedServiceIndex;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
          body: Stack(
            children: [
              CommonWidget.appScreenCommonBackground(),
              CustomScrollView(
             //   physics: const BouncingScrollPhysics(),
                slivers: [
                  CommonWidget.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.h),
                        topRight: Radius.circular(30.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                                height: 20.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
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
                      [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: [
                              salonOverviewCard(),
                              SizedBox(height: 20.h),
                             

                              // if (provider.isOnPaymentPage) paymentComponent() else Column(
                              //         children: [
                              //           schedulingStatus(),
                              //           SizedBox(height: 2.h),
                              //           if (provider.isOnSelectStaffType)
                              //             Padding(
                              //               padding: EdgeInsets.symmetric(horizontal:2.h),
                              //               child: selectSingleStaffCard(),
                              //             ),
                              //           if (provider.isOnSelectStaffType  && !singleStaffListExpanded  )
                              //               Padding(
                              //                 padding: EdgeInsets.symmetric(
                              //                     horizontal: 2.h),
                              //                 child: Container(
                              //                   width: double.infinity,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius
                              //                         .circular(2.w),
                              //                     color: const Color(
                              //                         0xffFFB6C1),
                              //                   ),
                              //                   child: const Center(
                              //                     child: Text(
                              //                       StringConstant.Staff,
                              //                       style: TextStyle(
                              //                         fontWeight: FontWeight
                              //                             .w500,
                              //                         //     fontSize: 10.sp,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //           if (provider.isOnSelectStaffType)
                              //           SizedBox(height: 2.h),
                              //           if (provider.isOnSelectStaffType)
                              //           authenticationOptionsDivider(),
                              //           if (provider.isOnSelectStaffType)
                              //           Padding
                              //             (
                              //             padding: EdgeInsets.all(2.h),
                              //             child: selectMingleStaffCard(),
                              //           ),
                              //           if (provider.isOnSelectSlot)
                              //             slotSelectionWidget(),
                                //      ],
                                //    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
             SizedBox(height: 35.h),
              (1 != 1)
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
                          borderRadius: BorderRadius.circular(10.h),
                          boxShadow: const [
                             BoxShadow(
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
                          children: [
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
                                Text('Rs. ${499}',
                                    style: StyleConstant.appColorBoldTextStyle),
                              ],
                            ),
                            VariableWidthCta(
                              onTap: () async {
                                
                              },
                              isActive: false,
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
                      child: CustomButtons.redFullWidthButton(
                        buttonText: StringConstant.payNow,
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   NamedRoutes.bookingConfirmedRoute,
                          // );
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
    
  }

  Widget authenticationOptionsDivider() {
    return Row(
      children: [
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
    return Column(
          children: [
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
                      value: 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: 'N/A',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value: (1 != 1)
                          ? '${1} Hrs'
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
                    ...( [].map(
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
                                          (1 == 1)
                                              ? ImagePathConstant.manIcon
                                              : ImagePathConstant.womanIcon,
                                          height: 3.h,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'Title Here',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.w),
                                    Text(
                                      "Name Title Here",
                                      
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
                                      ' ₹ ${99}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                     (1 == 1) ? GestureDetector(
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
                      (1 != 1) ? const SizedBox(): Row(
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
                            Text('(${50}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color:  (1 != 1) ? ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
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
                              ' ₹ ${399}',
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
                        children: [
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${699}',
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
                  children: [
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${599}',
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
  }

  Widget artistSlotPickerDialogueBox() {
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                 // '${DateFormat.E().format(provider.selectedDate ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.selectedDate ?? DateTime.now())}',
                                  'Date Here',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            _buildTimeSlotCategory([540,570,600,630,660,690,720], "Morning"),
                            _buildTimeSlotCategory([750,780,810,840,870,900,930,960], "Afternoon"),
                            _buildTimeSlotCategory([990,1020,1050, 1080,1110,1140,1170,1200], "Evening"),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
  }
 
  String formatTime(int timeValue) {
    // Assuming timeValue is in minutes since midnight
    int hours = timeValue ~/ 60;
    int minutes = timeValue % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  Widget _buildTimeSlotCategory(List<int> timeSlots, String category) {
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
                // if (isTimeSlotAvailable(element.toString(), provider)) {
                //   provider.setBookingData(
                //     context,
                //     setSelectedTime: true,
                //     startTime: element,
                //   );
                // }
              },
              child: timeCard(formatTime(element)),
            ),
          ).toList(),
        ),
      ],
    );
  }

  bool isTimeSlotAvailable(String element) {
    return false;
    // return provider.timeslot?.timeSlots.any((timeSlot) =>
    //     timeSlot.timeSlot.any((slot) => slot.slot.contains(element))) ?? false;
  }

  Widget timeCard(String element) {
    bool isAvailable = isTimeSlotAvailable(element);
    bool isSelected = (1 != 1);

    return GestureDetector(
      onTap: () {
        // if (isAvailable) {
        //   provider.setSelectedTime(element);
        // }
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
  
  bool isTimeSlotInCategory() {
    // Implement your logic to check if the time slot belongs to the specified category (morning, afternoon, evening, night)
    // Return true if in the category, false otherwise
    // Example: return element.key == 1 && category == "Morning";
    // Adjust this logic based on your data structure
    // switch (category) {
    //   case "Morning":
    //     return element.key >= 1 && element.key <= 5;
    //   case "Afternoon":
    //     return element.key >= 6 && element.key <= 10;
    //   case "Evening":
    //     return element.key >= 11 && element.key <= 14;
    //   case "Night":
    //     return element.key >= 15 && element.key <= 18;
    //   default:
    //     return false;
    // }
    return true;
  }

  Widget slotSelectionWidget() {
    return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: [
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
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
                          // provider.showDialogue(
                          //   context,
                          //   SizedBox(
                          //     height: 35.h,
                          //     width: 40.h,
                          //     child: SfDateRangePicker(
                          //       controller: _datePickerController,
                          //       view: DateRangePickerView.month,
                          //       selectionColor: ColorsConstant.appColor,
                          //       backgroundColor: Colors.white,
                          //       headerStyle: const DateRangePickerHeaderStyle(
                          //         textAlign: TextAlign.center,
                          //       ),
                          //       initialSelectedDate: provider.selectedDate,
                          //       initialDisplayDate: DateTime.now().toLocal(),
                          //       showNavigationArrow: true,
                          //       enablePastDates: false,
                          //       onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async{
                          //         provider.setSelectedDate(args.value);
                          //         Navigator.pop(context);
                          //         if (provider.selectedDate != null && provider.salonDetails != null) {
                          //           DateTime selectedDate = provider.selectedDate!;
                          //           String formattedDate = DateFormat('MM-dd-yyyy').format(selectedDate);
                          //           List<Map<String, String>> requests = [];
                          //           List<String> selectedServiceIds = provider.getSelectedServices()
                          //               .map((service) => service.id)
                          //               .toList();
                          //             for (String serviceId in selectedServiceIds) {
                          //               String selectedArtistId = provider.artistServiceList!.selectedArtist?.artistId ??
                          //                   (provider.artistServiceList!.selectedArtistMap[serviceId]?.artistId ?? '');
                          //               requests.add({
                          //               "service": serviceId,
                          //               "artist": selectedArtistId,
                          //             });
                          //           }
                          //           Map<String, dynamic> requestBody = {
                          //             "salonId": provider.salonDetails!.data.data.id ?? "",
                          //             "requests": requests,
                          //             "date": formattedDate,
                          //           };
                          //           print('salonid is : ${provider.salonDetails!.data.data.id ?? ""}');
                          //           print('request is :$requests');
                          //           print('date is : $formattedDate');
                          //           try {
                          //             // Create Dio instance
                          //             Loader.showLoader(context);
                          //             Dio dio = Dio();
                          //             dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

                          //             // Retrieve the access token from local storage
                          //             String? authToken = await AccessTokenManager.getAccessToken();

                          //             if (authToken != null) {
                          //               dio.options.headers['Authorization'] = 'Bearer $authToken';
                          //             } else {
                          //               Loader.hideLoader(context); // Handle the case where the user is not authenticated
                          //             }
                          //             // Make the request
                          //             Response response = await dio.post(
                          //               'http://13.235.49.214:8800/appointments/schedule',
                          //               data: requestBody,
                          //             );
                          //             Loader.hideLoader(context);
                          //             // Handle the response
                          //             print(response.data);
                          //             // TODO: Process the response as needed

                          //             if (response.statusCode == 200) {
                          //               TimeSlotResponse timeSlotResponse = TimeSlotResponse.fromJson(response.data);
                          //               provider.setTimeSlot(timeSlotResponse);
                          //               print("Time Slot Response: $timeSlotResponse");
                          //               // TODO: Process the response as needed
                          //             } else {
                          //               // Handle the error
                          //               print("Failed to fetch time slots");
                          //               print(response.data);
                          //               // TODO: Handle errors appropriately
                          //             }

                          //           } catch (error) {
                          //             Loader.hideLoader(context);
                          //             // Handle errors
                          //             print('Error is $error');
                          //             // TODO: Handle errors appropriately
                          //           }
                          //         }
                          //       },
                          //       selectionMode: DateRangePickerSelectionMode.single,
                          //     ),
                          //   ),
                          // );
                        
                        },
                        fillColor: (1 == 1) ? ColorsConstant.appColor : null,
                        removeBottomPadding: false,
                        cardSelected: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: (1 == 1) ? Colors.white : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              (1 == 1)
                                  ? "Date Here"
                                  : StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: (1 != 1) ? Colors.white : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: (1 != 1) ? Colors.white : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                      ),
                      if (1 == 1)
                        Column(
                          children: [
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
                              fillColor: (1 == 1)
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              cardSelected: true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: (1 == 1)
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    (1 ==1)
                                        ? '${4} HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          (1 == 1)
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color:  (1 == 1)
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
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
  
  }
  
  Widget schedulingStatus() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: true,
              onTap: () => {},
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: true,
              onTap: () => {},
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: true,
              onTap: () => {},
            ),
          ],
        );
      
  }

  Widget selectSingleStaffCard() {
    return Column(
          children: [
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
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(singleStaffListExpanded)
                          Text(
                            (1 == 1)
                                ?  'title here'
                                : StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        if(!singleStaffListExpanded)
                          Text(
                            (1 == 1)
                                ?  'title here 2'
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
                            // setState(() {
                            //   selectedRadio = value! as int;
                            //   // Handle logic for single staff selection
                            //   singleStaffListExpanded = true;
                            //   multipleStaffListExpanded = false;
                            //   provider.currentBooking.artistId = null;
                            // });
                          },
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Scrollbar(
                      thumbVisibility: true,
                      interactive: true,
                      trackVisibility: true,
                          child: Container(
                              constraints: BoxConstraints(maxHeight: 20.h),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  // ArtistService artist = provider.artistServiceList!.artistsProvidingServices[index];
                                  
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      // setState(() {
                                      //   // Set the selected artist
                                      //   provider.artistServiceList!.selectedArtist = artist;
                                      // });
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
                                                       (1 == 1)
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
                                                  text: 'artists span',
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
                                            rating:  5.0,
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
      
  }

  Widget salonOverviewCard() {
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
                child: (1 != 1)
                    ? Image.network(
                  "url here",
                  height: 15.h,
                  width: 28.w,
                  fit: BoxFit.fill,
                )
                    : const Placeholder(),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstant.salon.toUpperCase(),
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                       'Salon Name Here',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      'Address Here',
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
  }
 
  Widget selectMingleStaffCard() {
    return Column(
          children: [
            CurvedBorderedCard(
              onTap: () => setState(() {
                    
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
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
                          height: 30.h, // Set a fixed height for the container
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              //var element = provider.getSelectedServices().toList()[index];
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
                                                (1 == 1)
                                                    ? ImagePathConstant.manIcon
                                                    : ImagePathConstant.womanIcon,
                                                height: 3.h,
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                 'Service Title Here',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: ColorsConstant.textDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.w),
                                          Text(
                                            '₹ ${499}',
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
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
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
                                                child: Scrollbar(
                                                  interactive: true,
                                                  thumbVisibility: true,
                                                  trackVisibility: true,
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    itemCount: 5,
                                                    itemBuilder: (context, index) {
                                                      //ArtistService artist = provider.artistServiceList!.artistsProvidingServices[index];
                                                      return GestureDetector(
                                                        behavior: HitTestBehavior.opaque,
                                                        onTap: () {
                                                          // setState(() {
                                                          //   provider.artistServiceList!.selectedArtistMap[element.id] = artist;
                                                          // });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: 2.w,
                                                          ),
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
                                                                          (1 == 1)
                                                                              ? ImagePathConstant.selectedOption
                                                                              : ImagePathConstant.unselectedOption,
                                                                          width: 5.w,
                                                                          fit: BoxFit.fitWidth,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:'artist',
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
                                                                rating:  0.0,
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
  }
  
  Widget selectInsideStaffCard() {
    return Column(
          children: [
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                  // InsideMultipleStaffExpanded = !InsideMultipleStaffExpanded;
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
                  //  singleStaffListExpanded
                   (1 == 1)
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            // ArtistService artist =
                            // provider.artistServiceList!.artistsProvidingServices[index];
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  // Set the selected artist
                                  // provider.artistServiceList!.selectedArtist = artist;
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
                                                   (1 == 1)
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
                                            text: 'artist',
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
                                      rating:  0.0,
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
  }

  Widget forNowselectSingleStaffCard() {
    return Column(
          children: [
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
                          (1 == 1)
                              ? ("artist name")
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
                        itemCount: 5,
                        itemBuilder: (context, index) {

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // if (provider.currentBooking.artistId ==
                              //     artist.id )
                              // {
                              //   provider.setBookingData(
                              //     context,
                              //     setArtistId: true,
                              //     artistId: null,
                              //   );
                              // } else {
                              //   provider.setBookingData(
                              //     context,
                              //     setArtistId: true,
                              //     artistId: artist.id,
                              //   );
                              // }
                              // provider.updateIsNextButtonActive();
                              // provider.resetSlotInfo();
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
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                                (1 == 1)
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
                                          text: 'artist name',
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
                                    rating: 0.0,
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



