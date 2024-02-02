import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/colorful_information_card.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/salon_detail.dart';
import '../../../models/salon_model.dart';
import '../../../models/service_response.dart';
import '../../../utils/loading_indicator.dart';
import '../../../view_model/post_auth/salon_details/salon_details_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initHome(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExploreProvider,HomeProvider>(builder: (context, provider, provider2,child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                provider2.salonList2.length == 0
                    ? SliverFillRemaining(
                        child: Container(
                          color: Colors.white,
                          height: 100.h,
                          width: 100.w,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline:
                                                  TextBaseline.ideographic,
                                              child: SvgPicture.asset(
                                                ImagePathConstant.scissorIcon,
                                                color: ColorsConstant.appColor,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 1.w),
                                            ),
                                            TextSpan(
                                              text: StringConstant.artistNearMe,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp,
                                                color: ColorsConstant.textLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async{
                                       await provider.OnlyArtist(context);
                                          Navigator.pushNamed(
                                            context,
                                            NamedRoutes.exploreStylistRoute,
                                          );
                                        },
                                        child: Text(
                                          'more>>',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsConstant.appColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxHeight: 30.h),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: provider2.artistList2.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        ArtistData artist =
                                            provider2.artistList2[index];
                                        return artistCard(
                                          artist,
                                          index,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline:
                                                  TextBaseline.ideographic,
                                              child: SvgPicture.asset(
                                                ImagePathConstant.scissorIcon,
                                                color: ColorsConstant.appColor,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 1.w),
                                            ),
                                            TextSpan(
                                              text: StringConstant.salon,
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
                                        icon: provider.selectedFilterTypeList
                                                .isNotEmpty
                                            ? Text(
                                                '${provider.selectedFilterTypeList.length}',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ColorsConstant.appColor,
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
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  StringConstant.filter,
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorsConstant.appColor,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                  color:
                                                      ColorsConstant.textLight,
                                                ),
                                                SizedBox(height: 2.h),
                                                SizedBox(
                                                  width: 30.w,
                                                  child: RedButtonWithText(
                                                    buttonText:
                                                        StringConstant.rating,
                                                    icon: CircleAvatar(
                                                      radius: 1.5.h,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: ColorsConstant
                                                            .appColor,
                                                        size: 2.h,
                                                      ),
                                                    ),
                                                    textColor: provider
                                                            .selectedFilterTypeList
                                                            .contains(FilterType
                                                                .Rating)
                                                        ? Colors.white
                                                        : ColorsConstant
                                                            .appColor,
                                                    fontSize: 10.sp,
                                                    border: Border.all(
                                                        color: ColorsConstant
                                                            .appColor),
                                                    fillColor: provider
                                                            .selectedFilterTypeList
                                                            .contains(FilterType
                                                                .Rating)
                                                        ? ColorsConstant
                                                            .appColor
                                                        : ColorsConstant
                                                            .lightAppColor,
                                                    borderRadius: 3.h,
                                                    onTap: () async{
                                                      if (provider.selectedFilterTypeList.contains(FilterType.Rating)) {
                                                        provider.selectedFilterTypeList.remove(FilterType.Rating);
                                                        await provider.initHome(context);
                                                      } else {
                                                        provider.selectedFilterTypeList.add(FilterType.Rating);
                                                        await provider.Filter(context);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    shouldShowBoxShadow: false,
                                                    isIconSuffix: true,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 1.5.w,
                                                      horizontal: 2.5.w,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                              ],
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
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        salonCard(index),
                                    itemCount:
                                        provider2.salonList2.length
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
      );
    });
  }

  Widget artistCard(
    ArtistData artist,
    int index,
  ) {
    return Consumer2<ExploreProvider,HomeProvider>(builder: (context, provider,provider2, child) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
          child: CurvedBorderedCard(
            borderColor: const Color(0xFFDBDBDB),
            fillColor: index.isEven ? const Color(0xFF212121) : Colors.white,
            child: Container(
              padding: EdgeInsets.all(3.w),
              constraints: BoxConstraints(maxWidth: 45.w),
              width: 45.w,
              child: GestureDetector(
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
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(0.5.h),
                                child: CircleAvatar(
                                  radius: 5.h,
                                  backgroundImage: NetworkImage(
                                    artist.imageUrl,
                                  ),
                                ),
                              ),
                              Text(
                                artist.name ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: index.isOdd
                                      ? ColorsConstant.textDark
                                      : Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                artist.salonName ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorsConstant.textLight,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.locationIconAlt,
                                          color: ColorsConstant.purpleDistance,
                                          height: 2.h,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                      text: artist.distance.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.starIcon,
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: artist.rating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                          color: ColorsConstant.greenRating,
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
                            provider.removePreferedArtist(
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
                              ? ImagePathConstant.saveIconFill
                              : ImagePathConstant.saveIcon,
                          color: context
                                  .read<HomeProvider>()
                                  .artistList2
                                  .contains(artist.id)
                              ? ColorsConstant.appColor
                              : index.isOdd
                                  ? const Color(0xFF212121)
                                  : Colors.white,
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
    });
  }

  Widget titleSearchBarWithLocation() {
    return Consumer2<ExploreProvider, HomeProvider>(
        builder: (context, provider, provider2, child) {
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
              title: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: Container(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Text(
                    StringConstant.exploreSalons,
                    style: StyleConstant.headingTextStyle,
                  ),
                ),
              ),
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(13.h),
                child: Consumer<ExploreProvider>(
                    builder: (context, provider, child) {
                      return TabBar(
                        controller: homeScreenController,
                        indicatorColor: Colors.white,
                        tabs: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () =>
                                FocusManager.instance.primaryFocus!.unfocus(),
                            child: Padding(
                              padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                              child: TextFormField(
                                controller: provider2.salonSearchController,
                                cursorColor: ColorsConstant.appColor,
                                style: StyleConstant.searchTextStyle,
                                textInputAction: TextInputAction.done,
                                onChanged: (searchText) =>
                                    provider2.filterArtistList(searchText),
                                decoration: StyleConstant
                                    .searchBoxInputDecoration(
                                  context,
                                  hintText: StringConstant.search,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          );
        });
  }
  Widget salonCard(int index) {
    return Consumer2<ExploreProvider,HomeProvider>(
      builder: (context, provider,homeprovider, child) {

        return Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () async {
              String salonId =  homeprovider.salonList2[index].id ?? '';
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: (homeprovider.salonList2[index].images ?? <ImageData>[] ) // Use an empty list if images is null
                        .map((ImageData imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl.url as String, // Cast imageUrl to String
                                  height: 35.h,
                                  width: SizerUtil.width,
                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 1.h,
                                right: 1.h,
                                child: InkWell(
                                  onTap: () {
                                    if (!context
                                        .read<HomeProvider>()
                                        .salonList2
                                        .contains(provider
                                        .salonData2[index].id)) {
                                      provider.addPreferedSalon(context,
                                          provider.salonData2[index].id);
                                    } else {
                                      provider.removePreferedSalon(context,
                                          provider.salonData2[index].id);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      context
                                          .read<HomeProvider>()
                                          .salonList2
                                          .contains(provider
                                          .salonData2[index].id)

                                          ?  CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      size: 2.5.h,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        homeprovider.salonList2[index].name ?? '',
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${homeprovider.salonList2[index].address}',
                        style: TextStyle(
                          color: ColorsConstant.greySalonAddress,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.locationIconAlt,
                            text:
                                '${homeprovider.salonList2[index].distance.toStringAsFixed(2)}',
                            color: ColorsConstant.purpleDistance,
                          ),
                          SizedBox(width: 3.w),
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.starIcon,
                            text: '${homeprovider.salonList2[index].rating.toStringAsFixed(1)}',
                            color: ColorsConstant.greenRating,
                          ),
                          SizedBox(width: 3.w),
                          homeprovider.salonList2[index].discount == 0 ||homeprovider.salonList2[index].discount==null?SizedBox():Container(
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
                                  '${homeprovider.salonList2[index].discount} %off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Column(
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
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${homeprovider.salonList2[index].timing.opening} - ${homeprovider.salonList2[index].timing.closing}',
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
                                text: homeprovider.salonList2[index].closedOn,
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
                  SizedBox(height: 1.2.h),
                  index == (homeprovider.salonList2.length - 1)
                      ? SizedBox(height: 10.h)
                      : Divider(
                          thickness: 1,
                          color: ColorsConstant.divider,
                        ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        );
      },
    );
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

class ExploreScreen2 extends StatefulWidget {
  const ExploreScreen2({Key? key}) : super(key: key);

  @override
  State<ExploreScreen2> createState() => _ExploreScreen2State();
}

class _ExploreScreen2State extends State<ExploreScreen2>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initHome(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExploreProvider ,HomeProvider>(builder: (context, provider,provider2, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                provider2.salonList2.length == 0
                    ? SliverFillRemaining(
                  child: Container(
                    color: Colors.white,
                    height: 100.h,
                    width: 100.w,
                  ),
                )
                    : SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                        PlaceholderAlignment.baseline,
                                        baseline:
                                        TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.artistNearMe,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: ColorsConstant.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    await provider.OnlyArtist(context);
                                    Navigator.pushNamed(
                                      context,
                                      NamedRoutes.exploreStylistRoute2,
                                    );
                                  },
                                  child: Text(
                                    'more>>',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            ConstrainedBox(
                              constraints:
                              BoxConstraints(maxHeight: 30.h),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: provider2.artistList2.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  ArtistData artist =
                                  provider2.artistList2[index];
                                  return artistCard(
                                    artist,
                                    index,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                        PlaceholderAlignment.baseline,
                                        baseline:
                                        TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.salon,
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
                                  icon: provider.selectedFilterTypeList
                                      .isNotEmpty
                                      ? Text(
                                    '${provider.selectedFilterTypeList.length}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      ColorsConstant.appColor,
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
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            StringConstant.filter,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              ColorsConstant.appColor,
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color:
                                            ColorsConstant.textLight,
                                          ),
                                          SizedBox(height: 2.h),
                                          SizedBox(
                                            width: 30.w,
                                            child: RedButtonWithText(
                                              buttonText:
                                              StringConstant.rating,
                                              icon: CircleAvatar(
                                                radius: 1.5.h,
                                                backgroundColor:
                                                Colors.white,
                                                child: Icon(
                                                  Icons.close,
                                                  color: ColorsConstant
                                                      .appColor,
                                                  size: 2.h,
                                                ),
                                              ),
                                              textColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? Colors.white
                                                  : ColorsConstant
                                                  .appColor,
                                              fontSize: 10.sp,
                                              border: Border.all(
                                                  color: ColorsConstant
                                                      .appColor),
                                              fillColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? ColorsConstant
                                                  .appColor
                                                  : ColorsConstant
                                                  .lightAppColor,
                                              borderRadius: 3.h,
                                              onTap: () async{
                                                if (provider.selectedFilterTypeList.contains(FilterType.Rating)) {
                                                  provider.selectedFilterTypeList.remove(FilterType.Rating);
                                                  await provider.initHome(context);
                                                } else {
                                                  provider.selectedFilterTypeList.add(FilterType.Rating);
                                                  await provider.Filter(context);
                                                }
                                                Navigator.pop(context);
                                              },
                                              shouldShowBoxShadow: false,
                                              isIconSuffix: true,
                                              padding:
                                              EdgeInsets.symmetric(
                                                vertical: 1.5.w,
                                                horizontal: 2.5.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                        ],
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
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    salonCard(index),
                                itemCount:
                                provider2.salonList2.length
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
      );
    });
  }

  Widget artistCard(
      ArtistData artist,
      int index,
      ) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: CurvedBorderedCard(
          borderColor: const Color(0xFFDBDBDB),
          fillColor: index.isEven ? const Color(0xFF212121) : Colors.white,
          child: Container(
            padding: EdgeInsets.all(3.w),
            constraints: BoxConstraints(maxWidth: 45.w),
            width: 45.w,
            child: GestureDetector(
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
                  Navigator.pushNamed(context, NamedRoutes.barberProfileRoute2, arguments: artistId);
                } catch (error) {
                  Loader.hideLoader(context);
                  // Handle the case where the API call was not successful
                  // You can show an error message or take appropriate action
                  Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                  print('Failed to fetch details: $error');
                }
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.5.h),
                              child: CircleAvatar(
                                radius: 5.h,
                                backgroundImage: NetworkImage(
                                  artist.imageUrl,
                                ),
                              ),
                            ),
                            Text(
                              artist.name ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: index.isOdd
                                    ? ColorsConstant.textDark
                                    : Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              artist.salonName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsConstant.textLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.locationIconAlt,
                                        color: ColorsConstant.purpleDistance,
                                        height: 2.h,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.distance.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.purpleDistance,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.greenRating,
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
                            ? ImagePathConstant.saveIconFill
                            : ImagePathConstant.saveIcon,
                        color: context
                            .read<HomeProvider>()
                            .artistList2
                            .contains(artist.id)
                            ? ColorsConstant.appColor
                            : index.isOdd
                            ? const Color(0xFF212121)
                            : Colors.white,
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
    });
  }

  Widget titleSearchBarWithLocation() {
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
        title: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Container(
            padding: EdgeInsets.only(top: 3.h),
            child: Row(
              children:[
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute2);
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                Text(
                  StringConstant.exploreSalons,
                  style: StyleConstant.headingTextStyle,
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(13.h),
          child: Consumer2<ExploreProvider,HomeProvider>(builder: (context, provider,provider2, child) {
            return TabBar(
              controller: homeScreenController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                    child: TextFormField(
                      controller: provider.salonSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: StyleConstant.searchTextStyle,
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider2.filterArtistList(searchText),
                      decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget salonCard(int index) {
    return Consumer2<ExploreProvider,HomeProvider>(
      builder: (context, provider,homeprovider, child) {

        return Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () async {
              String salonId =  provider.salonData2[index].id ?? '';
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: (homeprovider.salonList2[index].images ?? <ImageData>[]) // Use an empty list if images is null
                        .map((ImageData imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl.url as String, // Cast imageUrl to String
                                  height: 35.h,
                                  width: SizerUtil.width,
                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 1.h,
                                right: 1.h,
                                child: InkWell(
                                  onTap: () {
                                   showSignInDialog(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      context
                                          .read<HomeProvider>()
                                          .salonList2
                                          .contains(homeprovider
                                          .salonList2[index].id)

                                          ?  CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      size: 2.5.h,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        homeprovider.salonList2[index].name ?? '',
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${homeprovider.salonList2[index].address}',
                        style: TextStyle(
                          color: ColorsConstant.greySalonAddress,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.locationIconAlt,
                            text:
                            '${homeprovider.salonList2[index].distance.toStringAsFixed(2)}',
                            color: ColorsConstant.purpleDistance,
                          ),
                          SizedBox(width: 3.w),
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.starIcon,
                            text: '${homeprovider.salonList2[index].rating.toStringAsFixed(1)}',
                            color: ColorsConstant.greenRating,
                          ),
                          SizedBox(width: 3.w),
                          homeprovider.salonList2[index].discount == 0 ||homeprovider.salonList2[index].discount==null?SizedBox():Container(
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
                                  '${homeprovider.salonList2[index].discount} %off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Column(
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
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${homeprovider.salonList2[index].timing.opening} - ${homeprovider.salonList2[index].timing.closing}',
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
                                text: homeprovider.salonList2[index].closedOn,
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
                  SizedBox(height: 1.2.h),
                  index == (homeprovider.salonList2.length - 1)
                      ? SizedBox(height: 10.h)
                      : Divider(
                    thickness: 1,
                    color: ColorsConstant.divider,
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 60,
                    width:60
                ),
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
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
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
                    child: Text("OK",style: TextStyle( color:Colors.black,)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          NamedRoutes.authenticationRoute
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




class ExploreScreen3 extends StatefulWidget {
  const ExploreScreen3({Key? key}) : super(key: key);

  @override
  State<ExploreScreen3> createState() => _ExploreScreen3State();
}

class _ExploreScreen3State extends State<ExploreScreen3>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   //   context.read<ExploreProvider>().initHome2(context);
  //  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider,ExploreProvider>(builder: (context, provider2,provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                provider2.salonList2.length == 0
                    ? SliverFillRemaining(
                  child: Container(
                    color: Colors.white,
                    height: 100.h,
                    width: 100.w,
                  ),
                )
                    : SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                        PlaceholderAlignment.baseline,
                                        baseline:
                                        TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.artistNearMe,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: ColorsConstant.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    await provider.OnlyArtist(context);
                                    Navigator.pushNamed(
                                      context,
                                      NamedRoutes.exploreStylistRoute,
                                    );
                                  },
                                  child: Text(
                                    'more>>',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            ConstrainedBox(
                              constraints:
                              BoxConstraints(maxHeight: 30.h),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: provider2.artistList2.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  ArtistData artist =
                                  provider2.artistList2[index];
                                  return artistCard(
                                    artist,
                                    index,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                        PlaceholderAlignment.baseline,
                                        baseline:
                                        TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.salon,
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
                                  icon: provider.selectedFilterTypeList
                                      .isNotEmpty
                                      ? Text(
                                    '${provider.selectedFilterTypeList.length}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      ColorsConstant.appColor,
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
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            StringConstant.filter,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              ColorsConstant.appColor,
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color:
                                            ColorsConstant.textLight,
                                          ),
                                          SizedBox(height: 2.h),
                                          SizedBox(
                                            width: 30.w,
                                            child: RedButtonWithText(
                                              buttonText:
                                              StringConstant.rating,
                                              icon: CircleAvatar(
                                                radius: 1.5.h,
                                                backgroundColor:
                                                Colors.white,
                                                child: Icon(
                                                  Icons.close,
                                                  color: ColorsConstant
                                                      .appColor,
                                                  size: 2.h,
                                                ),
                                              ),
                                              textColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? Colors.white
                                                  : ColorsConstant
                                                  .appColor,
                                              fontSize: 10.sp,
                                              border: Border.all(
                                                  color: ColorsConstant
                                                      .appColor),
                                              fillColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? ColorsConstant
                                                  .appColor
                                                  : ColorsConstant
                                                  .lightAppColor,
                                              borderRadius: 3.h,
                                              onTap: () async{
                                                if (provider.selectedFilterTypeList.contains(FilterType.Rating)) {
                                                  provider.selectedFilterTypeList.remove(FilterType.Rating);
                                                  await provider.initHome(context);
                                                } else {
                                                  provider.selectedFilterTypeList.add(FilterType.Rating);
                                                  await provider.Filter(context);
                                                }
                                                Navigator.pop(context);
                                              },
                                              shouldShowBoxShadow: false,
                                              isIconSuffix: true,
                                              padding:
                                              EdgeInsets.symmetric(
                                                vertical: 1.5.w,
                                                horizontal: 2.5.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                        ],
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
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    salonCard(index),
                                itemCount:
                                provider2.salonList2.length
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
      );
    });
  }

  Widget artistCard(
      ArtistData artist,
      int index,
      ) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: CurvedBorderedCard(
          borderColor: const Color(0xFFDBDBDB),
          fillColor: index.isEven ? const Color(0xFF212121) : Colors.white,
          child: Container(
            padding: EdgeInsets.all(3.w),
            constraints: BoxConstraints(maxWidth: 45.w),
            width: 45.w,
            child: GestureDetector(
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
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.5.h),
                              child: CircleAvatar(
                                radius: 5.h,
                                backgroundImage: NetworkImage(
                                  artist.imageUrl,
                                ),
                              ),
                            ),
                            Text(
                              artist.name ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: index.isOdd
                                    ? ColorsConstant.textDark
                                    : Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              artist.salonId ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsConstant.textLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.ideographic,
                                    child: SvgPicture.asset(
                                      ImagePathConstant.starIcon,
                                      color: ColorsConstant.greenRating,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(width: 1.w),
                                  ),
                                  TextSpan(
                                    text: artist.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                      color: ColorsConstant.greenRating,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.locationIconAlt,
                                        color: ColorsConstant.purpleDistance,
                                        height: 2.h,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.purpleDistance,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.greenRating,
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
                       // showSignInDialog(context);
                      },
                      child: SvgPicture.asset(
                        context
                            .read<HomeProvider>()
                            .artistList2
                            .contains(artist.id)
                            ? ImagePathConstant.saveIconFill
                            : ImagePathConstant.saveIcon,
                        color: context
                            .read<HomeProvider>()
                            .artistList2
                            .contains(artist.id)
                            ? ColorsConstant.appColor
                            : index.isOdd
                            ? const Color(0xFF212121)
                            : Colors.white,
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
    });
  }

  Widget titleSearchBarWithLocation() {
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
        title: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Container(
            padding: EdgeInsets.only(top: 3.h),
            child: Row(
              children:[
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                Text(
                  StringConstant.exploreSalons,
                  style: StyleConstant.headingTextStyle,
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(13.h),
          child: Consumer2<ExploreProvider,HomeProvider>(builder: (context, provider,provider2, child) {
            return TabBar(
              controller: homeScreenController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                    child: TextFormField(
                      controller: provider.salonSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: StyleConstant.searchTextStyle,
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider2.filterArtistList(searchText),
                      decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget salonCard(int index) {
    return Consumer2<ExploreProvider,HomeProvider>(
      builder: (context, provider,homeprovider, child) {

        return Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () async {
              String salonId =  provider.salonData2[index].id ?? '';
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: (homeprovider.salonList2[index].images ?? <ImageData>[]) // Use an empty list if images is null
                        .map((ImageData imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl.url as String, // Cast imageUrl to String
                                  height: 35.h,
                                  width: SizerUtil.width,
                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 1.h,
                                right: 1.h,
                                child: InkWell(
                                  onTap: () {
                                   // showSignInDialog(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      context
                                          .read<HomeProvider>()
                                          .salonList2
                                          .contains(homeprovider
                                          .salonList2[index].id)

                                          ?  CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      size: 2.5.h,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        homeprovider.salonList2[index].name ?? '',
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${  homeprovider.salonList2[index].address}',
                        style: TextStyle(
                          color: ColorsConstant.greySalonAddress,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.locationIconAlt,
                            text:
                            '${  homeprovider.salonList2[index].distance.toStringAsFixed(2)}',
                            color: ColorsConstant.purpleDistance,
                          ),
                          SizedBox(width: 3.w),
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.starIcon,
                            text: '${  homeprovider.salonList2[index].rating.toStringAsFixed(1)}',
                            color: ColorsConstant.greenRating,
                          ),
                          SizedBox(width: 3.w),
                          homeprovider.salonList2[index].discount == 0 ||  homeprovider.salonList2[index].discount==null?SizedBox():Container(
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
                                  '${  homeprovider.salonList2[index].discount} %off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Column(
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
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${  homeprovider.salonList2[index].timing.opening} - ${  homeprovider.salonList2[index].timing.closing}',
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
                                text:   homeprovider.salonList2[index].closedOn,
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
                  SizedBox(height: 1.2.h),
                  index == (  homeprovider.salonList2.length - 1)
                      ? SizedBox(height: 10.h)
                      : Divider(
                    thickness: 1,
                    color: ColorsConstant.divider,
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        );
      },
    );
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

