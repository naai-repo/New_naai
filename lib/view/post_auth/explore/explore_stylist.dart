import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_response.dart';
import '../../../utils/loading_indicator.dart';
import '../../../view_model/post_auth/salon_details/salon_details_provider.dart';

class ExploreStylist extends StatefulWidget {
  const ExploreStylist({Key? key}) : super(key: key);

  @override
  State<ExploreStylist> createState() => _ExploreStylistState();
}

class _ExploreStylistState extends State<ExploreStylist>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initExploreScreen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.stylists,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: ColorsConstant.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RedButtonWithText(
                                  buttonText: StringConstant.filter,
                                  textColor: ColorsConstant.appColor,
                                  fontSize: 10.sp,
                                  border: Border.all(
                                      color: ColorsConstant.appColor),
                                  icon:
                                      provider.selectedFilterTypeList.isNotEmpty
                                          ? Text(
                                              '${provider.selectedFilterTypeList.length}',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConstant.appColor,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              ImagePathConstant.filterIcon),
                                  fillColor: ColorsConstant.lightAppColor,
                                  borderRadius: 3.h,
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(2.h),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        width: double.maxFinite,
                                        height: 500,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(2.h),
                                                topRight:
                                                    Radius.circular(2.h))),
                                        child: const FilterBarberSheet(),
                                      );
                                    },
                                  ),
                                  shouldShowBoxShadow: false,
                                  isIconSuffix: true,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.5.w,
                                    horizontal: 2.5.w,
                                  ),
                                ),
                              
                              ],
                            ),
                            SizedBox(height: 2.h),
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: provider.artistList2.length,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 7.5 / 10.0,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                ArtistData artist = provider.artistList2[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 2.5.h),
                                  padding: EdgeInsets.only(
                                    left: index.isEven ? 0 : 2.5.w,
                                    right: index.isEven ? 2.5.w : 0,
                                  ),
                                  child: CurvedBorderedCard(
                                    borderColor: const Color(0xFFDBDBDB),
                                    fillColor: Colors.white,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      constraints:
                                          BoxConstraints(maxWidth: 30.w),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          SalonDetailsProvider
                                              salonDetailsProvider = context
                                                  .read<SalonDetailsProvider>();
                                          String artistId = artist.id;
                                          String salonId = artist.salonId;
                                          List<Service> services =
                                              artist.services;

                                          BarberProvider barberDetailsProvider =
                                              context.read<BarberProvider>();

                                          try {
                                            Loader.showLoader(context);

                                            // Prepare a list of Futures for all API calls
                                            List<Future<Response<dynamic>>>
                                                apiCalls = [
                                              Dio().get(
                                                  'http://13.235.49.214:8800/partner/artist/single/$artistId'),
                                              Dio().get(
                                                  'http://13.235.49.214:8800/partner/salon/single/$salonId'),
                                              // You may want to modify this part based on how you want to handle multiple services
                                              if (services.isNotEmpty)
                                                ...services.map((service) =>
                                                    Dio().get(
                                                        'http://13.235.49.214:8800/partner/service/single/${service.serviceId}'))
                                            ];

                                            // Use Future.wait to run multiple async operations concurrently
                                            List<Response<dynamic>> responses =
                                                await Future.wait(apiCalls);

                                            Loader.hideLoader(context);

                                            // Check the responses for each API call
                                            for (var response in responses) {
                                              if (response.data != null &&
                                                  response.data
                                                      is Map<String, dynamic>) {
                                                if (response.requestOptions.uri
                                                    .pathSegments
                                                    .contains('artist')) {
                                                  // Process artist API response
                                                  ArtistResponse apiResponse =
                                                      ArtistResponse.fromJson(
                                                          response.data);
                                                  if (apiResponse != null &&
                                                      apiResponse.data !=
                                                          null) {
                                                    barberDetailsProvider
                                                        .setArtistDetails(
                                                            apiResponse.data);
                                                  } else {
                                                    print(
                                                        'Failed to fetch artist details: Invalid response format');
                                                  }
                                                } else if (response
                                                    .requestOptions
                                                    .uri
                                                    .pathSegments
                                                    .contains('salon')) {
                                                  // Process salon API response
                                                  ApiResponse apiResponse =
                                                      ApiResponse.fromJson(
                                                          response.data);
                                                  ApiResponse salonDetails =
                                                      ApiResponse(
                                                    status: apiResponse.status,
                                                    message:
                                                        apiResponse.message,
                                                    data: ApiResponseData(
                                                      data:
                                                          apiResponse.data.data,
                                                      artists: apiResponse
                                                          .data.artists,
                                                      services: apiResponse
                                                          .data.services,
                                                    ),
                                                  );
                                                  salonDetailsProvider
                                                      .setSalonDetails(
                                                          salonDetails);
                                                  barberDetailsProvider
                                                      .setSalonDetails(
                                                          salonDetails);
                                                } else if (response
                                                    .requestOptions
                                                    .uri
                                                    .pathSegments
                                                    .contains('service')) {
                                                  ServiceResponse
                                                      serviceResponse =
                                                      ServiceResponse.fromJson(
                                                          response.data);
                                                  ServiceResponse
                                                      serviceresponse =
                                                      ServiceResponse(
                                                          status:
                                                              serviceResponse
                                                                  .status,
                                                          message:
                                                              serviceResponse
                                                                  .message,
                                                          data: serviceResponse
                                                              .data);
                                                  salonDetailsProvider
                                                      .setServiceDetails(
                                                          serviceresponse);
                                                  if (serviceResponse != null &&
                                                      serviceResponse.data !=
                                                          null) {
                                                    // Handle service response
                                                  } else {
                                                    print(
                                                        'Failed to fetch service details: Invalid response format');
                                                  }
                                                }
                                              } else {
                                                print(
                                                    'Failed to fetch details: Invalid response format');
                                              }
                                            }

                                            // If the API calls are successful, navigate to the next screen
                                            Navigator.pushNamed(context,
                                                NamedRoutes.barberProfileRoute,
                                                arguments: artistId);
                                          } catch (error) {
                                            Loader.hideLoader(context);
                                            // Handle the case where the API call was not successful
                                            // You can show an error message or take appropriate action
                                            Navigator.pushNamed(
                                                context,
                                                NamedRoutes
                                                    .bottomNavigationRoute);
                                            print(
                                                'Failed to fetch details: $error');
                                          }
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            0.5.h),
                                                        child: CircleAvatar(
                                                          radius: 7.h,
                                                          backgroundImage:
                                                              NetworkImage(artist
                                                                      .imageUrl)
                                                                  as ImageProvider,
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.name ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textDark,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.salonId ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textLight,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text.rich(
                                                          TextSpan(
                                                            children: <InlineSpan>[
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .locationIconAlt,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
                                                                  height: 2.h,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: artist
                                                                    .distance
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text.rich(
                                                          TextSpan(
                                                            children: <InlineSpan>[
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .starIcon,
                                                                  color: ColorsConstant
                                                                      .greenRating,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: artist
                                                                    .rating
                                                                    .toStringAsFixed(
                                                                        1),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .greenRating,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  if (context
                                                      .read<HomeProvider>()
                                                      .artistList2
                                                      .contains(artist.id)) {
                                                    provider
                                                        .removePreferedArtist(
                                                      context,
                                                      artist.id,
                                                    );
                                                  } else {
                                                    provider.addPreferedArtist(
                                                      context,
                                                      artist.id,
                                                    );
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  context
                                                          .read<HomeProvider>()
                                                          .artistList2
                                                          .contains(artist.id)
                                                      ? ImagePathConstant
                                                          .saveIconFill
                                                      : ImagePathConstant
                                                          .saveIcon,
                                                  color: context
                                                          .read<HomeProvider>()
                                                          .artistList2
                                                          .contains(artist.id)
                                                      ? ColorsConstant.appColor
                                                      : const Color(0xFF212121),
                                                  height: 3.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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
      );
    });
  }

  Widget titleSearchBarWithLocation() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SliverAppBar(
          elevation: 10,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.h),
              topRight: Radius.circular(3.h),
            ),
          ),
          backgroundColor: Colors.white,
          pinned: true,
          floating: true,
          title: Row(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  provider.resetStylistSearchBar();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 4.h, 2.h, 1.h),
                  child: SvgPicture.asset(
                    ImagePathConstant.leftArrowIcon,
                    color: ColorsConstant.textDark,
                    height: 2.h,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.h),
                child: Text(
                  StringConstant.exploreStylists,
                  style: StyleConstant.headingTextStyle,
                ),
              ),
            ],
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(13.h),
            child: TabBar(
              controller: homeScreenController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                    child: TextFormField(
                      controller: provider.artistSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: StyleConstant.searchTextStyle,
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider.filterArtistList(searchText),
                      decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget appScreenCommonBackground() {
    return Container(
      color: ColorsConstant.appBackgroundColor,
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        ImagePathConstant.appBackgroundImage,
        color: ColorsConstant.graphicFill,
      ),
    );
  }
}

