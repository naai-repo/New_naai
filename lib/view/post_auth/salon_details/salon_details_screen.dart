import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/post_auth/salon_details/salon_review_container.dart';
import 'package:naai/view/widgets/contact_and_interaction_widget.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/salon_detail.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_response.dart';
import '../../../utils/enums.dart';
import '../../../utils/loading_indicator.dart';
import '../../../view_model/post_auth/barber/barber_provider.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  int selectedTab = 0;
  num myShowPrice = 0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SalonDetailsProvider>().clearSelectedGendersFilter();
        context.read<SalonDetailsProvider>().clearSearchController();
        context.read<SalonDetailsProvider>().clearSelectedServiceCategories();
        context.read<SalonDetailsProvider>().clearfilteredServiceList();
        context.read<SalonDetailsProvider>().clearServiceList();
        return true;
      },
      child: Consumer<SalonDetailsProvider>(
          builder: (context, provider, child) {
       //     ApiResponse? salonDetails = provider.salonDetails; // Use the instance obtained from the context
            if (provider.salonDetails!.data.data.discount == 0 ||
                provider.salonDetails!.data.data.discount == null){
              myShowPrice = provider.totalPrice;
            }
            else{
              provider.setShowPrice(provider.totalPrice,provider.salonDetails!.data.data.discount!);
              myShowPrice = provider.showPrice;
            }
            bool servicesSelected = provider.getSelectedServices().isNotEmpty;
            return Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
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
                      <Widget>[
                        imageCarousel(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            salonDetailOverview(),
                              Divider(
                                thickness: 5,
                                height: 0,
                                color: ColorsConstant.graphicFillDark,
                              ),
                              selectedTab == 0
                                  ? servicesTab()
                                  : SalonReviewContainer(),
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
          bottomNavigationBar: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              servicesAndReviewTabBar(),
                if (servicesSelected)
                   Container(
                      margin: EdgeInsets.only(
                        bottom: 2.h,
                        right: 5.w,
                        left: 5.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 3.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        boxShadow: <BoxShadow>[
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
                              Text('Rs.${myShowPrice}',
                                  style: StyleConstant.textDark15sp600Style),
                            ],
                          ),
                          provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?SizedBox():Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Text('${provider.totalPrice}',
                                  style: StyleConstant
                                      .textDark12sp500StyleLineThrough),
                            ],
                          ),
                          VariableWidthCta(
                            onTap: () async {
                              String salonId = provider.salonDetails!.data.data.id;
                              List<String> selectedServiceIds = provider.getSelectedServices()
                                  .map((service) => service.id)
                                  .toList();
                              await provider.fetchArtistListAndNavigate(context,salonId, selectedServiceIds);
                            },
                            isActive: true,
                            buttonText: StringConstant.confirmBooking,
                          )
                        ],
                      ),
                    )
                 // : SizedBox()
            ],
          ),
        );
      }),
    );
  }
  static Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => provider.setSelectedGendersFilter(
            selectedGender: isMen ? Gender.MEN : Gender.WOMEN),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: provider.selectedGendersFilter.isEmpty
                ? Colors.white
                : isMen
                ? provider.selectedGendersFilter.contains(Gender.MEN)
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white
                : provider.selectedGendersFilter.contains(Gender.WOMEN)
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white,
            borderRadius: BorderRadius.circular(1.5.w),
            border: Border.all(
              color: provider.selectedGendersFilter.isEmpty
                  ? ColorsConstant.divider
                  : isMen
                  ? provider.selectedGendersFilter.contains(Gender.MEN)
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider
                  : provider.selectedGendersFilter.contains(Gender.WOMEN)
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider,
            ),
            boxShadow: provider.selectedGendersFilter.isEmpty
                ? null
                : isMen
                ? provider.selectedGendersFilter.contains(Gender.MEN)
                ? [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.14),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null
                : provider.selectedGendersFilter.contains(Gender.WOMEN)
                ? [
              BoxShadow(
                color: ColorsConstant.dropShadowColor,
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 3.h,
                width: 3.h,
                margin: EdgeInsets.only(right: 1.5.w),
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
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  static Widget genderAndSearchFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 5.h,
            child: Row(
              children: <Widget>[
                genderFilterTabs(isMen: true, isWomen: false),
                genderFilterTabs(isMen: false, isWomen: true),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
            height: 4.5.h,
            child: TextFormField(
              controller: provider.searchController,
              cursorColor: ColorsConstant.appColor,
              style: TextStyle(
                fontSize: 11.sp,
                color: ColorsConstant.textDark,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (searchText) =>
                  provider.filterOnSearchText(searchText),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 0.5.w),
                  child: SvgPicture.asset(
                    ImagePathConstant.searchIcon,
                    color: ColorsConstant.textDark,
                    height: 10.sp,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 9.w),
                hintText: StringConstant.search,
                hintStyle: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.h),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
   Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
    //  List<DataService> selectedServices = [];
      Set<ServicesWithoutSubCategory> selectedServices = provider.getSelectedServices();

      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // provider.filteredServiceList.length == 0;
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  genderAndSearchFilterWidget(),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 1.h),
                    child: Text(
                      "${StringConstant.selectCategory}:",
                      style: TextStyle(
                        fontSize: 10.sp,
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
          SizedBox(height: 1.h),
          provider.salonDetails!.data.services.servicesWithoutSubCategory.length == 0
              ? Container(
            height: 10.h,
            child: Center(
              child: Text('Nothing here :('),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.salonDetails!.data.services.servicesWithoutSubCategory.length,
            itemBuilder: (context, index) {
              ServicesWithoutSubCategory? serviceDetail =
              provider.salonDetails!.data.services.servicesWithoutSubCategory[index];
              return GestureDetector(
                onTap: () {
                 //logic for to tap and checked the checkbox
                  provider.toggleSelectedService(serviceDetail!);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 3.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(color: ColorsConstant.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 50.w,
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              serviceDetail.targetGender == 'male'
                                  ? ImagePathConstant.manIcon
                                  : ImagePathConstant.womanIcon,
                              height: 4.h,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                serviceDetail.serviceTitle ?? "",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rs. ${serviceDetail.basePrice}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Checkbox(
                            value: selectedServices.contains(serviceDetail),
                            activeColor: ColorsConstant.appColor,
                            side: BorderSide(
                              color: Color.fromARGB(255, 193, 193, 193),
                              width: 2,
                            ),
                            onChanged: (value) {

                              provider.toggleSelectedService(serviceDetail!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
        ],
      );
    });
  }
   Widget serviceCategoryFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        height: 4.2.h,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: Services.values.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              provider.setSelectedServiceCategories(
                selectedServiceCategory: Services.values[index],
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              height: 4.2.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: provider.selectedServiceCategories
                    .contains(Services.values[index])
                    ? ColorsConstant.appColor
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "${Services.values[index].name}",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: provider.selectedServiceCategories
                        .contains(Services.values[index])
                        ? Colors.white
                        : ColorsConstant.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget imageCarousel() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            height: 35.h,
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: provider.salonImageCarouselController,
              children: <Widget>[
                ...provider.salonDetails!.data.data.images.map((imageData) {
                  return Image.network(
                    imageData.url,
                    fit: BoxFit.cover,
                  );
                }),
              ],
            ),
          ),
          (provider.imageList.length) > 1
              ? Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: SmoothPageIndicator(
                    controller: provider.salonImageCarouselController,
                    count: provider.imageList!.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: ColorsConstant.appColor,
                      dotHeight: 2.w,
                      dotWidth: 2.w,
                      spacing: 2.w,
                    ),
                  ),
                )
              : SizedBox(),
          Positioned(
            top: 5.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    //   onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: SvgPicture.asset(
                      ImagePathConstant.burgerIcon,
                      color: Colors.white,
                      height: 2.5.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget servicesAndReviewTabBar() {
    return Container(
      height: 7.h,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.white,
            child: TabBar(
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.services.toUpperCase()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.reviews.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availableStaffList() {
    return Consumer2<SalonDetailsProvider, HomeProvider>(
      builder: (context, provider,homeprovider, child) {
        return Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                StringConstant.availableStaff,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorsConstant.blackAvailableStaff,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 11.h,
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: provider.salonDetails?.data.artists.map(
                        (artist) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(1.5.h),
                        child: GestureDetector(
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                           List<dynamic> services = artist.services;
                            BarberProvider barberDetailsProvider = context.read<BarberProvider>();

                            try {
                              Loader.showLoader(context);

                              // Prepare a list of Futures for all API calls
                              List<Future<Response<dynamic>>> apiCalls = [
                                Dio().get('http://13.235.49.214:8800/partner/artist/single/$artistId'),
                                Dio().get('http://13.235.49.214:8800/partner/salon/single/$salonId'),
                                // You may want to modify this part based on how you want to handle multiple services
                                if (services.isNotEmpty) ...services.map((service) =>
                                    Dio().get('http://13.235.49.214:8800/partner/service/single/${service.serviceId}'))
                              ];

                              // Use Future.wait to run multiple async operations concurrently
                              List<Response<dynamic>> responses = await Future.wait(apiCalls);

                              Loader.hideLoader(context);

                              // Check the responses for each API call
                              for (var response in responses) {
                                if (response.data != null && response.data is Map<String, dynamic>) {
                                  if (response.requestOptions.uri.pathSegments.contains('artist')) {
                                    // Process artist API response
                                    ArtistResponse apiResponse = ArtistResponse.fromJson(response.data);
                                    if (apiResponse != null && apiResponse.data != null) {
                                      barberDetailsProvider.setArtistDetails(apiResponse.data);
                                    } else {
                                      print('Failed to fetch artist details: Invalid response format');
                                    }
                                  } else if (response.requestOptions.uri.pathSegments.contains('salon')) {
                                    // Process salon API response
                                    ApiResponse apiResponse = ApiResponse.fromJson(response.data);
                                    ApiResponse salonDetails = ApiResponse(
                                      status: apiResponse.status,
                                      message: apiResponse.message,
                                      data: ApiResponseData(
                                        data: apiResponse.data.data,
                                        artists: apiResponse.data.artists,
                                        services: apiResponse.data.services,
                                      ),
                                    );
                                    salonDetailsProvider.setSalonDetails(salonDetails);
                                    barberDetailsProvider.setSalonDetails(salonDetails);
                                  } else if (response.requestOptions.uri.pathSegments.contains('service')) {
                                    ServiceResponse serviceResponse = ServiceResponse.fromJson(response.data);
                                    ServiceResponse serviceresponse = ServiceResponse(
                                        status: serviceResponse.status,
                                        message: serviceResponse.message,
                                        data:    serviceResponse.data);
                                    salonDetailsProvider.setServiceDetails(serviceresponse);
                                    if (serviceResponse != null && serviceResponse.data != null) {
                                      // Handle service response
                                    } else {
                                      print('Failed to fetch service details: Invalid response format');
                                    }
                                  }
                                } else {
                                  print('Failed to fetch details: Invalid response format');
                                }
                              }

                              // If the API calls are successful, navigate to the next screen
                              Navigator.pushNamed(context, NamedRoutes.barberProfileRoute, arguments: artistId);
                            } catch (error) {
                              Loader.hideLoader(context);
                              // Handle the case where the API call was not successful
                              // You can show an error message or take appropriate action
                              Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                              print('Failed to fetch details: $error');
                            }
                          },
                          child: Container(
                          margin: EdgeInsets.only(
                            bottom: 0.5.h,
                            left:  2.5.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.5.h),
                            boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 0.1,
                            blurRadius: 20,
                          ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.h),
                            child: Container(
                              height: 7.h,
                              width: 7.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                artist.imageUrl ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                              SizedBox(width: 3.w),
                          SizedBox(height: 3.w),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                             Text(
                              artist.name ?? "",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: List<Widget>.generate(
                                  5,
                                      (i) => (i >
                                      int.parse(artist.rating
                                          ?.round()
                                          .toString() ??
                                          "0") -
                                          1)
                                      ? SvgPicture.asset(
                                    ImagePathConstant.starIcon,
                                    color:
                                    ColorsConstant.greyStar,
                                    height: 2.h,
                                  )
                                      : SvgPicture.asset(
                                    ImagePathConstant.starIcon,
                                    color:
                                    ColorsConstant.yellowStar,
                                    height: 2.h,
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
      },
    );
  }


  Widget salonDetailOverview() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      //ApiResponse? salonDetails = provider.salonDetails;


      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 5.w,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50.w,
                  child: Text(
                    provider.salonDetails!.data.data.name,
                    style: TextStyle(
                      color: ColorsConstant.textDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 0.8.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.greenRating,
                    borderRadius: BorderRadius.circular(0.5.h),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.14),
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
                        height: 2.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        // TODO:
                        provider.salonDetails!.data.data.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.salonDetails!.data.data.salonType ?? "",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?SizedBox():Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 0.8.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.appColor,
                    borderRadius: BorderRadius.circular(0.5.h),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.14),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        // TODO:
                        provider.salonDetails!.data.data.discount
                            .toString() +
                            "% off",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            salonAddress(
              address: provider.salonDetails!.data.data.address ,
              geoPoint: provider.salonDetails!.data.data.location != null
                  ? GeoPoint(
                provider.salonDetails!.data.data.location!.coordinates[1], // Assuming latitude is at index 1
                provider.salonDetails!.data.data.location!.coordinates[0], // Assuming longitude is at index 0
              )
                  : GeoPoint(0.0, 0.0),

            ),

            salonTiming(),
            ContactAndInteractionWidget(
              iconOnePath: ImagePathConstant.phoneIcon,
              iconTwoPath: ImagePathConstant.shareIcon,
              iconThreePath:  ImagePathConstant.saveIcon,
              iconFourPath: ImagePathConstant.instagramIcon,
              onTapIconOne: () => launchUrl(
                Uri(
                  scheme: 'tel',
                  path: StringConstant.generalContantNumber,
                ),
              ),
              onTapIconTwo: () => launchUrl(
                Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.naai.flutterApp",
                ),
              ),
              onTapIconThree: () {
                if (!context
                    .read<HomeProvider>()
                    .userData
                    .preferredSalon!
                    .contains(provider.salonId)) {
                  provider.addPreferedSalon(
                    context,
                      provider.salonId
                  );
                } else {
                 // provider.removePreferedSalon(
                 //   context,

                //  );
                }
              },
              onTapIconFour: () => launchUrl(
                Uri.parse(provider.salonDetails!.data.data.links.instagram ??
                    'https://www.instagram.com/naaiindia'),
              ),
              backgroundColor: ColorsConstant.lightAppColor,
            ),
            SizedBox(height: 2.h),
            availableStaffList(),
          ],
        ),
      );
    });
  }

  Widget salonTiming() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      ApiResponse? salonDetails = provider.salonDetails;

      if (salonDetails == null) {
        // Handle the case where salonDetails is null
        return Center(child: Text('Failed to load salon details.'));
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 3.h),
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
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " | ",
                      style: TextStyle(
                        color: ColorsConstant.textLight,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${provider.salonDetails!.data.data.timing.opening} - ${provider.salonDetails!.data.data.timing.closing}',
                      //       "${provider.formatTime(provider.selectedSalonData.createdAt )} - ${provider.formatTime(provider.selectedSalonData.timing!.closing ?? 0)}",
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.w),
            TimeDateCard(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstant.closed,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "  |  ",
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: salonDetails.data.data.closedOn,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
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
    });
  }

  Widget salonAddress({required String address, required GeoPoint geoPoint}) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              "$address,  ",
              style: TextStyle(
                color: ColorsConstant.textLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              navigateTo(
                geoPoint.latitude,
                geoPoint.longitude,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 1.w),
              child: Text('VIEW IN MAP',
              style:TextStyle(
                fontWeight: FontWeight.bold,
              color:ColorsConstant.appColor
              )
              )
            ),
          ),
        ],
      ),
    );
  }

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}


