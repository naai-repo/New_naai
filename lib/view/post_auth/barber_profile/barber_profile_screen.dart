import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/add_review_component.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/contact_and_interaction_widget.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/artist_detail.dart';
import '../../../models/salon_detail.dart';
import '../../../utils/loading_indicator.dart';
import '../create_booking/create_booking_screen.dart';

class BarberProfileScreen extends StatefulWidget {
  BarberProfileScreen({Key? key}) : super(key: key);

  @override
  State<BarberProfileScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<BarberProfileScreen> {
  int selectedTab = 0;
  num myShowPrice = 0;


  @override
  void initState() {
    BarberProvider barberProvider = context.read<BarberProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarberProvider>(
      builder: (context, barberProvider, child) {
        return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
          BarberProvider barberProvider = context.read<BarberProvider>(); // Use the same instance
          if (provider.salonDetails!.data.data.discount == 0 ||
              provider.salonDetails!.data.data.discount == null){
            myShowPrice = provider.totalPrice;
          }
          else{
            provider.setShowPrice(provider.totalPrice,provider.salonDetails!.data.data.discount!);
            myShowPrice = provider.showPrice;
          }
          bool servicesSelected = provider.barbergetSelectedServices().isNotEmpty;

          return Scaffold(
            resizeToAvoidBottomInset: true,
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
                              StringConstant.barberProfile,
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
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 1.h, right: 4.w, left: 4.w),
                                  padding: EdgeInsets.all(1.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        2.h),
                                  ),
                                  child: barberOverview(),
                                ),
                                SizedBox(height: 2.h),
                                Divider(
                                  thickness: 2,
                                  height: 0,
                                  color: ColorsConstant.graphicFillDark,
                                ),
                                servicesAndReviewTabBar(),
                                selectedTab == 0
                                    ? servicesTab()
                                    : reviewColumn(),
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
                /*
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
                        Text(
                            'Rs. ${context
                                .read<SalonDetailsProvider>()
                                .totalPrice}',
                            style: StyleConstant.textDark15sp600Style),
                      ],
                    ),
                    VariableWidthCta(
                      onTap: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateBookingScreen2(
                                    artistName: barberProvider.artist
                                        .name ??
                                        '', // Pass the name here
                                  ),
                            ),
                          ),
                      isActive: true,
                      buttonText: StringConstant.confirmBooking,
                    )
                  ],
                ),
                */
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
                    provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null
                        ?
                    SizedBox()
                   : Column(
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
                      onTap: () async{
                        String salonId = provider.salonDetails!.data.data.id;
                        List<String> selectedServiceIds = provider.barbergetSelectedServices()
                            .map((service) => service.id)
                            .toList();
                        await provider.fetchArtist(context,salonId, selectedServiceIds);
                        provider.setSchedulingStatus(onSelectStaff: true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateBookingScreen2(
                                  artistName: barberProvider.artistDetails!.name,
                                  artistId: barberProvider.artistDetails!.id,
                                ),
                          ),

                        );
                        print('artist id : ${barberProvider.artistDetails!.name}');
                        print('artist name : ${barberProvider.artistDetails!.id}');
                        print(' service : ${selectedServiceIds}');
                        },
                      isActive: true,
                      buttonText: StringConstant.confirmBooking,
                    )
                  ],
                ),
              )
                 //   : SizedBox()
              ],
              ),
          );
        }
        );
      },
    );
  }

  Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      BarberProvider barberProvider = context.read<BarberProvider>(); // Use the same instance
      Set<Service2> selectedServices = provider.barbergetSelectedServices();