class ExploreStylist2 extends StatefulWidget {
  const ExploreStylist2({Key? key}) : super(key: key);

  @override
  State<ExploreStylist2> createState() => _ExploreStylist2State();
}

class _ExploreStylist2State extends State<ExploreStylist2>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initExploreScreen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.stylists,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: ColorsConstant.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {},
                                //   child: RedButtonWithText(
                                //     buttonText: StringConstant.filter,
                                //     textColor: ColorsConstant.appColor,
                                //     fontSize: 10.sp,
                                //     border: Border.all(
                                //         color: ColorsConstant.appColor),
                                //     icon: SvgPicture.asset(
                                //         ImagePathConstant.filterIcon),
                                //     fillColor: ColorsConstant.lightAppColor,
                                //     borderRadius: 3.h,
                                //     onTap: () {},
                                //     shouldShowBoxShadow: false,
                                //     isIconSuffix: true,
                                //     padding: EdgeInsets.symmetric(
                                //       vertical: 1.5.w,
                                //       horizontal: 2.5.w,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: provider.artistList2.length,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 7.5 / 10.0,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                ArtistData artist = provider.artistList2[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 2.5.h),
                                  padding: EdgeInsets.only(
                                    left: index.isEven ? 0 : 2.5.w,
                                    right: index.isEven ? 2.5.w : 0,
                                  ),
                                  child: CurvedBorderedCard(
                                    borderColor: const Color(0xFFDBDBDB),
                                    fillColor: Colors.white,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      constraints:
                                          BoxConstraints(maxWidth: 30.w),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          SalonDetailsProvider
                                              salonDetailsProvider = context
                                                  .read<SalonDetailsProvider>();
                                          String artistId = artist.id;
                                          String salonId = artist.salonId;
                                          List<Service> services =
                                              artist.services;

                                          BarberProvider barberDetailsProvider =
                                              context.read<BarberProvider>();

                                          try {
                                            Loader.showLoader(context);

                                            // Prepare a list of Futures for all API calls
                                            List<Future<Response<dynamic>>>
                                                apiCalls = [
                                              Dio().get(
                                                  'http://13.235.49.214:8800/partner/artist/single/$artistId'),
                                              Dio().get(
                                                  'http://13.235.49.214:8800/partner/salon/single/$salonId'),
                                              // You may want to modify this part based on how you want to handle multiple services
                                              if (services.isNotEmpty)
                                                ...services.map((service) =>
                                                    Dio().get(
                                                        'http://13.235.49.214:8800/partner/service/single/${service.serviceId}'))
                                            ];

                                            // Use Future.wait to run multiple async operations concurrently
                                            List<Response<dynamic>> responses =
                                                await Future.wait(apiCalls);

                                            Loader.hideLoader(context);

                                            // Check the responses for each API call
                                            for (var response in responses) {
                                              if (response.data != null &&
                                                  response.data
                                                      is Map<String, dynamic>) {
                                                if (response.requestOptions.uri
                                                    .pathSegments
                                                    .contains('artist')) {
                                                  // Process artist API response
                                                  ArtistResponse apiResponse =
                                                      ArtistResponse.fromJson(
                                                          response.data);
                                                  if (apiResponse != null &&
                                                      apiResponse.data !=
                                                          null) {
                                                    barberDetailsProvider
                                                        .setArtistDetails(
                                                            apiResponse.data);
                                                  } else {
                                                    print(
                                                        'Failed to fetch artist details: Invalid response format');
                                                  }
                                                } else if (response
                                                    .requestOptions
                                                    .uri
                                                    .pathSegments
                                                    .contains('salon')) {
                                                  // Process salon API response
                                                  ApiResponse apiResponse =
                                                      ApiResponse.fromJson(
                                                          response.data);
                                                  ApiResponse salonDetails =
                                                      ApiResponse(
                                                    status: apiResponse.status,
                                                    message:
                                                        apiResponse.message,
                                                    data: ApiResponseData(
                                                      data:
                                                          apiResponse.data.data,
                                                      artists: apiResponse
                                                          .data.artists,
                                                      services: apiResponse
                                                          .data.services,
                                                    ),
                                                  );
                                                  salonDetailsProvider
                                                      .setSalonDetails(
                                                          salonDetails);
                                                  barberDetailsProvider
                                                      .setSalonDetails(
                                                          salonDetails);
                                                } else if (response
                                                    .requestOptions
                                                    .uri
                                                    .pathSegments
                                                    .contains('service')) {
                                                  ServiceResponse
                                                      serviceResponse =
                                                      ServiceResponse.fromJson(
                                                          response.data);
                                                  ServiceResponse
                                                      serviceresponse =
                                                      ServiceResponse(
                                                          status:
                                                              serviceResponse
                                                                  .status,
                                                          message:
                                                              serviceResponse
                                                                  .message,
                                                          data: serviceResponse
                                                              .data);
                                                  salonDetailsProvider
                                                      .setServiceDetails(
                                                          serviceresponse);
                                                  if (serviceResponse != null &&
                                                      serviceResponse.data !=
                                                          null) {
                                                    // Handle service response
                                                  } else {
                                                    print(
                                                        'Failed to fetch service details: Invalid response format');
                                                  }
                                                }
                                              } else {
                                                print(
                                                    'Failed to fetch details: Invalid response format');
                                              }
                                            }

                                            // If the API calls are successful, navigate to the next screen
                                            Navigator.pushNamed(context,
                                                NamedRoutes.barberProfileRoute2,
                                                arguments: artistId);
                                          } catch (error) {
                                            Loader.hideLoader(context);
                                            // Handle the case where the API call was not successful
                                            // You can show an error message or take appropriate action
                                            Navigator.pushNamed(
                                                context,
                                                NamedRoutes
                                                    .bottomNavigationRoute2);
                                            print(
                                                'Failed to fetch details: $error');
                                          }
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            0.5.h),
                                                        child: CircleAvatar(
                                                          radius: 7.h,
                                                          backgroundImage:
                                                              NetworkImage(artist
                                                                      .imageUrl)
                                                                  as ImageProvider,
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.name ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textDark,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.salonId ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textLight,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text.rich(
                                                          TextSpan(
                                                            children: <InlineSpan>[
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .locationIconAlt,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
                                                                  height: 2.h,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: artist
                                                                    .distance
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text.rich(
                                                          TextSpan(
                                                            children: <InlineSpan>[
                                                              WidgetSpan(
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .starIcon,
                                                                  color: ColorsConstant
                                                                      .greenRating,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: artist
                                                                    .rating
                                                                    .toStringAsFixed(
                                                                        1),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .greenRating,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  showSignInDialog(context);
                                                },
                                                child: SvgPicture.asset(
                                                  context
                                                          .read<HomeProvider>()
                                                          .artistList2
                                                          .contains(artist.id)
                                                      ? ImagePathConstant
                                                          .saveIconFill
                                                      : ImagePathConstant
                                                          .saveIcon,
                                                  color: context
                                                          .read<HomeProvider>()
                                                          .artistList2
                                                          .contains(artist.id)
                                                      ? ColorsConstant.appColor
                                                      : const Color(0xFF212121),
                                                  height: 3.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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
      );
    });
  }

  Widget titleSearchBarWithLocation() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SliverAppBar(
          elevation: 10,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.h),
              topRight: Radius.circular(3.h),
            ),
          ),
          backgroundColor: Colors.white,
          pinned: true,
          floating: true,
          title: Row(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  provider.resetStylistSearchBar();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 4.h, 2.h, 1.h),
                  child: SvgPicture.asset(
                    ImagePathConstant.leftArrowIcon,
                    color: ColorsConstant.textDark,
                    height: 2.h,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.h),
                child: Text(
                  StringConstant.exploreStylists,
                  style: StyleConstant.headingTextStyle,
                ),
              ),
            ],
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(13.h),
            child: TabBar(
              controller: homeScreenController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                    child: TextFormField(
                      controller: provider.artistSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: StyleConstant.searchTextStyle,
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider.filterArtistList(searchText),
                      decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget appScreenCommonBackground() {
    return Container(
      color: ColorsConstant.appBackgroundColor,
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        ImagePathConstant.appBackgroundImage,
        color: ColorsConstant.graphicFill,
      ),
    );
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
                          context, NamedRoutes.authenticationRoute);
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

class FilterBarberSheet extends StatelessWidget {
  const FilterBarberSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<FilterBarbers>(context, listen: true);
    List<Widget> screens = [
      priceWidget(),
      priceWidget(),
      priceWidget(),
      discountWidget(),
      distanceWidget()
    ];


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Filters",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.black, fontSize: 11.sp),
                  ))
            ],
          ),
        ),
        Divider(
          height: 0.5.h,
          color: ColorsConstant.divider,
        ),
        SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 35.w,
                height: 50.h,
                // color: ColorsConstant.appColorAccent,
                child: Material(
                  color: ColorsConstant.appColorAccent,
                  child: ListView.builder(
                      itemCount: ref.getFilterTypes.length,
                      itemBuilder: (context, idx) {
                        Color itemBgColor = (ref.getSelectdIndex == idx)
                            ? Colors.white
                            : Colors.transparent;
                        Color itemTColor = (ref.getSelectdIndex == idx)
                            ? Colors.black
                            : ColorsConstant.appColor;
                        FontWeight weight = (ref.getSelectdIndex == idx)
                            ? FontWeight.w600
                            : FontWeight.normal;
                        return Container(
                          color: itemBgColor,
                          child: Column(
                            children: [
                              ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                onTap: () {
                                  if (ref.getSelectdIndex != idx) {
                                    ref.changeIndex(idx);
                                  }
                                },
                                title: Text(
                                  ref.getFilterTypes[idx],
                                  style: TextStyle(
                                      color: itemTColor,
                                      fontSize: 10.sp,
                                      fontWeight: weight),
                                ),
                              ),
                              Divider(
                                thickness: 0.05.h,
                                height: 0.1,
                                color: ColorsConstant.divider,
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
              Expanded(
                  child: (ref.getSelectdIndex < screens.length)
                      ? screens[ref.getSelectdIndex]
                      : const SizedBox())
            ],
          ),
        )
      ],
    );
  }

  Widget distanceWidget() {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Distance"),
          SizedBox(
            height: 1.h,
          ),
          const RangeSliderWidget()
        ],
      ),
    );
  }

  Widget discountWidget() {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Discounts"),
          SizedBox(
            height: 1.h,
          ),
          const DiscountsButtons()
        ],
      ),
    );
  }

  Widget priceWidget() {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Gender"),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              RedButtonWithText(buttonText: "Male", onTap: () {}),
              SizedBox(width: 5.w),
              RedButtonWithText(buttonText: "Female", onTap: () {}),
            ],
          )
        ],
      ),
    );
  }
}

