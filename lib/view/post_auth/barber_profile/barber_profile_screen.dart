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
          HomeProvider home = context.read<HomeProvider>(); // Use the same instance
          context.read<ReviewsProvider>().fetchReviews(barberProvider.artistDetails!.id);
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
              bottomNavigationBar:Visibility(
              visible:(servicesSelected),
           child:  Container(
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
                      onTap: () async{
                        String salonId = provider.salonDetails!.data.data.id;
                        List<String> selectedServiceIds = provider.barbergetSelectedServices()
                            .map((service) => service.serviceId)
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
              ),
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
      HomeProvider homeProvider = context.read<HomeProvider>();
      Set<Service2> selectedServices = provider.barbergetSelectedServices();

      List<Service2> filteredServices = context.read<BarberProvider>().artistDetails!.services.where((service) {
        String? gender = barberProvider.serviceDetailsMap[service.serviceId]?.data.targetGender;
        String ? category = barberProvider.serviceDetailsMap[service.serviceId]?.data.category;
        return (provider.selectedGendersFilter.isEmpty || provider.selectedGendersFilter.contains(gender)) &&
            (barberProvider.selectedServiceCategories2.isEmpty || barberProvider.selectedServiceCategories2.contains(category));
      }).toList();
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
          filteredServices.isEmpty
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
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              Service2? serviceDetail = filteredServices[index];
              bool isAdded = provider.barbergetSelectedServices().contains(serviceDetail);
              String? title = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.serviceTitle ?? '';
              String? description = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.description ?? '';
              int? totalPrice = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.basePrice ?? 0;
              int? discount = barberProvider.salonDetails?.data.data.discount ?? 0;
              String? gender = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.targetGender ?? '';
              int? cutPrice = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.cutPrice ?? 0;

              return Container(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: const Color(0xFF2B2F34),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SvgPicture.asset(
                          gender == 'male' ? ImagePathConstant.manIcon : ImagePathConstant.womanIcon,
                          height: 3.h,
                        ),
                      ],
                    ),
                    if (description.isNotEmpty) SizedBox(height: 1.h),
                    if (description.isNotEmpty) Text(
                      description,
                      style: TextStyle(
                        color: const Color(0xFF8B9AAC),
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Rs. $totalPrice",
                            style: TextStyle(
                              color: const Color(0xFF373737),
                              fontSize: 13.sp,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 2.w)),
                          TextSpan(
                            text: "Rs. $cutPrice",
                            style: TextStyle(
                              color: const Color(0xFF8B9AAC),
                              fontSize: 12.sp,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextButton(
                      onPressed: () async {
                        provider.toggleSelectedServicebarber(serviceDetail);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          side: BorderSide(color: const Color(0xFFAA2F4C), width: 0.2.w),
                        ),
                        backgroundColor: (!isAdded) ? null : Color(0xFFAA2F4C),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xFFAA2F4C),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                (!isAdded) ? Icons.add : Icons.remove,
                                size: 14.sp,
                                color: (!isAdded) ? const Color(0xFFAA2F4C) : Colors.white,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 2.w)),
                            TextSpan(
                              text: (!isAdded) ? "Add" : "Remove",
                              style: TextStyle(
                                color: (!isAdded) ? const Color(0xFFAA2F4C) : Colors.white,
                                backgroundColor: (!isAdded) ? Colors.white : const Color(0xFFAA2F4C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        // Get unique categories from provided services
        Set<String?> uniqueCategories = provider.artistDetails!.services
            .map((service) => provider.serviceDetailsMap[service.serviceId]?.data.category)
            .where((category) => category != null) // Remove null values
            .toSet();

        return Container(
          height: 4.2.h,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: uniqueCategories.length,
            itemBuilder: (context, index) {
              List<String?> categoriesList = uniqueCategories.toList();
              String? category = categoriesList[index];

              return GestureDetector(
                onTap: () {
                  // Filter services based on the selected category
                  List<Service2> filteredServices = provider.artistDetails!.services
                      .where((service) => provider.serviceDetailsMap[service.serviceId]?.data.category == category)
                      .toList();

                  // Update the list of filtered services in the provider
                  provider.setFilteredServices(filteredServices);

                  // Update selected service categories
                  provider.setSelectedServiceCategories(selectedServiceCategory: category ?? '');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  height: 4.2.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.h),
                    color: provider.selectedServiceCategories2.contains(category)
                        ? ColorsConstant.appColor
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      category ?? '',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: provider.selectedServiceCategories2.contains(category)
                            ? Colors.white
                            : ColorsConstant.textDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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

  static Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          if (isMen && isWomen) {
            provider.setSelectedGendersFilter(selectedGender: 'both');
          } else if (isMen) {
            provider.setSelectedGendersFilter(selectedGender: 'male');
          } else if (isWomen) {
            provider.setSelectedGendersFilter(selectedGender: 'unisex');
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: provider.selectedGendersFilter.isEmpty
                ? Colors.white
                : isMen
                ? provider.selectedGendersFilter.contains('male')
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white
                : provider.selectedGendersFilter.contains('unisex')
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white,
            borderRadius: BorderRadius.circular(1.5.w),
            border: Border.all(
              color: provider.selectedGendersFilter.isEmpty
                  ? ColorsConstant.divider
                  : isMen
                  ? provider.selectedGendersFilter.contains('male')
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider
                  : provider.selectedGendersFilter.contains('unisex')
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider,
            ),
            boxShadow: provider.selectedGendersFilter.isEmpty
                ? null
                : isMen
                ? provider.selectedGendersFilter.contains('male')
                ? [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.14),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null
                : provider.selectedGendersFilter.contains('unisex')
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
        final ref = Provider.of<ReviewsProvider>(context, listen: true);

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent(reviewForSalon: false),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (ref.reviews.isNotEmpty)
                    ? SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: ref.reviews.length,
                    itemBuilder: (context, index) {
                      final String storeName = provider.salonDetails?.data.data.name ?? '';
                      final String title = ref.reviews[index].userName ?? '';
                      String date = ref.reviews[index].createdAt ?? '';
                      final String discription = ref.reviews[index].description ?? '';
                      bool isExpanded = ref.reviews[index].isExpanded ?? false;
                      final int rating =  ref.reviews[index].rating ?? 0;
                      if (date != 'No Date') {
                        final DateTime dateTime = DateTime.parse(date);
                        final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                        print('Formatted Date: $formattedDate');
                        date = formattedDate;
                      } else {
                        print('Date is not available');
                      }

                      return Container(
                        padding: EdgeInsets.all(4.w),
                        margin: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstant.divider),
                            borderRadius: BorderRadius.circular(5.sp)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Store : $storeName",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "For : ${provider.artistDetails?.name ?? ''}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
                                     radius: 6.w),
                                SizedBox(width: 1.5.h),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF373737),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF8C9AAC),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 2.h),
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
                                          (int.parse(rating.toString()))
                                          ? ColorsConstant
                                          .appColor
                                          : ColorsConstant
                                          .greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              //height: 10.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discription,
                                    softWrap: true,
                                    overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                    maxLines: isExpanded ? null : 1,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  if (isExpanded)
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.reviews[index].isExpanded = false;
                                          });
                                        },
                                        child: Text(
                                          "View Less",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  if (!isExpanded)
                                    if (discription.length > 30)
                                      Material(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              ref.reviews[index].isExpanded = true;
                                            });
                                          },
                                          child: Text(
                                            "View More",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: ColorsConstant.appColor,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : const SizedBox(),
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
          HomeProvider home = context.read<HomeProvider>(); // Use the same instance
          context.read<ReviewsProvider>().fetchReviews(barberProvider.artistDetails!.id);
          print('reviews :- ${ context.read<ReviewsProvider>().reviews}');
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
            bottomNavigationBar:Visibility(

            visible: (servicesSelected),
             child: Container(
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
                      onTap: () async{
                        showSignInDialog(context);
                      },
                      isActive: true,
                      buttonText: StringConstant.confirmBooking,
                    )
                  ],
                ),
              ),
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
      HomeProvider homeProvider = context.read<HomeProvider>();
      Set<Service2> selectedServices = provider.barbergetSelectedServices();

      List<Service2> filteredServices = context.read<BarberProvider>().artistDetails!.services.where((service) {
        String? gender = barberProvider.serviceDetailsMap[service.serviceId]?.data.targetGender;
        String ? category = barberProvider.serviceDetailsMap[service.serviceId]?.data.category;
        return (provider.selectedGendersFilter.isEmpty || provider.selectedGendersFilter.contains(gender)) &&
            (barberProvider.selectedServiceCategories2.isEmpty || barberProvider.selectedServiceCategories2.contains(category));
      }).toList();
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
          filteredServices.isEmpty
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
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              Service2? serviceDetail = filteredServices[index];
              bool isAdded = provider.barbergetSelectedServices().contains(serviceDetail);
              String? title = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.serviceTitle ?? '';
              String? description = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.description ?? '';
              int? totalPrice = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.basePrice ?? 0;
              int? discount = barberProvider.salonDetails?.data.data.discount ?? 0;
              String? gender = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.targetGender ?? '';
              int? cutPrice = barberProvider.serviceDetailsMap[serviceDetail.serviceId]?.data.cutPrice ?? 0;

              return Container(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: const Color(0xFF2B2F34),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SvgPicture.asset(
                          gender == 'male' ? ImagePathConstant.manIcon : ImagePathConstant.womanIcon,
                          height: 3.h,
                        ),
                      ],
                    ),
                    if (description.isNotEmpty) SizedBox(height: 1.h),
                    if (description.isNotEmpty) Text(
                      description,
                      style: TextStyle(
                        color: const Color(0xFF8B9AAC),
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Rs. $totalPrice",
                            style: TextStyle(
                              color: const Color(0xFF373737),
                              fontSize: 13.sp,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 2.w)),
                          TextSpan(
                            text: "Rs. $cutPrice",
                            style: TextStyle(
                              color: const Color(0xFF8B9AAC),
                              fontSize: 12.sp,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextButton(
                      onPressed: () async {
                        provider.toggleSelectedServicebarber(serviceDetail);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          side: BorderSide(color: const Color(0xFFAA2F4C), width: 0.2.w),
                        ),
                        backgroundColor: (!isAdded) ? null : Color(0xFFAA2F4C),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xFFAA2F4C),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                (!isAdded) ? Icons.add : Icons.remove,
                                size: 14.sp,
                                color: (!isAdded) ? const Color(0xFFAA2F4C) : Colors.white,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 2.w)),
                            TextSpan(
                              text: (!isAdded) ? "Add" : "Remove",
                              style: TextStyle(
                                color: (!isAdded) ? const Color(0xFFAA2F4C) : Colors.white,
                                backgroundColor: (!isAdded) ? Colors.white : const Color(0xFFAA2F4C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        // Get unique categories from provided services
        Set<String?> uniqueCategories = provider.artistDetails!.services
            .map((service) => provider.serviceDetailsMap[service.serviceId]?.data.category)
            .where((category) => category != null) // Remove null values
            .toSet();

        return Container(
          height: 4.2.h,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: uniqueCategories.length,
            itemBuilder: (context, index) {
              List<String?> categoriesList = uniqueCategories.toList();
              String? category = categoriesList[index];

              return GestureDetector(
                onTap: () {
                  // Filter services based on the selected category
                  List<Service2> filteredServices = provider.artistDetails!.services
                      .where((service) => provider.serviceDetailsMap[service.serviceId]?.data.category == category)
                      .toList();

                  // Update the list of filtered services in the provider
                  provider.setFilteredServices(filteredServices);

                  // Update selected service categories
                  provider.setSelectedServiceCategories(selectedServiceCategory: category ?? '');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  height: 4.2.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.h),
                    color: provider.selectedServiceCategories2.contains(category)
                        ? ColorsConstant.appColor
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      category ?? '',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: provider.selectedServiceCategories2.contains(category)
                            ? Colors.white
                            : ColorsConstant.textDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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

  static Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          if (isMen && isWomen) {
            provider.setSelectedGendersFilter(selectedGender: 'both');
          } else if (isMen) {
            provider.setSelectedGendersFilter(selectedGender: 'male');
          } else if (isWomen) {
            provider.setSelectedGendersFilter(selectedGender: 'unisex');
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: provider.selectedGendersFilter.isEmpty
                ? Colors.white
                : isMen
                ? provider.selectedGendersFilter.contains('male')
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white
                : provider.selectedGendersFilter.contains('unisex')
                ? ColorsConstant.selectedGenderFilterBoxColor
                : Colors.white,
            borderRadius: BorderRadius.circular(1.5.w),
            border: Border.all(
              color: provider.selectedGendersFilter.isEmpty
                  ? ColorsConstant.divider
                  : isMen
                  ? provider.selectedGendersFilter.contains('male')
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider
                  : provider.selectedGendersFilter.contains('unisex')
                  ? ColorsConstant.appColor
                  : ColorsConstant.divider,
            ),
            boxShadow: provider.selectedGendersFilter.isEmpty
                ? null
                : isMen
                ? provider.selectedGendersFilter.contains('male')
                ? [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.14),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
                : null
                : provider.selectedGendersFilter.contains('unisex')
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
        final ref = Provider.of<ReviewsProvider>(context, listen: true);

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent2(reviewForSalon: false),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (ref.reviews.isNotEmpty)
                    ? SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: ref.reviews.length,
                    itemBuilder: (context, index) {
                      final String storeName = provider.salonDetails?.data.data.name ?? '';
                      final String title = ref.reviews[index].userName ?? '';
                      String date = ref.reviews[index].createdAt ?? '';
                      final String discription = ref.reviews[index].description ?? '';
                      bool isExpanded = ref.reviews[index].isExpanded ?? false;
                      final int rating =  ref.reviews[index].rating ?? 0;
                      if (date != 'No Date') {
                        final DateTime dateTime = DateTime.parse(date);
                        final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                        print('Formatted Date: $formattedDate');
                        date = formattedDate;
                      } else {
                        print('Date is not available');
                      }

                      return Container(
                        padding: EdgeInsets.all(4.w),
                        margin: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstant.divider),
                            borderRadius: BorderRadius.circular(5.sp)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Store : $storeName",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "For : ${provider.artistDetails?.name ?? ''}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/dummy_user.jpg'),
                                    radius: 6.w),
                                SizedBox(width: 1.5.h),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF373737),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF8C9AAC),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 2.h),
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
                                          (int.parse(rating.toString()))
                                          ? ColorsConstant
                                          .appColor
                                          : ColorsConstant
                                          .greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                              SizedBox(
                              //height: 10.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discription,
                                    softWrap: true,
                                    overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                    maxLines: isExpanded ? null : 1,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  if (isExpanded)
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.reviews[index].isExpanded = false;
                                          });
                                        },
                                        child: Text(
                                          "View Less",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  if (!isExpanded)
                                    if (discription.length > 30)
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.reviews[index].isExpanded = true;
                                          });
                                        },
                                        child: Text(
                                          "View More",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h,),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : const SizedBox(),
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