print('${barberProvider.Servicetitle}');
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
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
          context.read<BarberProvider>().artistDetails!.services.length == 0
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
                  itemCount:
                      context.read<BarberProvider>().artistDetails!.services.length,
                  itemBuilder: (context, index) {
                    Data? serviceDetail3 =  context.read<BarberProvider>().artistDetails;
                    Service2? serviceDetail  =
                        context.read<BarberProvider>().artistDetails!.services[index];
                  //  bool isAdded  = provider.salonDetails!.data.services
                  //      ?.contains(serviceDetail.id) ??
                 //   false;// Assuming paid is a boolean

                    return GestureDetector(
                      onTap: () {
                        provider.toggleSelectedServicebarber(serviceDetail!);
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
                                    serviceDetail3!.targetGender == Gender.MEN
                                        ? ImagePathConstant.manIcon
                                        : ImagePathConstant.womanIcon,
                                    height: 4.h,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      provider.serviceData!.data.serviceTitle ?? '',
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
                                  "Rs. ${serviceDetail.price}",
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
                                    provider.toggleSelectedServicebarber(
                                        serviceDetail!);
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
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget genderAndSearchFilterWidget() {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget reviewColumn() {
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent(reviewForSalon: false),
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
                            review.artistId != null &&
                            review.artistId == provider.artist.id)
                        .isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: context
                            .read<HomeProvider>()
                            .reviewList
                            .where((review) =>
                                review.artistId != null &&
                                review.artistId == provider.artist.id)
                            .map((reviewItem) => Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.h),
                                    border: Border.all(
                                      color:
                                          ColorsConstant.reviewBoxBorderColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(
                                          255,
                                          229,
                                          229,
                                          229,
                                        ),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 0.5.h,
                                                bottom: 0.2.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Store : ${reviewItem.salonName}',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  reviewItem.artistName != null
                                                      ? Text(
                                                          'For : ${reviewItem.artistName}',
                                                          style: TextStyle(
                                                            fontSize: 9.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              dense: true,
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  'assets/images/salon_dummy_image.png',
                                                ),
                                              ),
                                              title: Text.rich(
                                                TextSpan(
                                                  text:
                                                      reviewItem.userName ?? "",
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '\n${DateFormat("dd MMMM y").format(reviewItem.createdAt ?? DateTime.now())}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.h,
                                                bottom: 1.h,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  ...List.generate(
                                                    5,
                                                    (i) => SvgPicture.asset(
                                                      ImagePathConstant
                                                          .starIcon,
                                                      color: i <
                                                              (int.parse(reviewItem
                                                                      .rating
                                                                      ?.round()
                                                                      .toString() ??
                                                                  "0"))
                                                          ? ColorsConstant
                                                              .appColor
                                                          : ColorsConstant
                                                              .greyStar,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ReadMoreText(
                                              reviewItem.comment ?? "",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                              ),
                                              trimCollapsedText: "\nView more",
                                              trimExpandedText: "\nView less",
                                              trimLines: 2,
                                              trimMode: TrimMode.Line,
                                              moreStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConstant.appColor,
                                              ),
                                              lessStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConstant.appColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
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

  Widget barberOverview() {
    return Consumer2<BarberProvider, ExploreProvider>(
        builder: (context, barberProvider, exploreProvider, child) {

      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9.5.h),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: Colors.grey.shade300,
                        spreadRadius: 0.5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 7.h,
                    backgroundImage:
                        NetworkImage(barberProvider.artistDetails!.imageUrl)
                            as ImageProvider,
                  ),

                ),
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      barberProvider.artistDetails?.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      StringConstant.worksAt,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.worksAtColor,
                        fontSize: 8.sp,
                      ),
                    ),
                    Text(
                      barberProvider.salonDetails!.data.data.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 38.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      StringConstant.rating,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        5,
                        (i) => (i >
                                int.parse(barberProvider.artistDetails?.rating
                                            ?.round()
                                            .toString() ??
                                        "0") -
                                    1)
                            ? SvgPicture.asset(
                                ImagePathConstant.starIcon,
                                color: ColorsConstant.greyStar,
                                height: 2.2.h,
                              )
                            : SvgPicture.asset(
                                ImagePathConstant.starIcon,
                                color: ColorsConstant.yellowStar,
                                height: 2.2.h,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 38.w,
                child: GestureDetector(
                  onTap: () async {
                    String salonId = barberProvider.artistDetails!.salonId;
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
                    padding: EdgeInsets.symmetric(
                      vertical: 1.2.h,
                      horizontal: 5.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.h),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 0.1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          StringConstant.viewSalon,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsConstant.appColor,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        SvgPicture.asset(
                          ImagePathConstant.rightArrowIcon,
                          color: ColorsConstant.appColor,
                          height: 1.5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ContactAndInteractionWidget(
            iconOnePath: ImagePathConstant.phoneIcon,
            iconTwoPath: ImagePathConstant.shareIcon,
            iconThreePath: ImagePathConstant.saveIcon,
            iconFourPath: ImagePathConstant.instagramIcon,
            onTapIconOne: () => launchUrl(
              Uri(
                scheme: 'tel',
                path: StringConstant.generalContantNumber,
              ),
            ),
            onTapIconTwo: () => launchUrl(
              Uri.parse(barberProvider.artistDetails!.links.instagram ??
                  'https://www.instagram.com/naaiindia'),
            ),
            onTapIconThree: () {
              if (context
                  .read<HomeProvider>()
                  .artistList2
                  .contains(barberProvider.artistDetails!.id)) {
                exploreProvider.removePreferedArtist(
                  context,
                  barberProvider.artistDetails!.id,
                );
              } else {
                exploreProvider.addPreferedArtist(
                  context,
                  barberProvider.artistDetails!.id,
                );
              }
            },
            onTapIconFour: () => launchUrl(
              Uri.parse('https://www.instagram.com/naaiindia'),
            ),
          ),
          SizedBox(height: 1.h),
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
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: [
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
}

class BarberProfileScreen2 extends StatefulWidget {
  BarberProfileScreen2({Key? key}) : super(key: key);

  @override
  State<BarberProfileScreen2> createState() => _BarberProfileScreen2State();
}

class _BarberProfileScreen2State extends State<BarberProfileScreen2> {
  int selectedTab = 0;
  num myShowPrice = 0;


  @override
  void initState() {
    BarberProvider barberProvider = context.read<BarberProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarberProvider>(
      builder: (context, barberProvider, child) {
        return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
          BarberProvider barberProvider = context.read<BarberProvider>(); // Use the same instance
          if (provider.salonDetails!.data.data.discount == 0 ||
              provider.salonDetails!.data.data.discount == null){
            myShowPrice = provider.totalPrice;
          }
          else{
            provider.setShowPrice(provider.totalPrice,provider.salonDetails!.data.data.discount!);
            myShowPrice = provider.showPrice;
          }
          bool servicesSelected = provider.barbergetSelectedServices().isNotEmpty;

          return Scaffold(
            resizeToAvoidBottomInset: true,
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
                              StringConstant.barberProfile,
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
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 1.h, right: 4.w, left: 4.w),
                                  padding: EdgeInsets.all(1.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        2.h),
                                  ),
                                  child: barberOverview(),
                                ),
                                SizedBox(height: 2.h),
                                Divider(
                                  thickness: 2,
                                  height: 0,
                                  color: ColorsConstant.graphicFillDark,
                                ),
                                servicesAndReviewTabBar(),
                                selectedTab == 0
                                    ? servicesTab()
                                    : reviewColumn(),
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
                        provider.salonDetails!.data.data.discount==0||provider.salonDetails!.data.data.discount==null
                            ?
                        SizedBox()
                            : Column(
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
                          onTap: () {
                           showSignInDialog(context);
                          },
                          isActive: true,
                          buttonText: StringConstant.confirmBooking,
                        )
                      ],
                    ),
                  )
                //   : SizedBox()
              ],
            ),
          );
        }
        );
      },
    );
  }

  Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      BarberProvider barberProvider = context.read<BarberProvider>(); // Use the same instance
      Set<Service2> selectedServices = provider.barbergetSelectedServices();
      print('${barberProvider.Servicetitle}');
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
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
          context.read<BarberProvider>().artistDetails!.services.length == 0
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
            itemCount:
            context.read<BarberProvider>().artistDetails!.services.length,
            itemBuilder: (context, index) {
              Data? serviceDetail3 =  context.read<BarberProvider>().artistDetails;
              Service2? serviceDetail  =
              context.read<BarberProvider>().artistDetails!.services[index];
              //  bool isAdded  = provider.salonDetails!.data.services
              //      ?.contains(serviceDetail.id) ??
              //   false;// Assuming paid is a boolean

              return GestureDetector(
                onTap: () {
                  provider.toggleSelectedServicebarber(serviceDetail!);
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
                              serviceDetail3!.targetGender == Gender.MEN
                                  ? ImagePathConstant.manIcon
                                  : ImagePathConstant.womanIcon,
                              height: 4.h,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                provider.serviceData!.data.serviceTitle ?? '',
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
                            "Rs. ${serviceDetail.price}",
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
                              provider.toggleSelectedServicebarber(
                                  serviceDetail!);
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
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget genderAndSearchFilterWidget() {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
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

  Widget reviewColumn() {
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent2(reviewForSalon: false),
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
                review.artistId != null &&
                    review.artistId == provider.artist.id)
                    .isNotEmpty
                    ? ListView(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: context
                      .read<HomeProvider>()
                      .reviewList
                      .where((review) =>
                  review.artistId != null &&
                      review.artistId == provider.artist.id)
                      .map((reviewItem) => Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1.h),
                      border: Border.all(
                        color:
                        ColorsConstant.reviewBoxBorderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(
                            255,
                            229,
                            229,
                            229,
                          ),
                          spreadRadius: 0.1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 0.5.h,
                                  bottom: 0.2.h,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Store : ${reviewItem.salonName}',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    reviewItem.artistName != null
                                        ? Text(
                                      'For : ${reviewItem.artistName}',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              ListTile(
                                minLeadingWidth: 0,
                                contentPadding: EdgeInsets.zero,
                                visualDensity:
                                VisualDensity.compact,
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/salon_dummy_image.png',
                                  ),
                                ),
                                title: Text.rich(
                                  TextSpan(
                                    text:
                                    reviewItem.userName ?? "",
                                    children: [
                                      TextSpan(
                                        text:
                                        '\n${DateFormat("dd MMMM y").format(reviewItem.createdAt ?? DateTime.now())}',
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.w500,
                                          fontSize: 10.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 1.h,
                                  bottom: 1.h,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    ...List.generate(
                                      5,
                                          (i) => SvgPicture.asset(
                                        ImagePathConstant
                                            .starIcon,
                                        color: i <
                                            (int.parse(reviewItem
                                                .rating
                                                ?.round()
                                                .toString() ??
                                                "0"))
                                            ? ColorsConstant
                                            .appColor
                                            : ColorsConstant
                                            .greyStar,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ReadMoreText(
                                reviewItem.comment ?? "",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                                trimCollapsedText: "\nView more",
                                trimExpandedText: "\nView less",
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorsConstant.appColor,
                                ),
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorsConstant.appColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                      .toList(),
                )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
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

  Widget barberOverview() {
    return Consumer2<BarberProvider, ExploreProvider>(
        builder: (context, barberProvider, exploreProvider, child) {

          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.5.h),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 2),
                            color: Colors.grey.shade300,
                            spreadRadius: 0.5,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 7.h,
                        backgroundImage:
                        NetworkImage(barberProvider.artistDetails!.imageUrl)
                        as ImageProvider,
                      ),

                    ),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          barberProvider.artistDetails?.name ?? '',
                          style: TextStyle(
                            color: ColorsConstant.blackAvailableStaff,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        SizedBox(height: 0.6.h),
                        Text(
                          StringConstant.worksAt,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: ColorsConstant.worksAtColor,
                            fontSize: 8.sp,
                          ),
                        ),
                        Text(
                          barberProvider.salonDetails!.data.data.name ?? '',
                          style: TextStyle(
                            color: ColorsConstant.blackAvailableStaff,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 38.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          StringConstant.rating,
                          style: TextStyle(
                            color: ColorsConstant.textDark,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List<Widget>.generate(
                            5,
                                (i) => (i >
                                int.parse(barberProvider.artistDetails?.rating
                                    ?.round()
                                    .toString() ??
                                    "0") -
                                    1)
                                ? SvgPicture.asset(
                              ImagePathConstant.starIcon,
                              color: ColorsConstant.greyStar,
                              height: 2.2.h,
                            )
                                : SvgPicture.asset(
                              ImagePathConstant.starIcon,
                              color: ColorsConstant.yellowStar,
                              height: 2.2.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 38.w,
                    child: GestureDetector(
                      onTap: () async {
                        String salonId = barberProvider.artistDetails!.salonId;
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
                        padding: EdgeInsets.symmetric(
                          vertical: 1.2.h,
                          horizontal: 5.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              StringConstant.viewSalon,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorsConstant.appColor,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            SvgPicture.asset(
                              ImagePathConstant.rightArrowIcon,
                              color: ColorsConstant.appColor,
                              height: 1.5.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              ContactAndInteractionWidget(
                iconOnePath: ImagePathConstant.phoneIcon,
                iconTwoPath: ImagePathConstant.shareIcon,
                iconThreePath: ImagePathConstant.saveIcon,
                iconFourPath: ImagePathConstant.instagramIcon,
                onTapIconOne: () => launchUrl(
                  Uri(
                    scheme: 'tel',
                    path: StringConstant.generalContantNumber,
                  ),
                ),
                onTapIconTwo: () => launchUrl(
                  Uri.parse(barberProvider.artistDetails!.links.instagram ??
                      'https://www.instagram.com/naaiindia'),
                ),
                onTapIconThree: () {
                  if (context
                      .read<HomeProvider>()
                      .artistList2
                      .contains(barberProvider.artistDetails!.id)) {
                    exploreProvider.removePreferedArtist(
                      context,
                      barberProvider.artistDetails!.id,
                    );
                  } else {
                    exploreProvider.addPreferedArtist(
                      context,
                      barberProvider.artistDetails!.id,
                    );
                  }
                },
                onTapIconFour: () => launchUrl(
                  Uri.parse('https://www.instagram.com/naaiindia'),
                ),
              ),
              SizedBox(height: 1.h),
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
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: [
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