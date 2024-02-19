import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';
import 'package:naai/providers/post_auth/single_artist_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/salon_details/contact_and_interaction_widget.dart';
import 'package:provider/provider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistId;
  const ArtistDetailScreen({Key? key,required this.artistId}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<ArtistDetailScreen> {
  int selectedTab = 0;
  num myShowPrice = 0;
  late SingleArtistScreenModel artistDetails;

  @override
  void initState() {
    super.initState();
    ArtistsServices.getArtistByID(artistId: widget.artistId).then((value) {
       context.read<SingleArtistProvider>().setArtistDetails(value);
    });
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
                bottomNavigationBar: Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                       (1 == 1) ?
                         Container(
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
                                    Text('Rs. 599',
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
                                    Text('Rs. ${449}',
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
                                      
                                  },
                                  isActive: true,
                                  buttonText: StringConstant.confirmBooking,
                                )
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              )
            ),
    );
  }

  Widget servicesTab() {
   final services = artistDetails.services ?? [];

    return Column(
        children: <Widget>[
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
                children: <Widget>[
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
            height: 10.h,
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
              
              bool isAdded = false;
              String? title = services[index].serviceTitle ?? "No Title";
              String? discription = services[index].description ?? "Example Discription";
              int? totalPrice =  services[index].basePrice ?? 99999;
              int? discountPrice = services[index].cutPrice ?? 999999;
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
                          Text(
                          title,
                          style: TextStyle(
                            color: const Color(0xFF2B2F34),
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
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
                              fontSize: 18.sp,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w800,
                            )
                          ),
                        
                          WidgetSpan(child: SizedBox(width: 10.w,)),
                          TextSpan(
                          text: "Rs. $totalPrice",
                          style: TextStyle(
                              color: const Color(0xFF8B9AAC),
                                fontSize: 16.sp,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                            )
                          ),
                      ]
                    )),
                    SizedBox(height: 15.h,),
                    TextButton(
                      onPressed: () async {
                        //provider.toggleSelectedService(serviceDetail);
                      }, 
                      style: TextButton.styleFrom(
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
                              child: Icon((!isAdded) ? Icons.add : Icons.remove,
                              size: 20.sp,color: const Color(0xFFAA2F4C),)),
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

  Widget serviceCategoryFilterWidget() {
    return Container(
        height: 42.h,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
               
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              height: 42.h,
             padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: Colors.white
                // color: provider.selectedServiceCategories
                //     .contains(Services.values[index])
                //     ? ColorsConstant.appColor
                //     : Colors.white,
              ),
              child: Center(
                child: Text(
                  "name_here",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstant.textDark
                    // color: provider.selectedServiceCategories
                    //     .contains(Services.values[index])
                    //     ? Colors.white
                    //     : ColorsConstant.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
  
  Widget genderAndSearchFilterWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 60.h,
            child: Row(
              children: <Widget>[
                genderFilterTabs(isMen: true, isWomen: false),
                genderFilterTabs(isMen: false, isWomen: true),
              ],
            ),
          ),
          SizedBox(
            width: 150.w,
            height: 45.h,
            child: TextFormField(
             // controller: provider.searchController,
              cursorColor: ColorsConstant.appColor,
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsConstant.textDark,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (searchText) {

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
  
  Widget genderFilterTabs({required bool isMen,required bool isWomen}) {
    return GestureDetector(
        onTap: () {
             
        },
        child: Container(
          margin: EdgeInsets.only(right: 10.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            // color: provider.selectedGendersFilter.isEmpty
            //     ? Colors.white
            //     : isMen
            //     ? provider.selectedGendersFilter.contains(Gender.MEN)
            //     ? ColorsConstant.selectedGenderFilterBoxColor
            //     : Colors.white
            //     : provider.selectedGendersFilter.contains(Gender.WOMEN)
            //     ? ColorsConstant.selectedGenderFilterBoxColor
            //     : Colors.white,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              // color: provider.selectedGendersFilter.isEmpty
              //     ? ColorsConstant.divider
              //     : isMen
              //     ? provider.selectedGendersFilter.contains(Gender.MEN)
              //     ? ColorsConstant.appColor
              //     : ColorsConstant.divider
              //     : provider.selectedGendersFilter.contains(Gender.WOMEN)
              //     ? ColorsConstant.appColor
              //     : ColorsConstant.divider,
              color: ColorsConstant.divider
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
  
  Widget reviewColumn() {
    return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // AddReviewComponent(reviewForSalon: false),
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
               (1 == 1)
                    ? SizedBox(
                      child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                       final String storeName = 'No Title';
                       final String title = 'No Title';
                       final String date = 'No Date';
                       final String discription = 'No Discription';
                      
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
                                  Material(
                                    child: InkWell(
                                      onTap: (){},
                                      child: Text(
                                              "View More",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: ColorsConstant.appColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500
                                              ),
                                          ),
                                    ),
                                  )

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

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 5.h,
          backgroundImage: const AssetImage('assets/images/salon_dummy_image.png'),
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

}
