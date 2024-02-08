
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/components/text_with_prefix_icon.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/booked_salon_and_artist_name.dart';
import 'package:naai/view/widgets/colorful_information_card.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view/widgets/stacked_image_text.dart';
import 'package:naai/view/widgets/title_with_line.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/allbooking.dart';
import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/salon_detail.dart';
import '../../../models/salon_model.dart';
import '../../../models/service_response.dart';
import '../../../utils/loading_indicator.dart';
import '../../../view_model/post_auth/salon_details/salon_details_provider.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeProvider>().initHome(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int keywordState = context.watch<AppState>().keywordState;
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ReusableWidgets.transparentFlexibleSpace(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.h),
                            topRight: Radius.circular(3.h),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                children: <Widget>[
                                  logoAndNotifications(provider),
                                  //  if (provider.isSearchExpanded) // Check the state of AnimatedSearch
                                  if (keywordState == 0)
                                    Padding(
                                      padding:EdgeInsets.only(top:1.h),
                                      child: Container(
                                          height:100.h,
                                          color:Colors.white
                                      ),
                                    ),
                                  searchLocationBar(),
                               //   if (provider.isSearchExpanded)
                                  dummyDeal(provider),
                               //   if (provider.isSearchExpanded)
                                  SizedBox(height:1.h),
                               //   if (provider.isSearchExpanded)
                                  dummyDeal2(provider),
                                ],
                              ),
                            ),
                          //  if (provider.isSearchExpanded)
                            serviceCategories(),
                       if (provider.upcomingBooking.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Visibility(
                                  visible: provider.upcomingBooking.isNotEmpty,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: provider.upcomingBooking.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                          visible:provider.upcomingBooking[index].paymentStatus == 'pending',
                                          child: upcomingBookingCard(provider.upcomingBooking[index],index),
                                        );
                                      },
                                      separatorBuilder: (context, index) => SizedBox(height: 2.h),
                                    ),
                                  ),
                                  replacement: previousBookingCard(),
                                ),
                              ),
                            salonNearMe(),
                            SizedBox(height: 5.h),
                            ourStylist(),
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

  Widget previousBookingCard() {

    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        borderRadius: 2.h,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 3.h,
              ),
              SizedBox(height: 3.h),
              Row(
                children: <Widget>[
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText:  provider.previousBooking.first.salonName ?? '' ,
                  ),
                  Visibility(
                    visible: provider.artistList2.isNotEmpty,
                    child: BookedSalonAndArtistName(
                      headerText: StringConstant.artist,
                      headerIconPath: ImagePathConstant.artistIcon,
                      nameText:  provider.previousBooking.first.artistServiceMap.first.artistName ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 5.h),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Text(
                    provider.previousBooking.first.artistServiceMap.first.serviceName?[index] ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Text(''),
                  itemCount: provider.previousBooking.first.artistServiceMap.first.serviceName?.length??
                      0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: () async {
                      String salonId = provider.previousBooking.first.salonId;
                      SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();

                      try {
                        Loader.showLoader(context);
                        final response = await Dio().get(
                          'http://13.235.49.214:8800/partner/salon/single/$salonId',
                        );
                        Loader.hideLoader(context);

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

                        // Pass the salonDetails to SalonDetailsProvider
                        salonDetailsProvider.setSalonDetails(salonDetails);

                        // If the API call is successful, navigate to the SalonDetailsScreen
                        Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute, arguments: salonId);
                      } catch (error) {
                        Loader.hideLoader(context);
                        // Handle the case where the API call was not successful
                        // You can show an error message or take appropriate action
                        Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                        print('Failed to fetch salon details: $error');
                      }
                    },
                     padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 5.w),
                  RedButtonWithText(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.appointmentDetailsRoute,
                      arguments: 0,
                    ),
                    buttonText: StringConstant.seeDetails,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget upcomingBookingCard(CurrentBooking booking,index) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          NamedRoutes.appointmentDetailsRoute2,
          arguments: provider.upcomingBooking[index],
        ),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleWithLine(
                    lineHeight: 2.5.h,
                    lineWidth: 0.6.w,
                    fontSize: 12.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAppointment.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.2.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 2.5.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.upcomingBooking[index].salonName ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: <Widget>[
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.formatBookingDate(provider.upcomingBooking[index].bookingDate),
                              style: StyleConstant.bookingDateTimeTextStyle,
                              ),
                            ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.upcomingBooking[index].timeSlot.start,
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          SizedBox(width: 6.w),
                          InkWell(
                            onTap: () {
                              /*
                              navigateTo(
                                geoPoint.latitude,
                                geoPoint.longitude,
                              );
                              */
                            },
                            child: SvgPicture.asset(
                              ImagePathConstant.blackLocationIcon,
                              height: 4.h,
                              color: ColorsConstant.appColor,
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
        ),
      );
    });
  }
  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  Widget logoAndNotifications(HomeProvider provider) {
     TextEditingController _search = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SvgPicture.asset(
          ImagePathConstant.inAppLogo,
          height: 5.h,
        ),
        Row(
          children: <Widget>[
            AnimatedSearch(
              width: 0.16.w,
           //   textEditingController: _search,
              startIcon: Icons.search,
              closeIcon: Icons.close,
              iconColor: Colors.black,
              cursorColor: ColorsConstant.appColor,
              decoration:  InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black,),
                border: InputBorder.none,
               counterText: _search.text,
              ),
              onChanged: (String search, bool isExpanded) {
                // Placeholder callback, you can add your logic here
                print("Search Text: $search, Expanded: $isExpanded");
                _search.text = search;
                if (mounted) setState(() {});
              },
            ),
             SizedBox(width: 2.w),
             Container(
               padding: EdgeInsets.all(1.5.h),
               decoration: BoxDecoration(
                 color: ColorsConstant.graphicFillDark,
                 borderRadius: BorderRadius.circular(4.h),
               ),
               child: SvgPicture.asset(ImagePathConstant.appointmentIcon),
             ),
          ],
        )
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          bool _shouldScroll = (TextPainter(
            text: TextSpan(
                text: Provider.of<HomeProvider>(context, listen: true)
              .userAddress,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                )),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          )..layout())
              .size
              .width >
              constraints.maxWidth * 7 / 10;

          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
              ),
              Container(
                margin: EdgeInsets.only(left: 2.w),
                height: 4.h,
                alignment: Alignment.centerLeft,
                child: _shouldScroll
                    ? Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget ourStylist() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      List<ArtistData> displayedArtists = provider.getDisplayedArtists();
      bool showLoadButton = provider.shouldShowArtistLoadButton();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 3.5.h,
              lineWidth: 1.w,
              fontSize: 15.sp,
              text: StringConstant.ourStylist.toUpperCase(),
            ),
            SizedBox(height: 2.h),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        index = 2 * index;
                        ArtistData artist = provider.artistList2[index];
                   //     String SalonName = provider.SalonNames[index];
                        return artistCard(
                          isThin: (index / 2).floor().isEven,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0.0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                                    barberDetailsProvider.serviceDetailsMap[serviceResponse.data.id] = serviceResponse; // Store service details in the map
                                    print('service name is :- ${serviceResponse.data.serviceTitle}');
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
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).floor(),
                      itemBuilder: (context, index) {
                        index = 2 * index + 1;
                        ArtistData artist = provider.artistList2[index];


                        return artistCard(
                          isThin: ((index - 1) / 2).floor().isOdd,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                         imagePath: artist.imageUrl ??'',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                                    barberDetailsProvider.serviceDetailsMap[serviceResponse.data.id] = serviceResponse; // Store service details in the map
                                    print('service name is :- ${serviceResponse.data.serviceTitle}');
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (showLoadButton)
              GestureDetector(
                onTap: () {
                  provider.loadMoreArtists();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: ColorsConstant.appColor, // Customize the color as needed
                  child: Center(
                    child: Text(
                      'Load More Stylists',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height:5.h),
          ],
        ),
      );
    });
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required String artistId,
    required Color color,
    required String imagePath,
    required Function() onTap,
  }) {
    print('imagePathggggggg: $imagePath'); // Add this line for debugging
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isThin
            ? EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.h,
              )
            : EdgeInsets.symmetric(
                horizontal: 1.w,
                vertical: 1.h,
              ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
          borderRadius: BorderRadius.circular(3.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: isThin ? 14.h : 22.h,
              child: ClipRRect(
                borderRadius: isThin
                    ? BorderRadius.circular(3.h)
                    : BorderRadius.vertical(
                        top: Radius.circular(3.h),
                      ),
                child: imagePath != null && imagePath.isNotEmpty
                    ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/salon_dummy_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    salonName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List<Widget>.generate(
                      rating.ceil(),
                      (i) => SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: ColorsConstant.greyStar,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isThin ? 3.h : 5.h),
          ],
        ),
      ),
    );
  }

  Widget salonNearMe() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {

      List<SalonData2> displayedSalons = provider.getDisplayedSalons();
      bool showLoadButton = provider.shouldShowLoadButton();
      return Padding(
        padding: EdgeInsets.only(
          top: 3.h,
          right: 3.w,
          left: 3.w,
        ),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 2.5.h,
              lineWidth: 0.6.w,
              fontSize: 12.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 17.h,
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: displayedSalons.length + (showLoadButton ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedSalons.length) {
                    return GestureDetector(
                      onTap: () {
                        provider.loadMoreSalons();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          width: 35.w,
                          // margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.h),
                            color: ColorsConstant.appColor,
                          ),
                          child: Center(
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    SalonData2 salon = displayedSalons[index];
                    return GestureDetector(
                      onTap: () async {
                        String salonId = salon.id;
                        SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();

                        try {
                          Loader.showLoader(context);
                          final response = await Dio().get(
                            'http://13.235.49.214:8800/partner/salon/single/$salonId',
                          );
                          Loader.hideLoader(context);

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

                          // Pass the salonDetails to SalonDetailsProvider
                          salonDetailsProvider.setSalonDetails(salonDetails);

                          // If the API call is successful, navigate to the SalonDetailsScreen
                          Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute, arguments: salonId);
                        } catch (error) {
                          Loader.hideLoader(context);
                          // Handle the case where the API call was not successful
                          // You can show an error message or take appropriate action
                          Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                          print('Failed to fetch salon details: $error');
                        }
                      },
                      child: Container(
                        width: 75.w,
                        margin: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: const Color(0xFF0F0F0F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                  horizontal: 3.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          salon.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          salon.salonType == 'Unisex'
                                              ? '${salon.salonType} Salon'
                                              : '${salon.salonType}\'s Salon',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ColorfulInformationCard(
                                          imagePath:
                                          ImagePathConstant.locationIconAlt,
                                          text: provider.salonList2[index]
                                              .distance.toStringAsFixed(2),
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                        SizedBox(width: 3.w),
                                        ColorfulInformationCard(
                                          imagePath: ImagePathConstant.starIcon,
                                          text:
                                          '${(salon.rating ?? 0)
                                              .toStringAsFixed(1)}',
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 28.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(1.h),
                                    ),
                                    child: salon.images != null && salon.images.isNotEmpty
                                        ? Image.network(
                                      salon.images[0].url,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/images/salon_dummy_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                salon.discount == 0 || salon.discount == null
                                    ? const SizedBox()
                                    : Container(
                                  constraints: BoxConstraints(minWidth: 13.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0.3.h,
                                    horizontal: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorsConstant.appColor,
                                    borderRadius: BorderRadius.circular(0.5.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.14),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${salon.discount} %off',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    },
    );
  }

  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithLine(
            lineHeight: 2.5.h,
            lineWidth: 0.6.w,
            fontSize: 12.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 15.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: Services.HAIR,
                      ),
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: Services.MAKEUP,
                      ),
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: Services.SPA,
                      ),
                  imagePath: ImagePathConstant.massageImage,
                  text: StringConstant.massage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dummyDeal(HomeProvider provider) {
    return GestureDetector(
      onTap: () async{
       await  provider.DiscountFilterforWomen(context);
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => ExploreScreen3(),
         ),
       );

      },
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          color: const Color(0xFF3F64E6),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 95.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dummy_deal_background.png',
                      height: 10.h,
                    ),
                    Image.asset(
                      'assets/images/dummy_deal_woman.png',
                      height: 17.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 2.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'WOMAN HAIRCUT',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dummyDeal2(HomeProvider provider) {
    return Row(
      children:[
       GestureDetector(
         onTap: ()async {
      await provider.DiscountFilterforMen(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreScreen3(),
        ),
      );
    },
         child: Container(
          height: 20.h,
          width:45.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.5.h),
            color: const Color(0xFF13ABA1),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left:2.w,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dummy_deal_men.png',
                      fit: BoxFit.fill,
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 2.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Flat',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '10%',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height:3.h),
                    Text(
                      'MEN HAIRCUT',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
       ),
       const Spacer(),
        GestureDetector(
          onTap: () async{
            await provider.DiscountFilterforMen(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen3(),
              ),
            );
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.cover,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
    );
  }
}

//Continue as a guest
class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeProvider>().initHome2(context);
    });

  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override Widget build(BuildContext context) {
    int keywordState = context.watch<AppState>().keywordState;
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ReusableWidgets.transparentFlexibleSpace(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.h),
                            topRight: Radius.circular(3.h),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                children: <Widget>[
                                  logoAndNotifications(provider),
                                  //  if (provider.isSearchExpanded) // Check the state of AnimatedSearch
                                  if (keywordState == 0)
                                    Padding(
                                      padding:EdgeInsets.only(top:1.h),
                                      child: Container(
                                          height:100.h,
                                          color:Colors.white
                                      ),
                                    ),
                                  searchLocationBar(),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal(provider),
                                  //   if (provider.isSearchExpanded)
                                  SizedBox(height:1.h),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal2(provider),
                                ],
                              ),
                            ),
                            //  if (provider.isSearchExpanded)
                            serviceCategories(),
                            if (provider.lastOrNextBooking.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Visibility(
                                  visible: provider
                                      .lastOrNextBooking.last.isUpcoming,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount:
                                      provider.lastOrNextBooking.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                          visible: provider
                                              .lastOrNextBooking[index].transactionStatus !=
                                              null,
                                          child: upcomingBookingCard(index),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 2.h),
                                    ),
                                  ),
                                  replacement: previousBookingCard(),
                                ),
                              ),
                            salonNearMe(),
                            SizedBox(height: 5.h),
                            ourStylist(),
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

  Widget previousBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        borderRadius: 2.h,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 3.h,
              ),
              SizedBox(height: 3.h),
              Row(
                children: <Widget>[
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText: provider.lastOrNextBooking.last.salonName ?? '',
                  ),
                  Visibility(
                    visible: provider.artistList.isNotEmpty,
                    child: BookedSalonAndArtistName(
                      headerText: StringConstant.artist,
                      headerIconPath: ImagePathConstant.artistIcon,
                      nameText:
                      provider.lastOrNextBooking.last.artistName ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 5.h),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Text(
                    provider.lastOrNextBooking.last
                        .bookedServiceNames?[index] ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Text(', '),
                  itemCount: provider
                      .lastOrNextBooking.last.bookedServiceNames?.length ??
                      0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: (){},
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 5.w),
                  RedButtonWithText(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.appointmentDetailsRoute,
                      arguments: 0,
                    ),
                    buttonText: StringConstant.seeDetails,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget upcomingBookingCard(int index) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          NamedRoutes.appointmentDetailsRoute,
          arguments: index,
        ),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleWithLine(
                    lineHeight: 2.5.h,
                    lineWidth: 0.6.w,
                    fontSize: 12.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAppointment.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.2.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 2.5.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.lastOrNextBooking[index].salonName ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: <Widget>[
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getFormattedDate: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getAbbreviatedDay: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getTimeScheduled: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
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
        ),
      );
    });
  }

  Widget logoAndNotifications(HomeProvider provider) {
    TextEditingController _search = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SvgPicture.asset(
          ImagePathConstant.inAppLogo,
          height: 5.h,
        ),
        Row(
          children: <Widget>[
            AnimatedSearch(
              width: 0.16.w,
              textEditingController: _search,
              startIcon: Icons.search,
              closeIcon: Icons.close,
              iconColor: Colors.black,
              cursorColor: ColorsConstant.appColor,
              decoration: const InputDecoration(
               hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black,),
                border: InputBorder.none,
              ),
              onChanged: (String search, bool isExpanded) {
                // Placeholder callback, you can add your logic here
                print("Search Text: $search, Expanded: $isExpanded");
              },
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.all(1.5.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: SvgPicture.asset(ImagePathConstant.appointmentIcon),
            ),
          ],
        )
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute2,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          bool _shouldScroll = (TextPainter(
            text: TextSpan(
                text: Provider.of<HomeProvider>(context, listen: true)
                    .userAddress,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                )),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          )..layout())
              .size
              .width >
              constraints.maxWidth * 7 / 10;

          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
              ),
              Container(
                margin: EdgeInsets.only(left: 2.w),
                height: 4.h,
                alignment: Alignment.centerLeft,
                child: _shouldScroll
                    ? Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget ourStylist() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      List<ArtistData> displayedArtists = provider.getDisplayedArtists();
      bool showLoadButton = provider.shouldShowArtistLoadButton();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 3.5.h,
              lineWidth: 1.w,
              fontSize: 15.sp,
              text: StringConstant.ourStylist.toUpperCase(),
            ),
            SizedBox(height: 2.h),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        index = 2 * index;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: (index / 2).floor().isEven,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                                    barberDetailsProvider.serviceDetailsMap[serviceResponse.data.id] = serviceResponse; // Store service details in the map
                                    print('service name is :- ${serviceResponse.data.serviceTitle}');
                                  }
                                } else {
                                  print('Failed to fetch details: Invalid response format');
                                }
                              }

                              // If the API calls are successful, navigate to the next screen
                              Navigator.pushNamed(context, NamedRoutes.barberProfileRoute2, arguments: artistId);
                            } catch (error) {
                              Loader.hideLoader(context);
                              // Handle the case where the API call was not successful
                              // You can show an error message or take appropriate action
                              Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                              print('Failed to fetch details: $error');
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).floor(),
                      itemBuilder: (context, index) {
                        index = 2 * index + 1;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: ((index - 1) / 2).floor().isOdd,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ??'',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                                    barberDetailsProvider.serviceDetailsMap[serviceResponse.data.id] = serviceResponse; // Store service details in the map
                                    print('service name is :- ${serviceResponse.data.serviceTitle}');
                                  }
                                } else {
                                  print('Failed to fetch details: Invalid response format');
                                }
                              }

                              // If the API calls are successful, navigate to the next screen
                              Navigator.pushNamed(context, NamedRoutes.barberProfileRoute2, arguments: artistId);
                            } catch (error) {
                              Loader.hideLoader(context);
                              // Handle the case where the API call was not successful
                              // You can show an error message or take appropriate action
                              Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                              print('Failed to fetch details: $error');
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (showLoadButton)
              GestureDetector(
                onTap: () {
                  provider.loadMoreArtists();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: ColorsConstant.appColor, // Customize the color as needed
                  child: Center(
                    child: Text(
                      'Load More Stylists',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height:5.h),
          ],
        ),
      );
    });
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required String artistId,
    required Color color,
    required String imagePath,
    required Function() onTap,
  }) {
    print('imagePathggggggg: $imagePath'); // Add this line for debugging
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isThin
            ? EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        )
            : EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
          borderRadius: BorderRadius.circular(3.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: isThin ? 14.h : 22.h,
              child: ClipRRect(
                borderRadius: isThin
                    ? BorderRadius.circular(3.h)
                    : BorderRadius.vertical(
                  top: Radius.circular(3.h),
                ),
                child: imagePath != null && imagePath.isNotEmpty
                    ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/salon_dummy_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    salonName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List<Widget>.generate(
                      rating.ceil(),
                          (i) => SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: ColorsConstant.greyStar,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isThin ? 3.h : 5.h),
          ],
        ),
      ),
    );
  }

  Widget salonNearMe() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {

      List<SalonData2> displayedSalons = provider.getDisplayedSalons();
      bool showLoadButton = provider.shouldShowLoadButton();
      return Padding(
        padding: EdgeInsets.only(
          top: 3.h,
          right: 3.w,
          left: 3.w,
        ),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 2.5.h,
              lineWidth: 0.6.w,
              fontSize: 12.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 17.h,
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: displayedSalons.length + (showLoadButton ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedSalons.length) {
                    return GestureDetector(
                      onTap: () {
                        provider.loadMoreSalons();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          width: 35.w,
                          // margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.h),
                            color: ColorsConstant.appColor,
                          ),
                          child: Center(
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    SalonData2 salon = displayedSalons[index];
                    return GestureDetector(
                      onTap: () async {
                        String salonId = salon.id;
                        SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();

                        try {
                          Loader.showLoader(context);
                          final response = await Dio().get(
                            'http://13.235.49.214:8800/partner/salon/single/$salonId',
                          );
                          Loader.hideLoader(context);

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

                          // Pass the salonDetails to SalonDetailsProvider
                          salonDetailsProvider.setSalonDetails(salonDetails);

                          // If the API call is successful, navigate to the SalonDetailsScreen
                          Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute2, arguments: salonId);
                        } catch (error) {
                          Loader.hideLoader(context);
                          // Handle the case where the API call was not successful
                          // You can show an error message or take appropriate action
                          Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                          print('Failed to fetch salon details: $error');
                        }
                      },
                      child: Container(
                        width: 75.w,
                        margin: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: const Color(0xFF0F0F0F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                  horizontal: 3.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          salon.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          salon.salonType == 'Unisex'
                                              ? '${salon.salonType} Salon'
                                              : '${salon.salonType}\'s Salon',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ColorfulInformationCard(
                                          imagePath:
                                          ImagePathConstant.locationIconAlt,
                                          text: provider.salonList2[index]
                                              .distance.toStringAsFixed(2),
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                        SizedBox(width: 3.w),
                                        ColorfulInformationCard(
                                          imagePath: ImagePathConstant.starIcon,
                                          text:
                                          '${(salon.rating ?? 0)
                                              .toStringAsFixed(1)}',
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 28.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(1.h),
                                    ),
                                    child: salon.images.isNotEmpty
                                        ? Image.network(
                                      salon.images[0].url,
                                      fit: BoxFit.cover,
                                    )
                                        : Placeholder(),
                                  ),
                                ),
                                salon.discount == 0 || salon.discount == null
                                    ? const SizedBox()
                                    : Container(
                                  constraints: BoxConstraints(minWidth: 13.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0.3.h,
                                    horizontal: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorsConstant.appColor,
                                    borderRadius: BorderRadius.circular(0.5.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.14),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${salon.discount} %off',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    },
    );
  }

  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithLine(
            lineHeight: 2.5.h,
            lineWidth: 0.6.w,
            fontSize: 12.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 15.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.HAIR,
                  ),
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.MAKEUP,
                  ),
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.SPA,
                  ),
                  imagePath: ImagePathConstant.massageImage,
                  text: StringConstant.massage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dummyDeal(HomeProvider provider) {

    return GestureDetector(
      onTap: () async{
       await provider.DiscountFilterforWomen(context);

        Navigator.pushNamed(context, NamedRoutes.exploreRoute2);
      },
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          color: const Color(0xFF3F64E6),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 95.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dummy_deal_background.png',
                      height: 10.h,
                    ),
                    Image.asset(
                      'assets/images/dummy_deal_woman.png',
                      height: 17.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 2.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'WOMAN HAIRCUT',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dummyDeal2(HomeProvider provider) {
      return Row(
      children:[
        GestureDetector(
          onTap: () async{
          await  provider.DiscountFilterforMen(context);
          Navigator.pushNamed(context, NamedRoutes.exploreRoute2);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.fill,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async{
           await provider.DiscountFilterforMen(context);
           Navigator.pushNamed(context, NamedRoutes.exploreRoute2);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.cover,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//For deny location
class HomeScreen3 extends StatefulWidget {
  const HomeScreen3({Key? key}) : super(key: key);

  @override
  State<HomeScreen3> createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {
  @override


  @override Widget build(BuildContext context) {
    int keywordState = context.watch<AppState>().keywordState;
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ReusableWidgets.transparentFlexibleSpace(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.h),
                            topRight: Radius.circular(3.h),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                children: <Widget>[
                                  logoAndNotifications(provider),
                                  //  if (provider.isSearchExpanded) // Check the state of AnimatedSearch
                                  if (keywordState == 0)
                                    Padding(
                                      padding:EdgeInsets.only(top:1.h),
                                      child: Container(
                                          height:100.h,
                                          color:Colors.white
                                      ),
                                    ),
                                  searchLocationBar(),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal(provider),
                                  //   if (provider.isSearchExpanded)
                                  SizedBox(height:1.h),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal2(provider),
                                ],
                              ),
                            ),
                            //  if (provider.isSearchExpanded)
                            serviceCategories(),
                            if (provider.lastOrNextBooking.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Visibility(
                                  visible: provider
                                      .lastOrNextBooking.last.isUpcoming,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount:
                                      provider.lastOrNextBooking.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                          visible: provider
                                              .lastOrNextBooking[index].transactionStatus !=
                                              null,
                                          child: upcomingBookingCard(index),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 2.h),
                                    ),
                                  ),
                                  replacement: previousBookingCard(),
                                ),
                              ),
                            salonNearMe(),
                            SizedBox(height: 5.h),
                            ourStylist(),
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

  Widget previousBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        borderRadius: 2.h,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 3.h,
              ),
              SizedBox(height: 3.h),
              Row(
                children: <Widget>[
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText: provider.lastOrNextBooking.last.salonName ?? '',
                  ),
                  Visibility(
                    visible: provider.artistList.isNotEmpty,
                    child: BookedSalonAndArtistName(
                      headerText: StringConstant.artist,
                      headerIconPath: ImagePathConstant.artistIcon,
                      nameText:
                      provider.lastOrNextBooking.last.artistName ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 5.h),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Text(
                    provider.lastOrNextBooking.last
                        .bookedServiceNames?[index] ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Text(', '),
                  itemCount: provider
                      .lastOrNextBooking.last.bookedServiceNames?.length ??
                      0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: () {},
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 5.w),
                  RedButtonWithText(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.appointmentDetailsRoute,
                      arguments: 0,
                    ),
                    buttonText: StringConstant.seeDetails,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget upcomingBookingCard(int index) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          NamedRoutes.appointmentDetailsRoute,
          arguments: index,
        ),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleWithLine(
                    lineHeight: 2.5.h,
                    lineWidth: 0.6.w,
                    fontSize: 12.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAppointment.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.2.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 2.5.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.lastOrNextBooking[index].salonName ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: <Widget>[
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getFormattedDate: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getAbbreviatedDay: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getTimeScheduled: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
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
        ),
      );
    });
  }

  Widget logoAndNotifications(HomeProvider provider) {
    TextEditingController _search = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SvgPicture.asset(
          ImagePathConstant.inAppLogo,
          height: 5.h,
        ),
        Row(
          children: <Widget>[
            AnimatedSearch(
              width: 0.16.w,
              textEditingController: _search,
              startIcon: Icons.search,
              closeIcon: Icons.close,
              iconColor: Colors.black,
              cursorColor: ColorsConstant.appColor,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black,),
                border: InputBorder.none,
              ),
              onChanged: (String search, bool isExpanded) {
                // Placeholder callback, you can add your logic here
                print("Search Text: $search, Expanded: $isExpanded");
              },
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.all(1.5.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: SvgPicture.asset(ImagePathConstant.appointmentIcon),
            ),
          ],
        )
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          bool _shouldScroll = (TextPainter(
            text: TextSpan(
                text: 'Please Sign In',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                )),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          )..layout())
              .size
              .width >
              constraints.maxWidth * 7 / 10;

          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
              ),
              Container(
                margin: EdgeInsets.only(left: 2.w),
                height: 4.h,
                alignment: Alignment.centerLeft,
                child: _shouldScroll
                    ? Text(
                  "Please Sign in",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Text(
                  "Please Sign In",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget ourStylist() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      List<ArtistData> displayedArtists = provider.getDisplayedArtists();
      bool showLoadButton = provider.shouldShowArtistLoadButton();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 3.5.h,
              lineWidth: 1.w,
              fontSize: 15.sp,
              text: StringConstant.ourStylist.toUpperCase(),
            ),
            SizedBox(height: 2.h),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        index = 2 * index;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: (index / 2).floor().isEven,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).floor(),
                      itemBuilder: (context, index) {
                        index = 2 * index + 1;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: ((index - 1) / 2).floor().isOdd,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ??'',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (showLoadButton)
              GestureDetector(
                onTap: () {
                  provider.loadMoreArtists();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: ColorsConstant.appColor, // Customize the color as needed
                  child: Center(
                    child: Text(
                      'Load More Stylists',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height:5.h),
          ],
        ),
      );
    });
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required String artistId,
    required Color color,
    required String imagePath,
    required Function() onTap,
  }) {
    print('imagePathggggggg: $imagePath'); // Add this line for debugging
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isThin
            ? EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        )
            : EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
          borderRadius: BorderRadius.circular(3.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: isThin ? 14.h : 22.h,
              child: ClipRRect(
                borderRadius: isThin
                    ? BorderRadius.circular(3.h)
                    : BorderRadius.vertical(
                  top: Radius.circular(3.h),
                ),
                child: Image.network(
                  imagePath ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    salonName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List<Widget>.generate(
                      rating.ceil(),
                          (i) => SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: ColorsConstant.greyStar,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isThin ? 3.h : 5.h),
          ],
        ),
      ),
    );
  }

  Widget salonNearMe() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {

      List<SalonData2> displayedSalons = provider.getDisplayedSalons();
      bool showLoadButton = provider.shouldShowLoadButton();
      return Padding(
        padding: EdgeInsets.only(
          top: 3.h,
          right: 3.w,
          left: 3.w,
        ),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 2.5.h,
              lineWidth: 0.6.w,
              fontSize: 12.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 17.h,
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: displayedSalons.length + (showLoadButton ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedSalons.length) {
                    return GestureDetector(
                      onTap: () {
                        provider.loadMoreSalons();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          width: 35.w,
                          // margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.h),
                            color: ColorsConstant.appColor,
                          ),
                          child: Center(
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    SalonData2 salon = displayedSalons[index];
                    return GestureDetector(
                      onTap: () async {
                        String salonId = salon.id;
                        SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();

                        try {
                          Loader.showLoader(context);
                          final response = await Dio().get(
                            'http://13.235.49.214:8800/partner/salon/single/$salonId',
                          );
                          Loader.hideLoader(context);

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

                          // Pass the salonDetails to SalonDetailsProvider
                          salonDetailsProvider.setSalonDetails(salonDetails);

                          // If the API call is successful, navigate to the SalonDetailsScreen
                          Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute2, arguments: salonId);
                        } catch (error) {
                          Loader.hideLoader(context);
                          // Handle the case where the API call was not successful
                          // You can show an error message or take appropriate action
                          Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                          print('Failed to fetch salon details: $error');
                        }
                      },
                      child: Container(
                        width: 75.w,
                        margin: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: const Color(0xFF0F0F0F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                  horizontal: 3.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          salon.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          salon.salonType == 'Unisex'
                                              ? '${salon.salonType} Salon'
                                              : '${salon.salonType}\'s Salon',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ColorfulInformationCard(
                                          imagePath:
                                          ImagePathConstant.locationIconAlt,
                                          text: provider.salonList2[index]
                                              .distance.toStringAsFixed(2),
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                        SizedBox(width: 3.w),
                                        ColorfulInformationCard(
                                          imagePath: ImagePathConstant.starIcon,
                                          text:
                                          '${(salon.rating ?? 0)
                                              .toStringAsFixed(1)}',
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 28.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(1.h),
                                    ),
                                    child: salon.images.isNotEmpty
                                        ? Image.network(
                                      salon.images[0].url,
                                      fit: BoxFit.cover,
                                    )
                                        : Placeholder(),
                                  ),
                                ),
                                salon.discount == 0 || salon.discount == null
                                    ? const SizedBox()
                                    : Container(
                                  constraints: BoxConstraints(minWidth: 13.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0.3.h,
                                    horizontal: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorsConstant.appColor,
                                    borderRadius: BorderRadius.circular(0.5.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.14),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${salon.discount} %off',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    },
    );
  }

  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithLine(
            lineHeight: 2.5.h,
            lineWidth: 0.6.w,
            fontSize: 12.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 15.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.HAIR,
                  ),
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.MAKEUP,
                  ),
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.SPA,
                  ),
                  imagePath: ImagePathConstant.massageImage,
                  text: StringConstant.massage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dummyDeal(HomeProvider provider) {

    return GestureDetector(
      onTap: () {
        provider.DiscountFilterforWomen(context);

        Navigator.pushNamed(context, NamedRoutes.exploreRoute3);
      },
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          color: const Color(0xFF3F64E6),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 95.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dummy_deal_background.png',
                      height: 10.h,
                    ),
                    Image.asset(
                      'assets/images/dummy_deal_woman.png',
                      height: 17.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 2.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'WOMAN HAIRCUT',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dummyDeal2(HomeProvider provider) {
    return Row(
      children:[
        GestureDetector(
          onTap: () async{
            await  provider.DiscountFilterforMen(context);
            Navigator.pushNamed(context, NamedRoutes.exploreRoute3);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.fill,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async{
            await provider.DiscountFilterforMen(context);
            Navigator.pushNamed(context, NamedRoutes.exploreRoute2);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.cover,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class HomeScreen4 extends StatefulWidget {
  const HomeScreen4({Key? key}) : super(key: key);

  @override
  State<HomeScreen4> createState() => _HomeScreen4State();
}

class _HomeScreen4State extends State<HomeScreen4> with WidgetsBindingObserver {


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int keywordState = context.watch<AppState>().keywordState;
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ReusableWidgets.transparentFlexibleSpace(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.h),
                            topRight: Radius.circular(3.h),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                children: <Widget>[
                                  logoAndNotifications(provider),
                                  //  if (provider.isSearchExpanded) // Check the state of AnimatedSearch
                                  if (keywordState == 0)
                                    Padding(
                                      padding:EdgeInsets.only(top:1.h),
                                      child: Container(
                                          height:100.h,
                                          color:Colors.white
                                      ),
                                    ),
                                  searchLocationBar(),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal(provider),
                                  //   if (provider.isSearchExpanded)
                                  SizedBox(height:1.h),
                                  //   if (provider.isSearchExpanded)
                                  dummyDeal2(provider),
                                ],
                              ),
                            ),
                            //  if (provider.isSearchExpanded)
                            serviceCategories(),
                            if (provider.lastOrNextBooking.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Visibility(
                                  visible: provider
                                      .lastOrNextBooking.last.isUpcoming,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    removeTop: true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount:
                                      provider.lastOrNextBooking.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                          visible: provider
                                              .lastOrNextBooking[index].transactionStatus !=
                                              null,
                                          child: upcomingBookingCard(index),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 2.h),
                                    ),
                                  ),
                                  replacement: previousBookingCard(),
                                ),
                              ),
                            salonNearMe(),
                            SizedBox(height: 5.h),
                            ourStylist(),
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

  Widget previousBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        borderRadius: 2.h,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 3.h,
              ),
              SizedBox(height: 3.h),
              Row(
                children: <Widget>[
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText: provider.lastOrNextBooking.last.salonName ?? '',
                  ),
                  Visibility(
                    visible: provider.artistList.isNotEmpty,
                    child: BookedSalonAndArtistName(
                      headerText: StringConstant.artist,
                      headerIconPath: ImagePathConstant.artistIcon,
                      nameText:
                      provider.lastOrNextBooking.last.artistName ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 5.h),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Text(
                    provider.lastOrNextBooking.last
                        .bookedServiceNames?[index] ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Text(', '),
                  itemCount: provider
                      .lastOrNextBooking.last.bookedServiceNames?.length ??
                      0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: () {},
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 5.w),
                  RedButtonWithText(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.appointmentDetailsRoute,
                      arguments: 0,
                    ),
                    buttonText: StringConstant.seeDetails,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget upcomingBookingCard(int index) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          NamedRoutes.appointmentDetailsRoute,
          arguments: index,
        ),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleWithLine(
                    lineHeight: 2.5.h,
                    lineWidth: 0.6.w,
                    fontSize: 12.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAppointment.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.2.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 2.5.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.lastOrNextBooking[index].salonName ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: <Widget>[
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getFormattedDate: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getAbbreviatedDay: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getTimeScheduled: true,
                                dateTimeString: provider
                                    .lastOrNextBooking[index].bookingCreatedFor,
                                index: index,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
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
        ),
      );
    });
  }

  Widget logoAndNotifications(HomeProvider provider) {
    TextEditingController _search = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SvgPicture.asset(
          ImagePathConstant.inAppLogo,
          height: 5.h,
        ),
        Row(
          children: <Widget>[
            AnimatedSearch(
              width: 0.16.w,
              //   textEditingController: _search,
              startIcon: Icons.search,
              closeIcon: Icons.close,
              iconColor: Colors.black,
              cursorColor: ColorsConstant.appColor,
              decoration:  InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black,),
                border: InputBorder.none,
                counterText: _search.text,
              ),
              onChanged: (String search, bool isExpanded) {
                // Placeholder callback, you can add your logic here
                print("Search Text: $search, Expanded: $isExpanded");
                _search.text = search;
                if (mounted) setState(() {});
              },
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.all(1.5.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: SvgPicture.asset(ImagePathConstant.appointmentIcon),
            ),
          ],
        )
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          bool _shouldScroll = (TextPainter(
            text: TextSpan(
                text: Provider.of<HomeProvider>(context, listen: true)
                    .userAddress,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                )),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          )..layout())
              .size
              .width >
              constraints.maxWidth * 7 / 10;

          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
              ),
              Container(
                margin: EdgeInsets.only(left: 2.w),
                height: 4.h,
                alignment: Alignment.centerLeft,
                child: _shouldScroll
                    ? Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Text(
                  "${context.read<HomeProvider>().userAddress}",
                  style: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget ourStylist() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      List<ArtistData> displayedArtists = provider.getDisplayedArtists();
      bool showLoadButton = provider.shouldShowArtistLoadButton();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 3.5.h,
              lineWidth: 1.w,
              fontSize: 15.sp,
              text: StringConstant.ourStylist.toUpperCase(),
            ),
            SizedBox(height: 2.h),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        index = 2 * index;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: (index / 2).floor().isEven,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonId ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList2.length / 2).floor(),
                      itemBuilder: (context, index) {
                        index = 2 * index + 1;
                        ArtistData artist = provider.artistList2[index];
                        return artistCard(
                          isThin: ((index - 1) / 2).floor().isOdd,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonId ?? '',
                          artistId: artist.id ?? '',
                          imagePath: artist.imageUrl ??'',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () async {
                            SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();
                            String artistId = artist.id;
                            String salonId = artist.salonId;
                            List<Service> services = artist.services;

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
                                    // Process service API response
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (showLoadButton)
              GestureDetector(
                onTap: () {
                  provider.loadMoreArtists();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: ColorsConstant.appColor, // Customize the color as needed
                  child: Center(
                    child: Text(
                      'Load More Stylists',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height:5.h),
          ],
        ),
      );
    });
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required String artistId,
    required Color color,
    required String imagePath,
    required Function() onTap,
  }) {
    print('imagePathggggggg: $imagePath'); // Add this line for debugging
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isThin
            ? EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        )
            : EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
          borderRadius: BorderRadius.circular(3.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: isThin ? 14.h : 22.h,
              child: ClipRRect(
                borderRadius: isThin
                    ? BorderRadius.circular(3.h)
                    : BorderRadius.vertical(
                  top: Radius.circular(3.h),
                ),
                child: Image.network(
                  imagePath ?? 'https://drive.google.com/uc?export=view&id=1zw2jQ0_wgXb0Dr5lAgXvCfu5Ic0ajFE0',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    salonName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List<Widget>.generate(
                      rating.ceil(),
                          (i) => SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: ColorsConstant.greyStar,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isThin ? 3.h : 5.h),
          ],
        ),
      ),
    );
  }

  Widget salonNearMe() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {

      List<SalonData2> displayedSalons = provider.getDisplayedSalons();
      bool showLoadButton = provider.shouldShowLoadButton();
      return Padding(
        padding: EdgeInsets.only(
          top: 3.h,
          right: 3.w,
          left: 3.w,
        ),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 2.5.h,
              lineWidth: 0.6.w,
              fontSize: 12.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 17.h,
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: displayedSalons.length + (showLoadButton ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedSalons.length) {
                    return GestureDetector(
                      onTap: () {
                        provider.loadMoreSalons();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          width: 35.w,
                          // margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.h),
                            color: ColorsConstant.appColor,
                          ),
                          child: Center(
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    SalonData2 salon = displayedSalons[index];
                    return GestureDetector(
                      onTap: () async {
                        String salonId = salon.id;
                        SalonDetailsProvider salonDetailsProvider = context.read<SalonDetailsProvider>();

                        try {
                          Loader.showLoader(context);
                          final response = await Dio().get(
                            'http://13.235.49.214:8800/partner/salon/single/$salonId',
                          );
                          Loader.hideLoader(context);

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

                          // Pass the salonDetails to SalonDetailsProvider
                          salonDetailsProvider.setSalonDetails(salonDetails);

                          // If the API call is successful, navigate to the SalonDetailsScreen
                          Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute, arguments: salonId);
                        } catch (error) {
                          Loader.hideLoader(context);
                          // Handle the case where the API call was not successful
                          // You can show an error message or take appropriate action
                          Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                          print('Failed to fetch salon details: $error');
                        }
                      },
                      child: Container(
                        width: 75.w,
                        margin: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: const Color(0xFF0F0F0F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                  horizontal: 3.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          salon.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          salon.salonType == 'Unisex'
                                              ? '${salon.salonType} Salon'
                                              : '${salon.salonType}\'s Salon',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ColorfulInformationCard(
                                          imagePath:
                                          ImagePathConstant.locationIconAlt,
                                          text: provider.salonList2[index]
                                              .distance.toStringAsFixed(2),
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                        SizedBox(width: 3.w),
                                        ColorfulInformationCard(
                                          imagePath: ImagePathConstant.starIcon,
                                          text:
                                          '${(salon.rating ?? 0)
                                              .toStringAsFixed(1)}',
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 28.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(1.h),
                                    ),
                                    child: salon.images != null && salon.images.isNotEmpty
                                        ? Image.network(
                                      salon.images[0].url,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/images/salon_dummy_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                salon.discount == 0 || salon.discount == null
                                    ? const SizedBox()
                                    : Container(
                                  constraints: BoxConstraints(minWidth: 13.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0.3.h,
                                    horizontal: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorsConstant.appColor,
                                    borderRadius: BorderRadius.circular(0.5.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.14),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${salon.discount} %off',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    },
    );
  }

  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithLine(
            lineHeight: 2.5.h,
            lineWidth: 0.6.w,
            fontSize: 12.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 15.h),
            margin: EdgeInsets.symmetric(vertical: 2.h),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.HAIR,
                  ),
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.MAKEUP,
                  ),
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                    context: context,
                    indexValue: 1,
                    applyServiceFilter: true,
                    appliedService: Services.SPA,
                  ),
                  imagePath: ImagePathConstant.massageImage,
                  text: StringConstant.massage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dummyDeal(HomeProvider provider) {
    return GestureDetector(
      onTap: ()async{
        Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute4);
      },
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          color: const Color(0xFF3F64E6),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 95.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dummy_deal_background.png',
                      height: 10.h,
                    ),
                    Image.asset(
                      'assets/images/dummy_deal_woman.png',
                      height: 17.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 2.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '50%',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'WOMAN HAIRCUT',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dummyDeal2(HomeProvider provider) {
    return Row(
      children:[
        GestureDetector(
          onTap: ()async {
            await   provider.DiscountFilterforMen(context);

            Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute4);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.fill,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async{
            await provider.DiscountFilterforMen(context);

            Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute4);
          },
          child: Container(
            height: 20.h,
            width:45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left:2.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.cover,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 2.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:3.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}