import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/time_date_card.dart';
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

class FavourtieScreen extends StatefulWidget {
  const FavourtieScreen({super.key});

  @override
  State<FavourtieScreen> createState() => _FavourtieScreenState();
}

class _FavourtieScreenState extends State<FavourtieScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: [
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
                            StringConstant.favourties,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 2.h, right: 5.w, left: 5.w),
                      child: selectedTab == 0
                          ? preferredArtistList()
                          : preferredSalonList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomSheet: aristAndSalonTabBar(),
        );
      },
    );
  }

  Widget preferredArtistList() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Column(
        children: <Widget>[
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 100 / 125,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 1.h,
            ),
            children: provider.artistList
                .where((element) => context
                    .read<HomeProvider>()
                    .userData
                    .preferredArtist!
                    .contains(element.id))
                .toList()
                .asMap()
                .entries
                .map((e) {
              int index = e.key;
              Artist artist = e.value;
              return GestureDetector(
                onTap: () {
                  context.read<BarberProvider>().setArtistDataFromHome(
                        artist,
                      );
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.barberProfileRoute,
                  );
                },
                child: CurvedBorderedCard(
                  borderColor: const Color(0xFFDBDBDB),
                  fillColor:
                      index.isEven ? const Color(0xFF212121) : Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    constraints: BoxConstraints(maxWidth: 45.w),
                    width: 45.w,
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
                                      backgroundImage: AssetImage(
                                        'assets/images/salon_dummy_image.png',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.baseline,
                                            baseline: TextBaseline.ideographic,
                                            child: SvgPicture.asset(
                                              ImagePathConstant.locationIconAlt,
                                              color:
                                                  ColorsConstant.purpleDistance,
                                              height: 2.h,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 1.w),
                                          ),
                                          TextSpan(
                                            text: provider.salonData
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    artist.salonId)
                                                .distanceFromUserAsString,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.sp,
                                              color:
                                                  ColorsConstant.purpleDistance,
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
                                                PlaceholderAlignment.baseline,
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
                                            text: artist.rating.toString(),
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
                                  .userData
                                  .preferredArtist!
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
                              ImagePathConstant.saveIcon,
                              color: context
                                      .read<HomeProvider>()
                                      .userData
                                      .preferredArtist!
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
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget preferredSalonList() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Column(
        children: provider.salonData
            .where((element) => context
                .read<HomeProvider>()
                .userData
                .preferredSalon!
                .contains(element.id))
            .map((preferredSalon) => Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      provider.setSelectedSalonIndex(context,
                          index: provider.salonData.indexOf(preferredSalon));
                      Navigator.pushNamed(
                          context, NamedRoutes.salonDetailsRoute);
                    },
                    child: Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child:
                                    Image.asset(preferredSalon.imagePath ?? ''),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    if (!context
                                        .read<HomeProvider>()
                                        .userData
                                        .preferredSalon!
                                        .contains(preferredSalon.id)) {
                                      provider.addPreferedSalon(
                                          context, preferredSalon.id);
                                    } else {
                                      provider.removePreferedSalon(
                                          context, preferredSalon.id);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      context
                                              .read<HomeProvider>()
                                              .userData
                                              .preferredSalon!
                                              .contains(preferredSalon.id)
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      size: 20,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 1.4.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                preferredSalon.name ?? '',
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${preferredSalon.address?? ''}',
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
                                    imagePath:
                                        ImagePathConstant.locationIconAlt,
                                    text:
                                        '${preferredSalon.distanceFromUserAsString}',
                                    color: ColorsConstant.purpleDistance,
                                  ),
                                  SizedBox(width: 3.w),
                                  ColorfulInformationCard(
                                    imagePath: ImagePathConstant.starIcon,
                                    text: '${preferredSalon.rating}',
                                    color: ColorsConstant.greenRating,
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
                                        text:
                                            "${provider.formatTime(preferredSalon.timing!.opening ?? 0)} - ${provider.formatTime(preferredSalon.timing!.closing ?? 0)}",
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
                                        text: preferredSalon.closingDay,
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
                          SizedBox(height: 1.h),
                          preferredSalon ==
                                  provider.salonData
                                      .where((element) => context
                                          .read<HomeProvider>()
                                          .userData
                                          .preferredSalon!
                                          .contains(element.id))
                                      .last
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
                ))
            .toList(),
      );
    });
  }

  Widget aristAndSalonTabBar() {
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
                    child: Text(StringConstant.artist.toUpperCase()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.salon.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
