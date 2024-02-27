import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/providers/post_auth/booking_screen_change_provider.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/post_auth/reviews_provider.dart';
import 'package:naai/providers/post_auth/salon_services_filter_provider.dart';
import 'package:naai/providers/post_auth/single_salon_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/reviews/reviews_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/views/post_auth/booking/booking_screen.dart';
import 'package:naai/views/post_auth/salon_details/contact_and_interaction_widget.dart';
import 'package:naai/views/post_auth/utility/add_review_component.dart';
import 'package:naai/views/post_auth/utility/review_box_compnent.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';


Future<int> salonDetailFeature(BuildContext context,String salonId) async {
    final value = await SalonsServices.getSalonByID(salonId: salonId);
    if(!context.mounted) return 400;

    context.read<SingleSalonProvider>().setSalonDetails(value);
    context.read<SalonsServiceFilterProvider>().setSalonDetails(value);
    context.read<BookingServicesSalonProvider>().setSalonDetails(value);
    
    final String token = await context.read<AuthenticationProvider>().getAccessToken();
    final reviews = await ReviewsServices.getReviewsBySalonId(salonId: salonId,accessToken: token);
    if(!context.mounted) return 400;
    context.read<ReviewsProvider>().setReviews(reviews);
    context.read<BookingScreenChangeProvider>().setScreenIndex(0);

    return 200;
}

