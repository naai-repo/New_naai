import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/providers/post_auth/booking_screen_change_provider.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/booking/booking_confirmed/booking_confirmed_screen.dart';
import 'package:provider/provider.dart';



class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: false);
    final refUserDetails = Provider.of<AuthenticationProvider>(context,listen: false);

    // print(ref.appointmentResponseModel.booking!.amount);
    // print(ref.appointmentResponseModel.booking!.paymentAmount);

    String userName = refUserDetails.userData.name ?? "Name";
    String serviceDate = "${DateFormat.d().format(ref.bookingSelectedDate)} ${DateFormat.MMM().format(ref.bookingSelectedDate)} ${DateFormat.y().format(ref.bookingSelectedDate).substring(2)}";
    String serviceStartTime = ref.selectedArtistTimeSlot[0];
    String serviceTime = DateFormat.jm().format(DateTime(1999,9,7,int.parse(serviceStartTime.substring(0,2)),int.parse(serviceStartTime.substring(3))));
    double grandTotal = ref.totalDiscountPrice;
    final services = ref.getSelectedServiceData();
    double subTotal = ref.totalPrice;
    double discount = ref.totalPrice - ref.totalDiscountPrice;
    int discountPercentage = ref.salonDetails.data?.data?.discount ?? 0;
    

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
                                "Order Summary",
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
                                  _salonOverviewCard(ref),
                                  SizedBox(height: 20.h),

                                  SizedBox(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              color: ColorsConstant.lightAppColor,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10.w),
                                                    decoration: BoxDecoration(
                                                      border: Border(right: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("BOOKING FOR",
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xFF868686)
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Text(userName,
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                                
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10.w),
                                                    decoration: BoxDecoration(
                                                      border: Border(right: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("SERVICE DATE",
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xFF868686)
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Text(serviceDate,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                                
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10.w),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("SERVICE TIME",
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xFF868686)
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Text(serviceTime,
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 20.h),

                                          Container(
                                            padding: EdgeInsets.all(10.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("SERVICES",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFF868686)
                                                    ),
                                                  ),

                                                  SizedBox(height: 10.h),

                                                  ...List.generate(services.length, (index) {
                                                     String serviceId = services[index].service ?? "00";
                                                     String artistId = services[index].artist ?? "00";
                                                     String serviceName = ref.getSelectedServiceNameById(serviceId);
                                                     String artistName = ref.getSelectedServiceArtistNameById(artistId);
                                                     List<double> servicesPrices = [9999,9999];
                                                     List<double> artistPrices = [9999,9999];

                                                     if(services[index].variable != null){
                                                        servicesPrices = ref.getSelectedServiceAmountById(serviceId,variableId: services[index].variable?.id ?? "");
                                                        artistPrices = ref.getSelectedServiceArtistAmountById(serviceId, artistId,variableId: services[index].variable?.id ?? "");
                                                     }else{
                                                        servicesPrices = ref.getSelectedServiceAmountById(serviceId);
                                                        artistPrices = ref.getSelectedServiceArtistAmountById(serviceId, artistId);
                                                     }

                                                     double artistBasePrice = artistPrices[0];
                                                     double artistCutPrice = artistPrices[1];

                                                     double serviceBasePrice = artistPrices[0];
                                                     double serviceCutPrice = servicesPrices[1];

                                                     

                                                     double amount = serviceCutPrice;
                                                     //double artistExtaBasePrice = artistBasePrice - serviceBasePrice;
                                                     double extraArtistPrice = artistCutPrice - serviceCutPrice;
                                                     bool extraPriceWillShow = (serviceCutPrice != artistCutPrice);
                                                     
                                                    

                                                    return Container(
                                                      padding: EdgeInsets.all(5.w),
                                                      margin: EdgeInsets.only(bottom: 5.h),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(serviceName,
                                                                      softWrap: true,
                                                                      style: TextStyle(
                                                                        fontFamily: "Poppins",
                                                                        fontSize: 18.sp,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xFF373737)
                                                                      ),
                                                                  ),
                                                                ),

                                                                Text.rich(TextSpan(
                                                                  style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      fontSize: 18.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: const Color(0xFF373737)
                                                                    ),
                                                                  children: [
                                                                    WidgetSpan(child: SizedBox(width: 10.w,)),
                                                                    WidgetSpan(
                                                                      alignment: PlaceholderAlignment.middle,
                                                                      child: Icon(Icons.add,size: 18.sp,color: const Color(0xFFA7A7A7)),
                                                                    ),
                                                                    WidgetSpan(child: SizedBox(width: 2.w)),
                                                                    TextSpan(text: "Rs. ${amount.toStringAsFixed(0)}")
                                                                  ]
                                                                ))
                                                              ],
                                                            ),
                                                          ),

                                                          SizedBox(height: 5.h),
                                                          SizedBox(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                     Text.rich(
                                                                        TextSpan(
                                                                          style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF373737)
                                                                          ),
                                                                          children: [
                                                                            TextSpan(text: artistName),
                                                                          ]
                                                                        )
                                                                    ),

                                                                    if(extraPriceWillShow)
                                                                     Text.rich(
                                                                        TextSpan(
                                                                          style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xFF373737)
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: "+ Rs. ${extraArtistPrice}",
                                                                              style: TextStyle(
                                                                                color: ColorsConstant.appColor,
                                                                                fontWeight: FontWeight.w700
                                                                              )
                                                                            )
                                                                          ]
                                                                        )
                                                                    ),
                                                              ],
                                                            ),
                                                          )
                                                          
                                                          
                                                        ],
                                                      ),
                                                    );
                                                  }),

                                                  SizedBox(height: 10.h),
                                                  Divider(
                                                    color: ColorsConstant.divider,
                                                    thickness: 1.5.w,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  SizedBox(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                          Text("SUBTOTAL",
                                                              style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xFF373737)
                                                            ),
                                                          ),

                                                          Text.rich(TextSpan(
                                                                  style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      fontSize: 18.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: const Color(0xFF373737)
                                                                    ),
                                                                  children: [
                                                                    WidgetSpan(
                                                                      alignment: PlaceholderAlignment.middle,
                                                                      child: Icon(Icons.add,size: 18.sp,color: const Color(0xFFA7A7A7)),
                                                                    ),
                                                                    WidgetSpan(child: SizedBox(width: 2.w)),
                                                                    TextSpan(text: "Rs. ${subTotal.toStringAsFixed(0)}")
                                                                  ]
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                          Text.rich(TextSpan(
                                                            children: [
                                                              TextSpan(text: "DISCOUNT",
                                                              style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xFF373737)
                                                              )
                                                              ),
                                                              WidgetSpan(child: SizedBox(width: 10.w)),
                                                              TextSpan(text: "$discountPercentage%",
                                                              style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                fontSize: 18.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.lightGreen
                                                              )
                                                              ),
                                                            ]
                                                          )),
                                                          Text.rich(TextSpan(
                                                                  style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      fontSize: 18.sp,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: const Color(0xFF373737)
                                                                    ),
                                                                  children: [
                                                                    WidgetSpan(
                                                                      alignment: PlaceholderAlignment.middle,
                                                                      child: Icon(Icons.remove,size: 18.sp,color: const Color(0xFFA7A7A7)),
                                                                    ),
                                                                    WidgetSpan(child: SizedBox(width: 2.w)),
                                                                    TextSpan(text: "Rs. ${discount.toStringAsFixed(0)}")
                                                                  ]
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          
                                          SizedBox(height: 20.h),
                                          
                                          Container(
                                            padding: EdgeInsets.all(20.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("GRAND TOTAL",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF373737)
                                                  ),
                                                ),
                                                Text("Rs. ${grandTotal.toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF373737)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 40.h)
                                        ],
                                      ),
                                    )
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
     
                  return Container(
                       padding: EdgeInsets.all(10.w),
                       child: CustomButtons.redFullWidthButton(
                            buttonText: "Confirm", 
                            fillColor: ColorsConstant.appColor,
                            onTap: () async {
                                    try {
                                          Loading.showLoding(context);
        
                                          final res = await BookingServices.confirmBooking(
                                            salonId: ref.salonDetails.data?.data?.id ?? "", 
                                            confirmBookingPaylaod: ref.appointmentResponseModel, 
                                            accessToken: await context.read<AuthenticationProvider>().getAccessToken()
                                          );

                                          ref.setConfirmBookingModel(res);

                                          Future.delayed(Durations.medium1,() async {
                                             await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingConfirmedScreen()));
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
                            }, 
                            isActive: true
                        ),
                  );
              })
            )
            ),
          ),
        ),
      );
    
  }

  Widget _salonOverviewCard(BookingServicesSalonProvider ref) {
    String salonName = ref.salonDetails.data?.data?.name ?? "Salon Name";
    String salonAddress = ref.salonDetails.data?.data?.address ?? "Salon Address Here Salon Address Here Salon Address Here Salon Address Here";
    String salonImage = ref.salonDetails.data?.data?.images?.first.url ?? "";

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
                child: (salonImage.isNotEmpty)
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
              Flexible(
                child: SizedBox(
                  //height: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
 
}