class DiscountsButtons extends StatefulWidget {
  const DiscountsButtons({super.key});

  @override
  State<DiscountsButtons> createState() => _DiscountsButtonsState();
}

class _DiscountsButtonsState extends State<DiscountsButtons> {
  int selectedDiscountIndex = 0;
  List<String> discounts = ["10", "20", "30", "40", "50"];

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    Color selectButtonColor = ColorsConstant.appColor,unselectButtonColor = ColorsConstant.appColorAccent,
    borderButtonColor = ColorsConstant.appColor;
    print('Select Idx : $selectedDiscountIndex');
    final ref = Provider.of<ExploreProvider>(context, listen: true);
    
    for (int i = 0; i < discounts.length; i++) {
      buttons.add(FilterButton(
          onTap: () async {
            
          },
          bgColor: (i == selectedDiscountIndex) ? selectButtonColor : unselectButtonColor,
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(color: borderButtonColor,width: 0.1.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.w),
          child: Text(
            "${discounts[i].toString()}% Off or more",
             style: TextStyle(
              fontSize: 8.sp,
              color: (i == selectedDiscountIndex) ? unselectButtonColor : selectButtonColor
            ),
          )));
    }
    return Wrap(
      spacing: double.maxFinite,
      runSpacing: 2.w,
      children: buttons,
    );
  }
}

class RangeSliderWidget extends StatefulWidget {
  const RangeSliderWidget({super.key});

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  double range = 0, end = 0;
  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: RangeValues(range, end),
      onChanged: (v) {},
      onChangeEnd: (v) {
        print(v);
        setState(() {
          end = v.end;
          range = v.start;
        });
      },
      max: 100,
      min: 0,
      labels: RangeLabels("0", "1"),
    );
  }
}