class SalonDetailsScreen extends StatefulWidget{
  final SalonResponseData salonDetails;
  const SalonDetailsScreen({Key? key,required this.salonDetails}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  int selectedTab = 0;
  num myShowPrice = 0;
  late String salonName;
  late String salonType;
  late String salonAddresss;
  late double salonRating; 
  late int salonDiscount; 
  late Timing timing;
  late String closedOn;

  late SingleSalonResponseModel salonDetails;

  @override
  void initState() {
    super.initState();
    context.read<BookingServicesSalonProvider>().resetAll(notify: false);

    salonName = widget.salonDetails.name ?? "Salon Name";
    salonType = widget.salonDetails.salonType ?? "Salon Type";
    salonAddresss = widget.salonDetails.address ?? "Salon Address";
    salonRating = widget.salonDetails.rating ?? 5;
    salonDiscount = widget.salonDetails.discount ?? 0;
    timing = widget.salonDetails.timing ?? Timing(opening: "", closing: "");
    closedOn = widget.salonDetails.closedOn ?? "closed on";
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
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
                              StringConstant.salonDetail,
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
                          imageCarousel(),
                          Container(
                            decoration: const BoxDecoration(
                                        color: Colors.white,
                            ),
                            child: FutureBuilder(
                              future: salonDetailFeature(context, widget.salonDetails.id ?? ""), 
                              builder: (context, snapshot) {
                                final ref = Provider.of<SingleSalonProvider>(context,listen: false);
                                salonDetails = ref.salonDetials;
                           
                                if(snapshot.hasData){
                                   return Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                     salonDetailOverview(),
                                     const Divider(
                                       thickness: 5,
                                       height: 0,
                                       color: ColorsConstant.graphicFillDark,
                                     ),
                                     servicesAndReviewTabBar(),
                                     // here add review container
                                     selectedTab == 0
                                         ? const ServiceFilterContainer()
                                         : ReviewContainer(isForSalon: true,salonDetails: salonDetails),
                                     ],
                                   );
                                } 
                                return SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                          child: Center(
                                          child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
                                          ),
                                 );
                              }
                            ),
                          )
                          
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
                  final refAuth = context.read<AuthenticationProvider>();
                  bool isGuest = refAuth.authData.isGuest ?? false;
    
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
                               ((ref.salonDetails.data?.data?.discount ?? 0) == 0) ? const SizedBox() : 
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
                              (!isGuest) ?
                              VariableWidthCta(
                                onTap: () async {
                                    Future.delayed(Durations.medium1,()async {
                                        await Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const BookingScreen()));
                                        if(!context.mounted) return;

                                        if(ref.confirmBookingModel.status != "false"){
                                           ref.resetAll(notify: true);
                                        }
                                     });
                                },
                                isActive: true,
                                buttonText: StringConstant.confirmBooking,
                              ) :
                               VariableWidthCta(
                                  onTap: () async {
                                      await AuthenticationConroller.logout(context);
                                  },
                                  isActive: true,
                                  fillColor: Colors.black,
                                  horizontalPadding: 50.w,
                                  buttonText: "SIGN IN",
                                )
                            ],
                          ),
                        );
                  }
                  return const SizedBox();
              })
            )
        
        ),
    );
  }

 
  Widget imageCarousel() {
    List<ImageData> images = widget.salonDetails.images ?? [];
   
    return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            height: 260.h,
            child: PageView(
              physics: const BouncingScrollPhysics(),
             //controller: provider.salonImageCarouselController,
              children:  [
                ...images.map((imageData) {
                  return Image.network(
                    imageData.url ?? "https://images.pexels.com/photos/705255/pexels-photo-705255.jpeg",
                    fit: BoxFit.cover,
                  );
                }),
              ],
            ),
          ),
          (-1) > 1
              ? Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: SmoothPageIndicator(
                    controller: PageController(),
                    count: 1,
                    effect: ExpandingDotsEffect(
                      activeDotColor: ColorsConstant.appColor,
                      dotHeight: 10.w,
                      dotWidth: 10.w,
                      spacing: 10.w,
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            top: 20.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    //   onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(10.h),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.h),
                    child: SvgPicture.asset(
                      ImagePathConstant.burgerIcon,
                      color: Colors.white,
                      height: 25.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget servicesAndReviewTabBar() {
    return Container(
      height: 70.h,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Container(
            color: Colors.white,
            child: TabBar(
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Tab(
                    child: Text(StringConstant.services.toUpperCase()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Tab(
                    child: Text(StringConstant.reviews.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget availableStaffList() {
   
    return Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringConstant.availableStaff,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsConstant.blackAvailableStaff,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 80.h,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: salonDetails.data?.artists?.map(
                        (artist) {
                        String artistName = artist.name ?? "name_here";
                        String imgUrl = artist.imageUrl ?? "";
                        double rating = artist.rating ?? 5;
                        if(imgUrl.isEmpty) imgUrl = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15.h),
                        child: GestureDetector(
                          onTap: () async {
                          
                          },
                          child: Container(
                          margin: EdgeInsets.only(
                            bottom: 5.h,
                            left:  10.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.h),
                            boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 0.1,
                            blurRadius: 20,
                          ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40.h),
                            child: Container(
                              height: 60.h,
                              width: 60.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                 imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                             Text(
                              artistName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: ColorsConstant.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: List<Widget>.generate(5,(i) => (i >
                                      int.parse(rating.toStringAsFixed(0)) -
                                          1)
                                      ? SvgPicture.asset(
                                    ImagePathConstant.starIcon,
                                    color:
                                    ColorsConstant.greyStar,
                                    height: 16.h,
                                  )
                                      : SvgPicture.asset(
                                    ImagePathConstant.starIcon,
                                    color:
                                    ColorsConstant.yellowStar,
                                    height: 16.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                         ],
                          ),
                        ),
                        ),
                      );
                    },
                  ).toList() ?? [],
                ),
              ),
            ],
          ),
        );
  }

  Widget salonDetailOverview() {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                   // width: 250.w,
                    child: Text(
                      salonName,
                      softWrap: true,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 80.w),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsConstant.greenRating,
                      borderRadius: BorderRadius.circular(5.h),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.14),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SvgPicture.asset(
                          ImagePathConstant.starIcon,
                          color: Colors.white,
                          height: 15.h,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          salonRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 salonType,
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                (1 != 1) ? const SizedBox():
                Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 15.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.appColor,
                    borderRadius: BorderRadius.circular(5.h),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.14),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "$salonDiscount% off",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            salonAddress(
              address: salonAddresss,

            ),

            salonTiming(),
            ContactAndInteractionWidget(
              iconOnePath: ImagePathConstant.phoneIcon,
              iconTwoPath: ImagePathConstant.shareIcon,
              iconThreePath:  ImagePathConstant.saveIcon,
              iconFourPath: ImagePathConstant.instagramIcon,
              onTapIconOne: () {
                 launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: StringConstant.generalContantNumber,
                    ),
                  );
              },
              onTapIconTwo: () => {
                launchUrl(
                  Uri.parse(
                    "https://play.google.com/store/apps/details?id=com.naai.flutterApp",
                  ),
                )
              },
              onTapIconThree: () {
                     
              },
              onTapIconFour: () {
                 launchUrl(
                    Uri.parse('https://www.instagram.com/naaiindia'),
                 );
              },
              backgroundColor: ColorsConstant.lightAppColor,
            ),
            SizedBox(height: 20.h),
            availableStaffList(),
          ],
        ),
      );
  }

  Widget salonTiming() {
    return Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TimeDateCard(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstant.timings,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " | ",
                      style: TextStyle(
                        color: ColorsConstant.textLight,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${timing.opening} - ${timing.closing}',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.w),
            TimeDateCard(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstant.closed,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "  |  ",
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: closedOn,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
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

  Widget salonAddress({required String address}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              "$address,  ",
              style: TextStyle(
                color: ColorsConstant.textLight,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              final coords = salonDetails.data?.data?.location?.coordinates ?? [0,0];
              navigateTo(coords[1],coords[0]);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.w),
              child: const Text('VIEW IN MAP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              color: ColorsConstant.appColor
              )
              )
            ),
          ),
        ],
      ),
    );
  }
  
  static void navigateTo(double lat, double lng) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

}

