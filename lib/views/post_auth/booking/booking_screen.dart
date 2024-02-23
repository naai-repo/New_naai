import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/booking_screen_change_provider.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/booking/order_summary/order_summarry.dart';
import 'package:naai/views/post_auth/booking/select_slot/select_slot.dart';
import 'package:naai/views/post_auth/booking/select_staff/route_staff_select.dart';
import 'package:provider/provider.dart';


class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<BookingScreen> {
  
  @override
  void initState() {
    super.initState();
    //final ref = context.read<BookingServicesSalonProvider>();
    //context.read<BookingScreenChangeProvider>().setScreenIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingScreenChangeProvider>(context,listen: true);

    List<Widget> screens = [
      const SelectStaff(),
      const SelectSlot()
    ];
    
    return PopScope(
        canPop: true,
        child: SafeArea(
          child: DefaultTabController(
            length: 5,
            child: Scaffold(
              body: Stack(
                children: [
                  CommonWidget.appScreenCommonBackground(),
                  CustomScrollView(
                    //physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      CommonWidget.transparentFlexibleSpace(),
                      SliverAppBar(
                        elevation: 10,
                        automaticallyImplyLeading: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.h),
                            topRight: Radius.circular(30.h),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        pinned: true,
                        floating: true,
                        leadingWidth: 0,
                        title: Container(
                          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.h),
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
                              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                              //height: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  _salonOverviewCard(),
                                  SizedBox(height: 20.h),

                                  if(ref.screenIndex < 2)
                                  Builder(
                                      builder: (context) {
                                        final ctx = DefaultTabController.of(context);
                                        ctx.index = (ref.screenIndex  == 1) ? 2 : 0;

                                        return TabBar(
                                          onTap: (index) {
                                                //extra code is implemented to prevent tabs from auto swicthing 
                                                if (ctx.indexIsChanging) { 
                                                  if(index >= ref.screenIndex){
                                                    ctx.index = ctx.previousIndex; 
                                                  }else{
                                                    ref.setScreenIndex(index);
                                                  }
                                                } else { 
                                                  return; 
                                                }
                                            },
                                            tabs: [
                                              Text(
                                                "Select Staff",
                                                style: TextStyle(
                                                  color: (ref.screenIndex >= 0) ? ColorsConstant.appColor : Colors.transparent
                                                ),
                                              ),
                                        
                                              SvgPicture.asset(
                                                  ImagePathConstant.rightArrowIcon,
                                                  height: 15.h,
                                                  width: 15.w,
                                                  color: ColorsConstant.dropShadowColor,
                                              ),

                                              const Text("Select Slot"),
                                        
                                              SvgPicture.asset(
                                                  ImagePathConstant.rightArrowIcon,
                                                  height: 15.h,
                                                  width: 15.w,
                                                  color: ColorsConstant.dropShadowColor,
                                              ),
                                              
                                              const Text("Payment"),
                                            ],
                                            automaticIndicatorColorAdjustment: false,
                                            dividerColor: Colors.transparent,
                                            indicatorColor: ColorsConstant.appColor,
                                            padding: const EdgeInsets.all(0),
                                            labelColor: ColorsConstant.appColor,
                                            labelPadding: EdgeInsets.all(10.w),
                                            labelStyle: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp
                                            ),
                                            isScrollable: true,
                                            tabAlignment: TabAlignment.center,
                                          );
                                      }
                                  ),
                                  
                                  if(ref.screenIndex < 2) SizedBox(height: 40.h),
                                  screens[ref.screenIndex]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                   ],
              ),
              bottomNavigationBar: Container(
              color: Colors.white,
              child: Consumer2<BookingServicesSalonProvider,BookingScreenChangeProvider>(builder: (context, ref,refScreenChange, child) {
                  double discountPrice = ref.totalDiscountPrice;
                  bool isActive = false;

                  if(ref.selectedStaffIndex == 0 && refScreenChange.screenIndex == 0){
                       isActive = ref.checkIsSingleStaffSelected();
                  }else if(ref.selectedStaffIndex == 1 && refScreenChange.screenIndex == 0){
                       isActive = ref.checkIsMultiStaffSelected();
                  }else if(refScreenChange.screenIndex == 1){
                       isActive = (ref.selectedArtistTimeSlot[0] != "00");
                  }
                  
                  
                  if(ref.selectedServices.isNotEmpty){
                    return Container(
                          margin: EdgeInsets.only(
                            bottom: 20.h,
                            right: 15.w,
                            left: 15.w,
                            top: 10.h
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.h),
                            border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(5, 5)
                              )
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringConstant.total,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                      color: ColorsConstant.textDark,
                                    ),
                                  ),
                                  Text('Rs. ${discountPrice.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp,
                                          color: ColorsConstant.textDark,
                                        )),
                                ],
                              ),
              
                             
                              VariableWidthCta(
                                onTap: () async {
                                   if(refScreenChange.screenIndex == 0){
                                        print(ref.getSelectedServiceData());
                                        refScreenChange.setScreenIndex(1);
                                   }else if(refScreenChange.screenIndex ==  1){
                                        try {
                                          Loading.showLoding(context);

                                          final selectedDate = ref.bookingSelectedDate;
                                          String dateString = "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}";

                                          final res = await BookingServices.makeAppointment(
                                            salonId: ref.salonDetails.data?.data?.id ?? "", 
                                            bookingDate: dateString, 
                                            selectedTimeSlot: ref.selectedArtistTimeSlot, 
                                            timeSlots: ref.scheduleResponseData.timeSlots ?? [], 
                                            accessToken: await context.read<AuthenticationProvider>().getAccessToken()
                                          );
                                          
                                         // print(res);
                                          
                                          ref.setMakeAppointmentData(res);

                                          Future.delayed(Durations.medium1,() async {
                                            await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderSummary()));
                                            if(!context.mounted) return;

                                            if(ref.confirmBookingModel.status != "false"){
                                               Navigator.pop(context);
                                            }
                                          });

                                          

                                        } catch (e) {
                                          if(context.mounted){
                                            showErrorSnackBar(context, "Something Wrent Wrong");
                                          }
                                        }finally{
                                          if(context.mounted){
                                            Loading.closeLoading(context);
                                          }
                                        }
                                   }
                                },
                                horizontalPadding: 40.w,
                                isActive: isActive,
                                buttonText: "Next",
                              )
                            ],
                          ),
                        );
                  }
                  return const SizedBox();
              })
            )
        ,
            ),
          ),
        ),
      );
    
  }

  Widget _salonOverviewCard() {
    final ref = context.read<BookingServicesSalonProvider>();
    String salonName = ref.salonDetails.data?.data?.name ?? "Salon Name";
    String salonAddress = ref.salonDetails.data?.data?.address ?? "Salon Address Here Salon Address Here Salon Address Here Salon Address Here";
    String salonImage = ref.salonDetails.data?.data?.images?.length.toString() ?? "";


    return Container(
          padding: EdgeInsets.all(15.w),
          margin: EdgeInsets.symmetric(vertical: 15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorsConstant.lightAppColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: (1 != 1)
                    ? Image.network(
                  salonImage,
                  height: 150.h,
                  width: 120.w,
                  fit: BoxFit.fill,
                )
                    : Container(
                      color: Colors.lightBlue,
                      height: 150.h,
                      width: 120.w,
                    ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstant.salon.toUpperCase(),
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      salonName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 25.sp,
                      ),
                    ),
                    Text(
                      salonAddress,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
 
}