class SalonDetailsScreen2 extends StatefulWidget {
  const SalonDetailsScreen2({Key? key}) : super(key: key);

  @override
  State<SalonDetailsScreen2> createState() => _SalonDetailsScreen2State();
}

class _SalonDetailsScreen2State extends State<SalonDetailsScreen2> {
  int selectedTab = 0;
  num myShowPrice = 0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SalonDetailsProvider>().clearSelectedGendersFilter();
        context.read<SalonDetailsProvider>().clearSearchController();
        context.read<SalonDetailsProvider>().clearSelectedServiceCategories();
        context.read<SalonDetailsProvider>().clearfilteredServiceList();
        context.read<SalonDetailsProvider>().clearServiceList();
        return true;
      },
      child: Consumer<SalonDetailsProvider>(
          builder: (context, provider, child) {
            //     ApiResponse? salonDetails = provider.salonDetails; // Use the instance obtained from the context
            if (provider.salonDetails!.data.data.discount == 0 ||
                provider.salonDetails!.data.data.discount == null){
              myShowPrice = provider.totalPrice;
            }
            else{
              provider.setShowPrice(provider.totalPrice,provider.salonDetails!.data.data.discount!);
              myShowPrice = provider.showPrice;
            }
            bool servicesSelected = provider.getSelectedServices().isNotEmpty;
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  ReusableWidgets.appScreenCommonBackground(),
                  CustomScrollView(
                    physics: BouncingScrollPhysics(),
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
                          <Widget>[
                            imageCarousel(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  salonDetailOverview(),
                                  Divider(
                                    thickness: 5,
                                    height: 0,
                                    color: ColorsConstant.graphicFillDark,
                                  ),
                                  selectedTab == 0
                                      ? servicesTab()
                                      : SalonReviewContainer2(),
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
              bottomNavigationBar: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  servicesAndReviewTabBar(),
                  if (servicesSelected)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 2.h,
                        right: 5.w,
                        left: 5.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 3.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        boxShadow: <BoxShadow>[
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
                              Text('Rs.${myShowPrice}',
                                  style: StyleConstant.textDark15sp600Style),
                            ],
                          ),
                          provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?SizedBox():Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Text('${provider.totalPrice}',
                                  style: StyleConstant
                                      .textDark12sp500StyleLineThrough),
                            ],
                          ),
                          VariableWidthCta(
                            onTap: () async {
                              String salonId = provider.salonDetails!.data.data.id;
                              List<String> selectedServiceIds = provider.getSelectedServices()
                                  .map((service) => service.id)
                                  .toList();
                           //   await provider.fetchArtistListAndNavigate(context,salonId, selectedServiceIds);
                              showSignInDialog(context);
                            },
                            isActive: true,
                            buttonText: StringConstant.confirmBooking,
                          )
                        ],
                      ),
                    )
                  // : SizedBox()
                ],
              ),
            );
          }),
    );
  }
  static Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => provider.setSelectedGendersFilter(
            selectedGender: isMen ? Gender.MEN : Gender.WOMEN),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: provider.selectedGendersFilter.isEmpty
                ? Colors.white
                : isMen
                ? provider.selectedGendersFilter.contains(Gender.MEN)
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white
                : provider.selectedGendersFilter.contains(Gender.WOMEN)
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white,
            borderRadius: BorderRadius.circular(1.5.w),
            border: Border.all(
              color: provider.selectedGendersFilter.isEmpty
                  ? ColorsConstant.divider
                  : isMen
                  ? provider.selectedGendersFilter.contains(Gender.MEN)
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider
                  : provider.selectedGendersFilter.contains(Gender.WOMEN)
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider,
            ),
            boxShadow: provider.selectedGendersFilter.isEmpty
                ? null
                : isMen
                ? provider.selectedGendersFilter.contains(Gender.MEN)
                ? [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.14),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null
                : provider.selectedGendersFilter.contains(Gender.WOMEN)
                ? [
              BoxShadow(
                color: ColorsConstant.dropShadowColor,
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 3.h,
                width: 3.h,
                margin: EdgeInsets.only(right: 1.5.w),
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
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  static Widget genderAndSearchFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 5.h,
            child: Row(
              children: <Widget>[
                genderFilterTabs(isMen: true, isWomen: false),
                genderFilterTabs(isMen: false, isWomen: true),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
            height: 4.5.h,
            child: TextFormField(
              controller: provider.searchController,
              cursorColor: ColorsConstant.appColor,
              style: TextStyle(
                fontSize: 11.sp,
                color: ColorsConstant.textDark,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (searchText) =>
                  provider.filterOnSearchText(searchText),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 0.5.w),
                  child: SvgPicture.asset(
                    ImagePathConstant.searchIcon,
                    color: ColorsConstant.textDark,
                    height: 10.sp,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 9.w),
                hintText: StringConstant.search,
                hintStyle: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.h),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
  Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      //  List<DataService> selectedServices = [];
      Set<ServicesWithoutSubCategory> selectedServices = provider.getSelectedServices();

      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // provider.filteredServiceList.length == 0;
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  genderAndSearchFilterWidget(),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 1.h),
                    child: Text(
                      "${StringConstant.selectCategory}:",
                      style: TextStyle(
                        fontSize: 10.sp,
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
          SizedBox(height: 1.h),
          provider.salonDetails!.data.services.servicesWithoutSubCategory.length == 0
              ? Container(
            height: 10.h,
            child: Center(
              child: Text('Nothing here :('),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.salonDetails!.data.services.servicesWithoutSubCategory.length,
            itemBuilder: (context, index) {
              ServicesWithoutSubCategory? serviceDetail =
              provider.salonDetails!.data.services.servicesWithoutSubCategory[index];
              return GestureDetector(
                onTap: () {
                  //logic for to tap and checked the checkbox
                  provider.toggleSelectedService(serviceDetail!);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 3.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(color: ColorsConstant.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 50.w,
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              serviceDetail.targetGender == Gender.MEN
                                  ? ImagePathConstant.manIcon
                                  : ImagePathConstant.womanIcon,
                              height: 4.h,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                serviceDetail.serviceTitle ?? "",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rs. ${serviceDetail.basePrice}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Checkbox(
                            value: selectedServices.contains(serviceDetail),
                            activeColor: ColorsConstant.appColor,
                            side: BorderSide(
                              color: Color.fromARGB(255, 193, 193, 193),
                              width: 2,
                            ),
                            onChanged: (value) {

                              provider.toggleSelectedService(serviceDetail!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
        ],
      );
    });
  }
  Widget serviceCategoryFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        height: 4.2.h,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: Services.values.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              provider.setSelectedServiceCategories(
                selectedServiceCategory: Services.values[index],
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              height: 4.2.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: provider.selectedServiceCategories
                    .contains(Services.values[index])
                    ? ColorsConstant.appColor
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "${Services.values[index].name}",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: provider.selectedServiceCategories
                        .contains(Services.values[index])
                        ? Colors.white
                        : ColorsConstant.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget imageCarousel() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            height: 35.h,
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: provider.salonImageCarouselController,
              children: <Widget>[
                ...provider.salonDetails!.data.data.images.map((imageData) {
                  return Image.network(
                    imageData.url,
                    fit: BoxFit.cover,
                  );
                }),
              ],
            ),
          ),
          (provider.imageList.length) > 1
              ? Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: SmoothPageIndicator(
              controller: provider.salonImageCarouselController,
              count: provider.imageList!.length,
              effect: ExpandingDotsEffect(
                activeDotColor: ColorsConstant.appColor,
                dotHeight: 2.w,
                dotWidth: 2.w,
                spacing: 2.w,
              ),
            ),
          )
              : SizedBox(),
          Positioned(
            top: 5.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    //   onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: SvgPicture.asset(
                      ImagePathConstant.burgerIcon,
                      color: Colors.white,
                      height: 2.5.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget servicesAndReviewTabBar() {
    return Container(
      height: 7.h,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.white,
            child: TabBar(
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.services.toUpperCase()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.reviews.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availableStaffList() {
    return Consumer2<SalonDetailsProvider, HomeProvider>(
      builder: (context, provider,homeprovider, child) {
        return Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                StringConstant.availableStaff,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorsConstant.blackAvailableStaff,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 11.h,
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: provider.salonDetails?.data.artists.map(
                        (artist) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(1.5.h),
                        child: GestureDetector(
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<dynamic> services = artist.services;
                            BarberProvider barberDetailsProvider = context.read<BarberProvider>();

                            try {
                              Loader.showLoader(context);

                              // Prepare a list of Futures for all API calls
                              List<Future<Response<dynamic>>> apiCalls = [
                                Dio().get('http://13.235.49.214:8800/partner/artist/single/$artistId'),
                                Dio().get('http://13.235.49.214:8800/partner/salon/single/$salonId'),
                                // You may want to modify this part based on how you want to handle multiple services
                                if (services.isNotEmpty) ...services.map((service) =>
                                    Dio().get('http://13.235.49.214:8800/partner/service/single/${service.serviceId}'))
                              ];

                              // Use Future.wait to run multiple async operations concurrently
                              List<Response<dynamic>> responses = await Future.wait(apiCalls);

                              Loader.hideLoader(context);

                              // Check the responses for each API call
                              for (var response in responses) {
                                if (response.data != null && response.data is Map<String, dynamic>) {
                                  if (response.requestOptions.uri.pathSegments.contains('artist')) {
                                    // Process artist API response
                                    ArtistResponse apiResponse = ArtistResponse.fromJson(response.data);
                                    if (apiResponse != null && apiResponse.data != null) {
                                      barberDetailsProvider.setArtistDetails(apiResponse.data);
                                    } else {
                                      print('Failed to fetch artist details: Invalid response format');
                                    }
                                  } else if (response.requestOptions.uri.pathSegments.contains('salon')) {
                                    // Process salon API response
                                    ApiResponse apiResponse = ApiResponse.fromJson(response.data);
                                    ApiResponse salonDetails = ApiResponse(
                                      status: apiResponse.status,
                                      message: apiResponse.message,
                                      data: ApiResponseData(
                                        data: apiResponse.data.data,
                                        artists: apiResponse.data.artists,
                                        services: apiResponse.data.services,
                                      ),
                                    );
                                    salonDetailsProvider.setSalonDetails(salonDetails);
                                    barberDetailsProvider.setSalonDetails(salonDetails);
                                  } else if (response.requestOptions.uri.pathSegments.contains('service')) {
                                    ServiceResponse serviceResponse = ServiceResponse.fromJson(response.data);
                                    ServiceResponse serviceresponse = ServiceResponse(
                                        status: serviceResponse.status,
                                        message: serviceResponse.message,
                                        data:    serviceResponse.data);
                                    salonDetailsProvider.setServiceDetails(serviceresponse);
                                    if (serviceResponse != null && serviceResponse.data != null) {
                                      // Handle service response
                                    } else {
                                      print('Failed to fetch service details: Invalid response format');
                                    }
                                  }
                                } else {
                                  print('Failed to fetch details: Invalid response format');
                                }
                              }

                              // If the API calls are successful, navigate to the next screen
                              Navigator.pushNamed(context, NamedRoutes.barberProfileRoute, arguments: artistId);
                            } catch (error) {
                              Loader.hideLoader(context);
                              // Handle the case where the API call was not successful
                              // You can show an error message or take appropriate action
                              Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                              print('Failed to fetch details: $error');
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 0.5.h,
                              left:  2.5.w,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1.5.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  spreadRadius: 0.1,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.h),
                                  child: Container(
                                    height: 7.h,
                                    width: 7.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                      artist.imageUrl ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                SizedBox(height: 3.w),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      artist.name ?? "",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: ColorsConstant.textDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: List<Widget>.generate(
                                        5,
                                            (i) => (i >
                                            int.parse(artist.rating
                                                ?.round()
                                                .toString() ??
                                                "0") -
                                                1)
                                            ? SvgPicture.asset(
                                          ImagePathConstant.starIcon,
                                          color:
                                          ColorsConstant.greyStar,
                                          height: 2.h,
                                        )
                                            : SvgPicture.asset(
                                          ImagePathConstant.starIcon,
                                          color:
                                          ColorsConstant.yellowStar,
                                          height: 2.h,
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
      },
    );
  }


  Widget salonDetailOverview() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      //ApiResponse? salonDetails = provider.salonDetails;


      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 5.w,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50.w,
                  child: Text(
                    provider.salonDetails!.data.data.name,
                    style: TextStyle(
                      color: ColorsConstant.textDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 0.8.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.greenRating,
                    borderRadius: BorderRadius.circular(0.5.h),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.14),
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
                        height: 2.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        // TODO:
                        provider.salonDetails!.data.data.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.salonDetails!.data.data.salonType ?? "",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null?SizedBox():Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 0.8.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.appColor,
                    borderRadius: BorderRadius.circular(0.5.h),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.14),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        // TODO:
                        provider.salonDetails!.data.data.discount
                            .toString() +
                            "% off",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            salonAddress(
              address: provider.salonDetails!.data.data.address ,
              geoPoint: provider.salonDetails!.data.data.location != null
                  ? GeoPoint(
                provider.salonDetails!.data.data.location!.coordinates[1], // Assuming latitude is at index 1
                provider.salonDetails!.data.data.location!.coordinates[0], // Assuming longitude is at index 0
              )
                  : GeoPoint(0.0, 0.0),

            ),

            salonTiming(),
            ContactAndInteractionWidget(
              iconOnePath: ImagePathConstant.phoneIcon,
              iconTwoPath: ImagePathConstant.shareIcon,
              iconThreePath:  ImagePathConstant.saveIcon,
              iconFourPath: ImagePathConstant.instagramIcon,
              onTapIconOne: () => launchUrl(
                Uri(
                  scheme: 'tel',
                  path: StringConstant.generalContantNumber,
                ),
              ),
              onTapIconTwo: () => launchUrl(
                Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.naai.flutterApp",
                ),
              ),
              onTapIconThree: () {
                showSignInDialog(context);
              },
              onTapIconFour: () => launchUrl(
                Uri.parse(provider.salonDetails!.data.data.links.instagram ??
                    'https://www.instagram.com/naaiindia'),
              ),
              backgroundColor: ColorsConstant.lightAppColor,
            ),
            SizedBox(height: 2.h),
            availableStaffList(),
          ],
        ),
      );
    });
  }

  Widget salonTiming() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      ApiResponse? salonDetails = provider.salonDetails;

      if (salonDetails == null) {
        // Handle the case where salonDetails is null
        return Center(child: Text('Failed to load salon details.'));
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 3.h),
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
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " | ",
                      style: TextStyle(
                        color: ColorsConstant.textLight,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '${provider.salonDetails!.data.data.timing.opening} - ${provider.salonDetails!.data.data.timing.closing}',
                      //       "${provider.formatTime(provider.selectedSalonData.createdAt )} - ${provider.formatTime(provider.selectedSalonData.timing!.closing ?? 0)}",
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.w),
            TimeDateCard(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstant.closed,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "  |  ",
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: salonDetails.data.data.closedOn,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
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
    });
  }

  Widget salonAddress({required String address, required GeoPoint geoPoint}) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Text(
              "$address,  ",
              style: TextStyle(
                color: ColorsConstant.textLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              navigateTo(
                geoPoint.latitude,
                geoPoint.longitude,
              );
            },
            child: Padding(
                padding: EdgeInsets.only(bottom: 1.w),
                child: Text('VIEW IN MAP',
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        color:ColorsConstant.appColor
                    )
                )
            ),
          ),
        ],
      ),
    );
  }

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  void showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset("assets/images/app_logo.png",
                    height: 60, width: 60),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please Sign In",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "You need to sign in first to see our conditionals",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    child: Text("OK",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.authenticationRoute,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