class ServiceFilterContainer extends StatefulWidget {
  const ServiceFilterContainer({super.key});

  @override
  State<ServiceFilterContainer> createState() => _ServiceFilterContainerState();
}

class _ServiceFilterContainerState extends State<ServiceFilterContainer> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<SalonsServiceFilterProvider>(context,listen: true);
    final refBooking = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    List<ServiceDataModel> services = ref.services;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              padding: EdgeInsets.all(15.h),
              decoration: const BoxDecoration(
                color: ColorsConstant.graphicFillDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  genderAndSearchFilterWidget(),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                    child: Text(
                      "${StringConstant.selectCategory}:",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ),
                  serviceCategoryFilterWidget(),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 10.h),

          (services.isEmpty)
              ? SizedBox(
            height: 100.h,
            child: const Center(
              child: Text('Nothing here :('),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {

              bool isAdded = refBooking.isServiceSelected(services[index]);
              String? title = services[index].serviceTitle ?? "No Title";
              String? discription = services[index].description ?? "Example Discription";
              double? totalPrice =  services[index].cutPrice ?? 99999;
              double? discountPrice = services[index].basePrice ?? 999999;
              String serviceType = services[index].targetGender ?? "male";

              return Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ColorsConstant.divider,width: 0.5.w))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            softWrap: true,
                            style: TextStyle(
                              color: const Color(0xFF2B2F34),
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                                serviceType == "male"
                                    ? ImagePathConstant.manIcon
                                    : ImagePathConstant.womanIcon,
                                height: 30.h,
                              )
                      ],
                    ),
                    (discription.isNotEmpty) ? SizedBox(height: 1.h) : const SizedBox(),
                    (discription.isNotEmpty) ? Text(
                      discription,
                      style: TextStyle(
                        color: const Color(0xFF8B9AAC),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      )) : const SizedBox(),
                    SizedBox(height: 10.h,),
                    RichText(text: TextSpan(
                      children: [
                          TextSpan(
                          text: "Rs. $discountPrice",
                          style: TextStyle(
                              color: const Color(0xFF373737),
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            )
                          ),
                        
                          WidgetSpan(child: SizedBox(width: 10.w,)),
                          TextSpan(
                          text: "Rs.$totalPrice",
                          style: TextStyle(
                              color: const Color(0xFF8B9AAC),
                                fontSize: 20.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                            )
                          ),
                      ]
                    )),
                    SizedBox(height: 15.h,),
                    TextButton(
                      onPressed: () async {
                        if(refBooking.isServiceSelected(services[index])){
                            refBooking.removeService(services[index]);
                            refBooking.setVariableSelected(VariableService(id: "000",variableCutPrice: 0,variablePrice: 0));
                            return;
                        }
                        if(services[index].variables?.isNotEmpty ?? false){
                            showVariablesAddingSheet(context, services[index]);
                            return;
                        }
                        refBooking.addService(services[index]);
                      }, 
                      style: TextButton.styleFrom(
                        backgroundColor: (isAdded) ? ColorsConstant.appColor : Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 8.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(color: const Color(0xFFAA2F4C),width: 1.w)
                            )
                      ),
                      child: RichText(text: TextSpan(
                        style: TextStyle(
                          color: (isAdded) ? Colors.white : const Color(0xFFAA2F4C),
                          fontSize: 18.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon((!isAdded) ? Icons.add : Icons.remove,
                              size: 20.sp,color: (isAdded) ? Colors.white : const Color(0xFFAA2F4C),)),
                            WidgetSpan(child: SizedBox(width: 5.w,)),
                              TextSpan(
                                text: (!isAdded) ? "Add" : "Remove"
                            )
                          ]
                      ))
                    ),
                  
                  ],
                ),
              );
        
            },
          ),
       
      ],
    );
  }

  Widget genderButtons(String type) {
    final ref = context.read<SalonsServiceFilterProvider>();
    bool isMen = (type == "male");

    return GestureDetector(
        onTap: () async {
            if(ref.genderType != type){
               ref.filterByGender(type);
            }else{
               ref.resetGenderFilter();
            }
        },
        child: Container(
          margin: EdgeInsets.only(right: 10.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
          color: (ref.genderType == type) ? ColorsConstant.selectedGenderFilterBoxColor : Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: (ref.genderType == type) ?ColorsConstant.appColor :ColorsConstant.divider
          )
          ),
          child: Row(
            children: [
              Container(
                height: 25.h,
                width: 25.h,
                margin: EdgeInsets.only(right: 10.w),
                child: SvgPicture.asset(
                  isMen
                      ? ImagePathConstant.manGenderTypeIcon
                      : ImagePathConstant.womanGenderTypeIcon,
                ),
              ),
              Text(
                isMen ? StringConstant.men : StringConstant.women,
                style: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    
  }
  
  Widget genderAndSearchFilterWidget() {
    final ref = context.read<SalonsServiceFilterProvider>();

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 60.h,
            child: Row(
              children: [
                genderButtons("male"),
                genderButtons("female"),
              ],
            ),
          ),
          SizedBox(
            width: 150.w,
            height: 45.h,
            child: TextFormField(
              controller: _searchController,
              cursorColor: ColorsConstant.appColor,
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsConstant.textDark,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (searchText) {
                    ref.filterBySearch(searchText);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 20.w,right: 10.w),
                  child: SvgPicture.asset(
                    ImagePathConstant.searchIcon,
                    color: ColorsConstant.textDark,
                    height: 14.sp,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 20.w),
                hintText: StringConstant.search,
                hintStyle: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.h),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
  }
  
  Widget serviceCategoryFilterWidget() {
    final ref = context.read<SalonsServiceFilterProvider>();
    
    return SizedBox(
        height: 42.h,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: ref.categories.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
                 if(!ref.selectedCategoryIndex.contains(index)){
                     ref.filterByCategory(index);
                 }else{
                     ref.resetCategoryFilterByIndex(index);
                 }
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              height: 42.h,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 7.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.h),
                  color: (ref.selectedCategoryIndex.contains(index))
                      ? ColorsConstant.appColor
                      : Colors.white,
                ),
              child: Center(
                child: Text(
                  ref.categories[index].toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: (ref.selectedCategoryIndex.contains(index))
                        ? Colors.white
                        : ColorsConstant.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
  
  void showVariablesAddingSheet(BuildContext context,ServiceDataModel service){
     String categoryName = service.category ?? "Category Name Hare";
     String discription = service.description ?? "Discription Here Discription Here Discription Here Discription Here Discription Here";
     String targetGender = service.targetGender ?? "male";
  
     final variables = service.variables ?? [];

     Map<String,List<VariableService>> uniqueVariablesMap = {};

     for(var e in variables){
         uniqueVariablesMap[e.variableType!] = [...(uniqueVariablesMap[e.variableType] ?? []), e];
     }

     List<List<VariableService>> uniqueVariables = [];
     uniqueVariablesMap.forEach((key, value) {
         uniqueVariables.add(value);
     });

     showModalBottomSheet(
       context: context, 
       useRootNavigator: true,
       isScrollControlled: true,
       useSafeArea: true,
       constraints: BoxConstraints.tightFor(height: 620.h),
       elevation: 11,
       builder: (context){
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Container(
               color: const Color(0xFFF2F4F7),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(15.w),
                          
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(categoryName.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700
                                      ),
                                     ),
                                     SvgPicture.asset(
                                        targetGender == "male"
                                            ? ImagePathConstant.manIcon
                                            : ImagePathConstant.womanIcon,
                                        height: 30.h,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(discription,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: const Color(0xFF8C9AAC),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: VariableSelectionContainer(service: service,uniqueVariables: uniqueVariables)
                      ),
                       Flexible(
                       // flex: 1,
                        fit: FlexFit.loose,
                        child: VariableAddServiceContainer(service: service)
                        )
                   
                   ],
               ),
            ),
          );
       }
     );
  }

  
}

class VariableSelectionContainer extends StatefulWidget {
  final ServiceDataModel service;
  final List<List<VariableService>> uniqueVariables;
  const VariableSelectionContainer({super.key, required this.service, required this.uniqueVariables});

  @override
  State<VariableSelectionContainer> createState() => _VariableSelectionContainerState();
}

class _VariableSelectionContainerState extends State<VariableSelectionContainer> {
  late ServiceDataModel service;
  late List<List<VariableService>> uniqueVariables;

  @override
  void initState() {
    super.initState();
    service = widget.service;
    uniqueVariables = widget.uniqueVariables;
  }

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    
    return SingleChildScrollView(
            child: Column(
              children: List.generate(uniqueVariables.length, (index){
                  String subCategoryName = uniqueVariables[index].first.variableType ?? "SubCategory";
                  
                  return Container(
                    clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: EdgeInsets.all(15.w),
                              child: Text(subCategoryName.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: uniqueVariables[index].length,
                                itemBuilder: (context,idx){
                                    String serviceName = uniqueVariables[index][idx].variableName ?? "ServiceName";
                                    //int totalPrice = uniqueVariables[index][idx].variablePrice ?? 99999;
                                    double totalDiscountPrice = uniqueVariables[index][idx].variablePrice ?? 99999;
                                    bool isAdded = (uniqueVariables[index][idx].id == ref.variableSelected.id);

                                    return Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () async {
                                            ref.setVariableSelected(uniqueVariables[index][idx]);
                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 20.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Text(serviceName,
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: const Color(0xFF8C9AAC),
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w700
                                                    ),
                                                ),
                                                                                      
                                                Text.rich(TextSpan(
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.black,
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                  children: [
                                                      WidgetSpan(
                                                        alignment: PlaceholderAlignment.middle,
                                                        child: Icon(Icons.add,color: Colors.black,size: 20.sp,)),
                                                      TextSpan(text: " Rs. $totalDiscountPrice"),
                                                      WidgetSpan(child: SizedBox(width: 1.w)),
                                                      WidgetSpan(
                                                        alignment: PlaceholderAlignment.middle,
                                                        child: Radio(
                                                        value: (isAdded) ? 1 : 0, 
                                                        groupValue: 1, 
                                                        activeColor: ColorsConstant.appColor,
                                                        onChanged: (v){
                                                          ref.setVariableSelected(uniqueVariables[index][idx]);
                                                        }
                                                      ))
                                                  ]
                                                ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                              
                                },
                              ),
                            )
            
                        ],
                      ),
                  );
              })
                                  ,
            ),
        );
  }
}

class VariableAddServiceContainer extends StatelessWidget {
  final ServiceDataModel service;
  const VariableAddServiceContainer({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    final variable = ref.variableSelected;
    
    return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w),bottom: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Rs. ${variable.variablePrice}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700
                          ),
                  ),
                  TextButton(
                    onPressed: () async {
                        ref.addService(service.copyWith(variables: [variable]));
                        Navigator.pop(context);
                    }, 
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 8.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: const Color(0xFFAA2F4C),width: 1.w)
                        )
                    ),
                    child: RichText(text: TextSpan(
                      style: TextStyle(
                        color: const Color(0xFFAA2F4C),
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Icons.add,
                            size: 20.sp,
                            color: const Color(0xFFAA2F4C),)),
                          WidgetSpan(child: SizedBox(width: 5.w,)),
                          const TextSpan(
                              text: "Add"
                          )
                        ]
                    ))
                  ),
                              
                ],
              ),
            ),
          );
  }
}


