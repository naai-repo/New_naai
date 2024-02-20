import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/api_models/scheduling_response_model.dart';
import 'package:naai/models/utility/selected_service_artists.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectSlot extends StatefulWidget {
  const SelectSlot({super.key});

  @override
  State<SelectSlot> createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {
  final DateRangePickerController _datePickerController = DateRangePickerController();
  
  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    bool isDateSelected = (ref.bookingSelectedDate.year != 1999);
    String selectedDateString = "${ref.bookingSelectedDate.day}-${ref.bookingSelectedDate.month}-${ref.bookingSelectedDate.year}";
    
    bool isSlotSelected = (ref.selectedArtistTimeSlot[0] != "00");

    return Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            children: [
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CurvedBorderedCard(
                        onTap: () async {
                          showDialogue(
                            context,
                            Container(
                              height: 350.h,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r)
                              ),
                              width: 50.h,
                              child: SfDateRangePicker(
                                controller: _datePickerController,
                                view: DateRangePickerView.month,
                                selectionColor: ColorsConstant.appColor,
                                backgroundColor: Colors.white,
                                headerStyle: const DateRangePickerHeaderStyle(
                                  textAlign: TextAlign.center,
                                ),
                                initialSelectedDate: DateTime(2024,9,7),
                                initialDisplayDate: DateTime.now().toLocal(),
                                showNavigationArrow: true,
                                enablePastDates: false,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {

                                  final selectedDate = DateTime.parse(args.value.toString().replaceAll("-", ""));
                                  String dateString = "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}";
                                  
                                   try {
                                       Loading.showLoding(context);
                                       String token = await context.read<AuthenticationProvider>().getAccessToken();
                                       final res = await BookingServices.scheduleAppointment(data: SelectedServicesArtistModel(
                                          date: dateString,
                                          salonId: ref.salonDetails.data?.data?.id ?? "",
                                          requests: ref.getSelectedServiceData()
                                       ), accessToken: token);
                                       
                                      
                                       ref.setBookingSelectedDateAndScheduleResponse(selectedDate,res);

                                   } catch (e) {
                                       if(context.mounted){
                                          showErrorSnackBar(context, "Something went wrong");
                                       }
                                   } finally{
                                      if(context.mounted){
                                         Loading.closeLoading(context);
                                         Navigator.pop(context);
                                      }
                                   }
                                },
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
                          );
                        
                        },
                        fillColor: (isDateSelected) ? ColorsConstant.appColor : null,
                        removeBottomPadding: false,
                        cardSelected: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: (1 == 1) ? Colors.white : null,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              (isDateSelected)
                                  ? selectedDateString
                                  : StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: (isDateSelected) ? Colors.white : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: (isDateSelected) ? Colors.white : ColorsConstant.textLight,
                              height: 10.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                      ),
                      //time slot pick 
                       
                      if (isDateSelected)
                        Column(
                          children: [
                            SizedBox(height: 40.h),
                            Text(
                              StringConstant.selectTimeSlot,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CurvedBorderedCard(
                              onTap: () async {
                                  showDialog(
                                    context: context, 
                                    builder: (context){
                                         return const SelectArtistTimeSlot();
                                   });
                              },
                              fillColor: (isSlotSelected) ? ColorsConstant.appColor : null,
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
                                  SizedBox(width: 10.w),
                                  Text(
                                    (isSlotSelected)
                                        ? '${ref.selectedArtistTimeSlot[0]} HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          (isSlotSelected)
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color:  (isSlotSelected)
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 10.h,
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

  void showDialogue(BuildContext context, Widget contentWidget) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (BuildContext context) {
        return Dialog(
          child: contentWidget,
        );
      },
    );
  }
}

class SelectArtistTimeSlot extends StatefulWidget {
  const SelectArtistTimeSlot({super.key});

  @override
  State<SelectArtistTimeSlot> createState() => _SelectArtistTimeSlotState();
}

class _SelectArtistTimeSlotState extends State<SelectArtistTimeSlot> {
  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: false);

    return GestureDetector(
          onTap: () => {},
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        width: 320.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 20.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(ref.bookingSelectedDate)}, ${DateFormat.yMMMMd().format(ref.bookingSelectedDate)}',
                                 // 'Date Here',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              height: 400.h,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     _buildTimeSlotCategory("morning",ref),
                                    _buildTimeSlotCategory("afternoon",ref),
                                    _buildTimeSlotCategory("evening",ref),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                       Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Select", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
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

  Widget _buildTimeSlotCategory(String category,BookingServicesSalonProvider ref) {
    List<String> slots = _breakTimeSlotsByCategory(ref.scheduleResponseData.timeSlots!.first.timeSlot,category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            category.toUpperCase(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 5.w,
          runSpacing: 10.w,
          children: slots.map((element) => timeCard(element, ref)).toList(),
        ),
        SizedBox(height: 20.h),
      ],
    );
  
  }

  List<String> _timeListByCategory(List<TimeSlotTimeSlot> slots,List<int> bounds){
    List<String> ans = [];
     for(var e in slots){
        int i = -1;
        while(++i < 2){
          int hours = int.parse(e.slot![i].substring(0,2));
          int minutes = int.parse(e.slot![i].substring(3));

          if(hours >= bounds[0] && hours < bounds[1]){
              if(!(hours == bounds[1] && minutes > 0)){
                  if(!ans.contains(e.slot![i])) ans.add(e.slot![i]);
              }
          }
        }
    }
    return ans;
  }

  List<String> _breakTimeSlotsByCategory(List<TimeSlotTimeSlot> slots,String category){
      List<String> ans = [];
      
      switch (category) {
        case "morning":
            ans = _timeListByCategory(slots,[1,12]);
         break;
        case "afternoon":
            ans = _timeListByCategory(slots,[12,16]);
         break;
        case "evening":
            ans = _timeListByCategory(slots,[16,21]);
         break;
        default:
         ans = ans;
      }

      return ans;
  }

  Widget timeCard(String element,BookingServicesSalonProvider ref){
    bool isAvailable = ref.isTimeSlotAvialable(element);
    bool isSelected = (ref.selectedArtistTimeSlot[0] == element);
    
    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          setState(() {
            ref.setArtistTimeSlot(element);
          });
        }
      },
      child: Container(
        width: 60.w,
        padding: EdgeInsets.symmetric(vertical: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.h),
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
            fontSize: 14.sp,
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
}

