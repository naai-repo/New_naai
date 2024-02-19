import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
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
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> screens = [
      const SelectStaff()
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
                   physics: const BouncingScrollPhysics(),
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
                             // constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height,),
                              //height: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  _salonOverviewCard(),
                                  SizedBox(height: 20.h),
                                  Builder(
                                    builder: (context) {
                                       final ctx = DefaultTabController.of(context);
                                      return TabBar(
                                         onTap: (index) {
                                              if (ctx.indexIsChanging) { 
                                                if(index != 0) ctx.index = ctx.previousIndex; 
                                              } else { 
                                                return; 
                                              }
                                          },
                                          tabs: [
                                            const Text("Select Staff"),
                                      
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

                                  SizedBox(height: 40.h),
                                  screens[0]
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
              child: Consumer<BookingServicesSalonProvider>(builder: (context, ref, child) {
                  double totalPrice = ref.totalPrice;
                  double discountPrice = ref.totalDiscountPrice;

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
              
                              // discount
                               (1 != 1) ? const SizedBox() : 
                               Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Text(totalPrice.toString(),
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: ColorsConstant.textDark,
                                        fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.lineThrough
                                      )),
                                ],
                              ),
                              VariableWidthCta(
                                onTap: () async {
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const BookingScreen()));
                                },
                                isActive: true,
                                buttonText: StringConstant.confirmBooking,
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
    //final ref = context.read<BookingServicesSalonProvider>();
    //String salonName = ref.salonDetails.data?.data?.name ?? "Salon Name";
    //String salonAddress = ref.salonDetails.data?.data?.address ?? "Salon Address Here Salon Address Here Salon Address Here Salon Address Here";
    //String salonImage = ref.salonDetails.data?.data?.images?.first.url ?? "";
    
    String salonName = "Salon Name";
    String salonAddress =  "Salon Address Here Salon Address Here Salon Address Here Salon Address Here";
    String salonImage =  "";

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
                  height: 120.h,
                  width: 120.w,
                  fit: BoxFit.fill,
                )
                    : Container(
                      color: Colors.lightBlue,
                      height: 120.h,
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
