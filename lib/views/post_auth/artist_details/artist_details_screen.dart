import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';
import 'package:naai/providers/post_auth/artist_service_filter_provider.dart';
import 'package:naai/providers/post_auth/booking_screen_change_provider.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/post_auth/reviews_provider.dart';
import 'package:naai/providers/post_auth/single_artist_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/booking/booking_screen.dart';
import 'package:naai/views/post_auth/salon_details/contact_and_interaction_widget.dart';
import 'package:naai/views/post_auth/utility/add_review_component.dart';
import 'package:provider/provider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistId;
  const ArtistDetailScreen({Key? key,required this.artistId}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<ArtistDetailScreen> {
  int selectedTab = 0;
  //num myShowPrice = 0;
  late SingleArtistScreenModel artistDetails;

  @override
  void initState() {
    super.initState();
    ArtistsServices.getArtistByID(artistId: widget.artistId).then((value) {
       context.read<SingleArtistProvider>().setArtistDetails(value);
       context.read<BookingServicesSalonProvider>().setSalonDetails(value.salonDetails!);
       context.read<ArtistServicesFilterProvider>().setArtistDetails(value);
    });

    context.read<BookingServicesSalonProvider>().resetAll();
  }

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<SingleArtistProvider>(context,listen: true);
    artistDetails = ref.artistDetails;

    return SafeArea(
      child: Scaffold(
           //   resizeToAvoidBottomInset: true,
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
                                StringConstant.artist,
                                style: TextStyle(
                                    color: ColorsConstant.textDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp,
                                  ),
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
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.h, right: 14.w, left: 14.w),
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          20.h),
                                    ),
                                    child: barberOverview(),
                                  ),
                                  SizedBox(height: 20.h),
                                  const Divider(
                                    thickness: 2,
                                    height: 0,
                                    color: ColorsConstant.graphicFillDark,
                                  ),
                                  servicesAndReviewTabBar(),
                                  selectedTab == 0
                                      ? const ServiceFilterContainer()
                                      : ReviewContainer(artistDetails: artistDetails),
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
                child: Consumer<BookingServicesSalonProvider>(builder: (context, ref, child) {
                    double totalPrice = ref.totalPrice;
                    double discountPrice = ref.totalDiscountPrice;
      
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
                                (1 != 1) ? const SizedBox() : 
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
                                VariableWidthCta(
                                  onTap: () async {
                                     context.read<BookingScreenChangeProvider>().setScreenIndex(1);
                                     ref.addFinalSingleStaffServices(artistDetails.artistDetails?.data ?? ArtistDataModel(id: "0000"));
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

  Widget barberOverview() {
    final String artistName = artistDetails.artistDetails?.data?.name ?? "Artist Name";
    final String salonName = artistDetails.salonDetails?.data?.data?.name ?? "Salon Name";
    final double rating = artistDetails.artistDetails?.data?.rating ?? 5;

    return Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60.h),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(2, 2),
                        color: Colors.grey.shade300,
                        spreadRadius: 0.5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50.h,
                    // backgroundImage:
                    //     NetworkImage(barberProvider.artistDetails!.imageUrl)
                    //         as ImageProvider,
                  ),

                ),
              ),
              SizedBox(width: 15.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      artistName,
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 25.sp,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      StringConstant.worksAt,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.worksAtColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      salonName,
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                //width: 80.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      StringConstant.rating,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        5,
                        (i) => (i >
                                int.parse(rating.toStringAsFixed(0)) -
                                    1)
                            ? SvgPicture.asset(
                                ImagePathConstant.starIcon,
                                color: ColorsConstant.greyStar,
                                height: 22.h,
                              )
                            : SvgPicture.asset(
                                ImagePathConstant.starIcon,
                                color: ColorsConstant.yellowStar,
                                height: 22.h,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                //width: 38.w,
                child: GestureDetector(
                  onTap: () async {
                   
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.h),
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
                      children: [
                        Text(
                          StringConstant.viewSalon,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsConstant.appColor,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        SvgPicture.asset(
                          ImagePathConstant.rightArrowIcon,
                          color: ColorsConstant.appColor,
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          ContactAndInteractionWidget(
            iconOnePath: ImagePathConstant.phoneIcon,
            iconTwoPath: ImagePathConstant.shareIcon,
            iconThreePath: ImagePathConstant.saveIcon,
            iconFourPath: ImagePathConstant.instagramIcon,
            onTapIconOne: () {
            //   launchUrl(
            //   Uri(
            //     scheme: 'tel',
            //     path: StringConstant.generalContantNumber,
            //   ),
            // )
            },
            onTapIconTwo: () {
            //   launchUrl(
            //   Uri.parse(barberProvider.artistDetails!.links.instagram ??
            //       'https://www.instagram.com/naaiindia'),
            // )
            },
            onTapIconThree: () {
               
            },
            onTapIconFour: () {
            //   launchUrl(
            //   Uri.parse('https://www.instagram.com/naaiindia'),
            // )
            },
          ),
          SizedBox(height: 1.h),
        ],
      );
    
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
    final ref = Provider.of<ArtistServicesFilterProvider>(context,listen: true);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        refBooking.addService(services[index],isFromArtistScreen: true);
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
    final ref = context.read<ArtistServicesFilterProvider>();
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
    final ref = context.read<ArtistServicesFilterProvider>();

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
    final ref = context.read<ArtistServicesFilterProvider>();
    
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
                        ref.addService(service.copyWith(variables: [variable]),isFromArtistScreen: true);
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

class ReviewContainer extends StatelessWidget {
  final SingleArtistScreenModel artistDetails;
  const ReviewContainer({super.key,required this.artistDetails});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<ReviewsProvider>(context,listen: true);
    String salonId = artistDetails.salonDetails?.data?.data?.id ?? "";
   
    return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddReviewComponent(reviewForSalon: false,salonId: salonId),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                (ref.reviews.isNotEmpty)
                    ? SizedBox(
                      child: ListView.builder(
                      itemCount: ref.reviews.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                       final String storeName = artistDetails.salonDetails?.data?.data?.name ?? 'No Title';
                       final String title = ref.reviews[index].user?.data?.name ?? 'No Title';
                       final String date = ref.reviews[index].reviews?.review.createdAt ?? 'No Date';
                       final String discription = ref.reviews[index].reviews?.review.description ?? 'No Discription';
                      
                       return Container(
                          padding: EdgeInsets.all(12.w),
                          margin: EdgeInsets.only(bottom: 14.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstant.divider),
                          borderRadius: BorderRadius.circular(10.sp)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                   Text(
                                       "For : $storeName",
                                       style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500
                                       ),
                                   ),
                                   SizedBox(height: 10.h),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(backgroundColor: Colors.grey,radius: 25.r),
                                      SizedBox(width: 15.h),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              title,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: const Color(0xFF373737),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600
                                              ),
                                          ),
                                          Text(
                                              date,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: const Color(0xFF8C9AAC),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400
                                              ),
                                          ),
                                        ],
                                      )
                                    ],
                                   ),
                                   SizedBox(height: 20.h),
                                   SizedBox(
                                    //height: 10.h,
                                    child: Text(
                                              discription,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: const Color(0xFF8C9AAC),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400
                                              ),
                                          ),
                                   ),
                                  SizedBox(height: 2.h,),
                                  // Material(
                                  //   child: InkWell(
                                  //     onTap: (){},
                                  //     child: Text(
                                  //             "View More",
                                  //             style: TextStyle(
                                  //               fontFamily: "Poppins",
                                  //               color: ColorsConstant.appColor,
                                  //               fontSize: 14.sp,
                                  //               fontWeight: FontWeight.w500
                                  //             ),
                                  //         ),
                                  //   ),
                                  // )

                              ],
                          ),
                       );
                    }),)
                    : const SizedBox(),
              ],
            ),
          ),
        );

  }
}

