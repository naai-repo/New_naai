import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../models/salon_detail.dart';

class ReusableWidgets {
  static Widget redFullWidthButton({
    required String buttonText,
    required VoidCallback onTap,
    required bool isActive,
    Color? fillColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isActive ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          color: fillColor ??
              (isActive ? ColorsConstant.appColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 2.0),
                    color: Colors.grey,
                    spreadRadius: 0.2,
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget socialSigninButton({
    required bool isAppleLogin,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsConstant.greyBorderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              isAppleLogin
                  ? ImagePathConstant.appleIcon
                  : ImagePathConstant.googleIcon,
            ),
            SizedBox(width: 10.w),
            Text(
              isAppleLogin
                  ? StringConstant.signInWithApple
                  : StringConstant.signInWithGoogle,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showFlutterToast(
    BuildContext context,
    String text,
  ) {
    Logger().log(Level.wtf, text);
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: ColorsConstant.appColor,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.TOP,
    );
  }

  /// Location icon with circular white background
  static Widget circularLocationWidget() {
    return Flexible(
      flex: 0,
      child: Container(
        padding: EdgeInsets.all(1.3.h),
        margin: EdgeInsets.only(right: 1.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Colors.grey.shade300,
              spreadRadius: 0.5,
              blurRadius: 15,
            ),
          ],
        ),
        child: SvgPicture.asset(
          ImagePathConstant.locationIcon,
          color: ColorsConstant.appColor,
        ),
      ),
    );
  }

  /// Build dialogue box for salon overview, to appear when clicked on salon
  /// location on map.
  static Future<void> salonOverviewOnMapDialogue(
    BuildContext context, {
    required SalonData clickedSalonData,
  }) async {
    await showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 100.h,
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(1.h),
              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: ColorsConstant.appColor),
              ),
              child: Container(
                height: 15.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 15.h,
                        height: 15.h,
                        child: Image.asset(
                          clickedSalonData.imagePath ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            clickedSalonData.name ?? "",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            clickedSalonData.address?.addressString ?? "",
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: ColorsConstant.greySalonAddress,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                clickedSalonData.rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Row(
                                children: <Widget>[
                                  ...List.generate(
                                    5,
                                    (i) => SvgPicture.asset(
                                      ImagePathConstant.starIcon,
                                      color: i <
                                              (clickedSalonData.rating
                                                      ?.floor() ??
                                                  0)
                                          ? ColorsConstant.yellowStar
                                          : ColorsConstant.greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<ExploreProvider>()
                                  .setSalonIndexByData(
                                    context,
                                    clickedSalonData,
                                  );
                              Navigator.pushNamed(
                                context,
                                NamedRoutes.salonDetailsRoute,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.h,
                                horizontal: 5.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.h),
                                color: ColorsConstant.appColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    StringConstant.viewSalon,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.rightArrowIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Common background widget for all the four main screens of the app
  static Widget appScreenCommonBackground() {
    return Container(
      height: 100.h,
      color: Color(0xFF212121),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
           //   color: Colors.grey.shade600,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
            //  color: Colors.grey.shade600,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
           //   color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  /// Re-center button widget
  static Widget recenterWidget(
    BuildContext context, {
    required dynamic provider,
  }) {
    return Positioned(
      top: 2.h,
      right: 2.h,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
         Loader.showLoader(context);
          LatLng latLng = await provider.fetchCurrentLocation(context);
          await provider.animateToPosition(latLng);
          Loader.hideLoader(context);
        },
        child: Container(
          height: 5.h,
          width: 5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Image.asset(ImagePathConstant.currentLocationPointer),
        ),
      ),
    );
  }

  /// Salon services tab content
  static Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
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
          provider.salonDetails!.data.services.length == 0
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
                  itemCount: provider.salonDetails!.data.services.length,
                  itemBuilder: (context, index) {
                    DataService? serviceDetail =
                        provider.salonDetails!.data.services[index];
                    bool isAdded = provider.salonDetails!.data.services
                            ?.contains(serviceDetail.id) ??
                        false;
                    return GestureDetector(
                      onTap: () =>
                          provider.setSelectedService2(serviceDetail.id ?? ''),
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
                                  activeColor: ColorsConstant.appColor,
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 193, 193, 193),
                                    width: 2,
                                  ),
                                  value: isAdded,
                                  onChanged: (value) {
                                    isAdded = value ?? false;
                                    provider.setSelectedService2(
                                        serviceDetail.id ?? '');
                                    //      provider.toggleServiceSelection(serviceDetail.id ?? '', value ?? false),
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

  static Widget reviewsTab() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addReviewContainer(),
              Padding(
                padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                child: Text(
                  StringConstant.userReviews,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorsConstant.blackAvailableStaff,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              context
                      .read<HomeProvider>()
                      .reviewList
                      .where((review) =>
                          review.salonId == provider.selectedSalonData.id)
                      .isNotEmpty
                  ? reviewList()
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  static Widget serviceCategoryFilterWidget() {
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

  static Widget reviewList() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return ListView(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: context
            .read<HomeProvider>()
            .reviewList
            .where((review) => review.salonId == provider.selectedSalonData.id)
            .map((reviewItem) => Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.h),
                    border:
                        Border.all(color: ColorsConstant.reviewBoxBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 229, 229, 229),
                        spreadRadius: 0.1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      reviewerImageAndName(
                        imageUrl: reviewItem.imagePath,
                        userName: reviewItem.userName ?? "",
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ...List.generate(
                                  5,
                                  (i) => SvgPicture.asset(
                                    ImagePathConstant.starIcon,
                                    color: i <
                                            (int.parse(context
                                                    .read<HomeProvider>()
                                                    .artistList
                                                    .firstWhere((artist) =>
                                                        artist.id ==
                                                        reviewItem.artistId)
                                                    .rating
                                                    ?.round()
                                                    .toString() ??
                                                "0"))
                                        ? ColorsConstant.appColor
                                        : ColorsConstant.greyStar,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                              child: Text(
                                '${DateFormat.yMMMM().format(reviewItem.createdAt ?? DateTime.now())}',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Text(
                              reviewItem.comment ?? "",
                              style: TextStyle(
                                fontSize: 10.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    });
  }

  static Widget reviewerImageAndName(
      {String? imageUrl, required String userName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 5.h,
          backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 10.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
      ],
    );
  }

  static Widget addReviewContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      decoration: BoxDecoration(
          color: ColorsConstant.graphicFillDark,
          borderRadius: BorderRadius.circular(2.h)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 5.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 5.w),
              ...List.generate(
                5,
                (index) => SvgPicture.asset(
                  ImagePathConstant.reviewStarIcon,
                  color: ColorsConstant.reviewStarGreyColor,
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 6.h,
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 1.5.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.5.h),
            ),
            child: Text(
              StringConstant.submitReview,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: ColorsConstant.appColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static SliverAppBar transparentFlexibleSpace() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true,
      expandedHeight: 5.h,
      collapsedHeight: 0,
      flexibleSpace: const FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
      ),
      toolbarHeight: 0,
    );
  }
}
