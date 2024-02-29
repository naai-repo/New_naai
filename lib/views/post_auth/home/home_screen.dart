import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/filter_artist_provider.dart';
import 'package:naai/providers/post_auth/filter_salon_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/post_auth/top_artists_provider.dart';
import 'package:naai/providers/post_auth/top_salons_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/common_widgets/stacked_image.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/artist_details/artist_details_screen.dart';
import 'package:naai/views/post_auth/booking/booking_history/booking_history_screen.dart';
import 'package:naai/views/post_auth/salon_details/salon_details_screen.dart';
import 'package:naai/views/post_auth/utility/artist_salon_extended.dart';
import 'package:provider/provider.dart';

Future<int> homeFuture(BuildContext context,String type) async {
    final ref = await context.read<LocationProvider>().getLatLng();
    final coords = [ref.longitude,ref.latitude];

    final refSalon = await context.read<FilterSalonsProvider>();
    final res = await SalonsServices.getTopSalons(coords: coords, page: refSalon.getPage, limit: refSalon.getLimit, type: type);
    if(context.mounted) context.read<TopSalonsProvider>().setTopSalons(res.data,clear: true);

    final refArtist = await context.read<FilterArtitsProvider>();
    final ress = await ArtistsServices.getTopArtists(coords: coords, page: refArtist.getPage, limit: refArtist.getLimit, type: type);
    if(context.mounted) context.read<TopArtistsProvider>().setTopArtists(ress,clear: true);
    print("Builded $type");

    return 200;
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();

  String type = "male";

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white
      ),
    );

    type = context.read<AuthenticationProvider>().userData.gender ?? "male";

    final reff = context.read<TopArtistsProvider>();
    final reffSalons = context.read<TopSalonsProvider>();
    final reffFilArt = context.read<FilterArtitsProvider>();
    final reffFillSalons = context.read<FilterSalonsProvider>();

    reff.limit = 11;
    reff.page = 1;
    reffSalons.limit = 11;
    reffSalons.page = 1;

    reffFilArt.limit = 11;
    reffFilArt.page = 1;
    reffFillSalons.limit = 11;
    reffFillSalons.page = 1;
    
  }

  @override
  void dispose() {
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LocationProvider>(context,listen: true);
    print("Builde");
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );

    
    return DefaultTabController(
      length: 2,
      initialIndex: (type == "male") ? 0 : 1,
      child: Scaffold(
          body: Stack(
            children: [
              CommonWidget.appScreenCommonBackground(),
              CustomScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CommonWidget.transparentFlexibleSpace(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.h),
                              topRight: Radius.circular(30.h),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  children: [
                                    logoAndNotifications(),
                                    searchLocationBar(),
                                    TabBar(
                                        labelColor: ColorsConstant.appColor,
                                        indicatorColor: ColorsConstant.appColor,
                                        unselectedLabelColor: ColorsConstant.divider,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        onTap: (index){
                                          setState(() {
                                              type = (index == 0) ? "male" : "female";
                                          });
                                        },
                                        tabs: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                                child: const Tab(
                                                  child: Text("MEN"),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                                child: const Tab(
                                                  child: Text("WOMEN"),
                                                ),
                                              ),
                                          ]
                                    ),
                                    
                                    FutureBuilder(
                                      future: homeFuture(context, type), 
                                      builder: (context,snapshot){
                                       // print("kdkf ${snapshot.connectionState}");
                                         if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                                             return Column(
                                                  children: [
                                                      SizedBox(height:20.h),
                                                      const OfferContainer(),
                                                      SizedBox(height:20.h),
                                                      const BookingHistoryContainer(),
                                                      SizedBox(height:10.h),
                                                      serviceCategories(),
                                                      SizedBox(height:10.h),
                                                      const SalonNearMe(),
                                                      SizedBox(height:20.h),
                                                      const TopStylistFilterContainer(),
                                                     // SizedBox(height:5.h),
                                                      const Stylist(),
                                                       SizedBox(height:50.h)
                                                  ],
                                              );
                                         }
                                         
                                         return SizedBox(
                                          height: 500.h,
                                           child: Center(
                                            child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
                                           ),
                                         );
                                      }
                                    )
                                  ],
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
            ]
            ,
          ),
        ),
    );
  }
  
  Widget logoAndNotifications() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(
          ImagePathConstant.inAppLogo,
          height: 50.h,
        ),
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      onTap: (){
          Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute);
      },
      child: Container(
        margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
        padding: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(15.h),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
              ),
              Consumer<LocationProvider>(builder: (context,ref,child){
                    return Container(
                    margin: EdgeInsets.only(left: 10.w),
                    height: 40.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ref.address,
                      style: TextStyle(
                        color: ColorsConstant.textLight,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  );
              }),
            ],
          ),
      ),
    );
  }

  Widget dummyDeal2() {
    return Row(
      children:[
       Expanded(
         child: GestureDetector(
           onTap: ()async {
         
           },
           child: Container(
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.h),
              color: const Color(0xFF13ABA1),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 20.w,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/dummy_deal_men.png',
                        fit: BoxFit.fill,
                        height: 200.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flat',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height:30.h),
                      Text(
                        'MEN HAIRCUT',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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
       SizedBox(width: 5.w,),
      Expanded(
        child: GestureDetector(
            onTap: () async{
              
            },
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.h),
                color: const Color(0xFF13ABA1),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10.w,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/dummy_deal_men.png',
                          fit: BoxFit.cover,
                          height: 200.h,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Flat',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '10%',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height:30.h),
                        Text(
                          'MEN HAIRCUT',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
    ],
    );
  }
  
  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithLine(
            lineHeight: 25.h,
            lineWidth: 5.w,
            fontSize: 20.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 150.h),
            margin: EdgeInsets.symmetric(vertical: 20.h),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                StackedImageText(
                  onTap: () async {
                    await onClickCategory("hair");
                  },
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () async {
                     await onClickCategory("makeup");
                  },
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () async{
                     await onClickCategory("spa");
                  },
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
  
  Future<void> onClickCategory(String category) async {
    try {
      Loading.showLoding(context);
      final refLocation = await context.read<LocationProvider>().getLatLng();
      final coords = [refLocation.longitude,refLocation.latitude];

      final res = await SalonsServices.getSalonsByCategory(coords: coords, page: 1, limit: 10, type: type, category: category);
      if(res.isEmpty && context.mounted){
         showErrorSnackBar(context, "Something went wrong");
         return;
      }

      if(context.mounted){
          context.read<TopSalonsProvider>().setTopSalons(res);
          Future.delayed(Durations.short1,(){
              context.read<BottomChangeScreenIndexProvider>().setScreenIndex(1);
          });
      }
      
    } catch (e) {
      if(context.mounted){
         print("Error : ${e.toString()}");
      }
    }finally{
      if(context.mounted){
            Loading.closeLoading(context);
      }
    }
  }

}

class SalonNearMe extends StatelessWidget {
  const SalonNearMe({super.key});

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<TopSalonsProvider>(context,listen: true);
    List<SalonResponseData> salons = ref.getTopSalons();
    
    return Padding(
        padding: EdgeInsets.only(
          top: 10.h,
          right: 5.w,
          left: 10.w,
        ),
        child: Column(
          children: [
            TitleWithLine(
              lineHeight: 25.h,
              lineWidth: 5.w,
              fontSize: 20.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 170.h,
              padding: EdgeInsets.only(top: 20.h),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: salons.length + 1,
                itemBuilder: (context, index) {
                  if (index == salons.length) {
                    return SalonExtendedLoading();
                  } 

                  String salonImage = (salons[index].images?.isNotEmpty ?? false) ? salons[index].images!.first.url! : "";
    
                  if(salonImage.isEmpty) salonImage = "https://images.pexels.com/photos/1813272/pexels-photo-1813272.jpeg?auto=compress&cs=tinysrgb&w=600";
                  

                    return GestureDetector(
                      onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SalonDetailsScreen(salonDetails: salons[index])));
                      },
                      child: Container(
                        width: 320.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.h),
                          color: const Color(0xFF0F0F0F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 10.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          salons[index].name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          salons[index].salonType == 'Unisex'
                                              ? '${salons[index].salonType} Salon'
                                              : '${salons[index].salonType}\'s Salon',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
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
                                      children: [
                                        ColorfulInformationCard(
                                          imagePath:
                                          ImagePathConstant.locationIconAlt,
                                          text: "${salons[index].distance?.toStringAsFixed(2) ?? "0"} km",
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                        SizedBox(width: 3.w),
                                        ColorfulInformationCard(
                                          imagePath: ImagePathConstant.starIcon,
                                          text: salons[index].rating?.toStringAsFixed(1) ?? "0",
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
                                  height: 170.h,
                                  width: 120.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10.h),
                                    ),
                                  child: salons[index].images!.isNotEmpty
                                    ? Image.network(
                                            salons[index].images!.first.url!,
                                            fit: BoxFit.cover,
                                      )
                                    : const Placeholder(),
                                  ),
                                ),
                                salons[index].discount == 0 || salons[index].discount == null
                                    ? const SizedBox()
                                    : Container(
                                  constraints: BoxConstraints(minWidth: 13.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3.h,
                                    horizontal: 10.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorsConstant.appColor,
                                    borderRadius: BorderRadius.circular(5.h),
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
                                        '${salons[index].discount}% off',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
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
      
                },
              ),
            )
          ],
        ),
      );
  }
}

class TitleWithLine extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;
  final double fontSize;
  final String text;
  final Color? textColor;
  final Color? lineColor;

  const TitleWithLine({
    required this.lineHeight,
    required this.lineWidth,
    required this.fontSize,
    required this.text,
    this.textColor,
    this.lineColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 5.w),
          height: lineHeight,
          width: lineWidth,
          decoration: BoxDecoration(
            color: lineColor ?? ColorsConstant.appColor,
            borderRadius: BorderRadius.circular(1.h),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? ColorsConstant.textDark,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class Stylist extends StatelessWidget {
  const Stylist({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<TopArtistsProvider>(context,listen: true);
    List<TopArtistResponseModel> artists = ref.getTopArtists();


    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // TitleWithLine(
            //   lineHeight: 25.h,
            //   lineWidth: 5.w,
            //   fontSize: 20.sp,
            //   text: StringConstant.ourStylist.toUpperCase(),
            // ),

            SizedBox(
              //height: 500.h,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: (1 /1.2),
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(parent: ScrollPhysics()),
                primary: true,
                padding: EdgeInsets.only(top: 20.w),
                children: List.generate(artists.length + 1, (index){

                     if(artists.length == index){
                        return ArtistExtendedLoading();
                     }


                     String imgUrl = artists[index].artistDetails?.imageUrl ?? "";
                     String artistName = artists[index].artistDetails?.name ?? "";
                     String salonName = artists[index].salonDetails?.data?.data?.name ?? "";
                     double rating = artists[index].artistDetails?.rating ?? 5;
                     

                     return ClipRRect(
                      borderRadius: BorderRadius.circular(22.r),
                       child: SizedBox(
                         //height: 380.h,
                         width: double.maxFinite,
                         child: Stack(
                           children: [
                             SizedBox(
                               child: (imgUrl.isNotEmpty) ? Image.network(imgUrl,fit: BoxFit.cover,height: double.maxFinite,) : const SizedBox(),
                             ),
                             Material(
                              color: Colors.transparent,
                               child: InkWell(
                                onTap: () async {
                                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArtistDetailScreen(artistId: artists[index].artistDetails?.id ?? "")));
                                },
                                 child: Container(
                                   width: double.maxFinite,
                                   padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.w),
                                   decoration: const BoxDecoration(
                                     gradient: LinearGradient(
                                       colors: [Color.fromARGB(190, 0, 0, 0),Color.fromARGB(64, 0, 0, 0)],
                                       begin: Alignment.bottomCenter,
                                       end: Alignment.topCenter,
                                       stops: [0.1,0.5]
                                     ),
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(artistName,
                                        style: TextStyle(
                                           fontSize: 16.sp,
                                           color: Colors.white,
                                           fontWeight: FontWeight.w500 
                                        ),
                                       ),
                                       SizedBox(height: 1.h,),
                                       Text(salonName,
                                        style: TextStyle(
                                           fontSize: 14.sp,
                                           color: const Color(0xFF8C9AAC),
                                           fontWeight: FontWeight.w500 
                                        ),
                                       ),
                                       SizedBox(height: 1.h),
                                       SizedBox(
                                        height: 20.h,
                                        width: 100.w,
                                        child: GridView.count(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 3.w,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(bottom: 50.w,top: 0,left: 0,right: 0),
                                          children: List.generate(5, (index) {
                                              if(index >= rating){
                                                return Icon(Icons.star_border,size: 20.w,color: Colors.white);
                                              }
                                              return Icon(Icons.star,size: 20.w,color: Colors.white,);
                                          }),
                                        ),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     );
                }),
              ),
            )
        ],
      ),
    );
  }
}

class OfferContainer extends StatefulWidget {
  const OfferContainer({super.key});

  @override
  State<OfferContainer> createState() => _OfferContainerState();
}

class _OfferContainerState extends State<OfferContainer> {
  int offerIndex = 0;
  List<String> offers = [
                          "https://i.ibb.co/zJ0tPR1/image1.png",
                          "https://i.ibb.co/0p7qjfT/image3.png",
                          "https://i.ibb.co/D9Ymjpg/image2.png",
                          "https://i.ibb.co/0p7qjfT/image3.png",
                        ];
  int offerLength = 0;

  @override
  void initState() {
    super.initState();
    offerLength = offers.length;
  }
  
  @override
  Widget build(BuildContext context) {
  
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            CarouselSlider(
              items: List.generate(offerLength, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Material(
                        child: Ink.image(
                          image:  NetworkImage(offers[index]),
                          fit: BoxFit.fill,
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: InkWell(
                            onTap: (){},
                          ),
                        ),
                      ),
                    ),
                  );
              }), 
              options: CarouselOptions(
                aspectRatio: 2.5,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                onPageChanged: (index, reason) {
                    setState(() {
                       offerIndex = index;
                    });
                },
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                disableCenter: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              )),
             
            SizedBox(height: 15.h),
            SizedBox(
              width: 80.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(offerLength, (index) {
                    return CircleAvatar(
                      backgroundColor: (index == offerIndex) ? Colors.black : const Color(0xFFF2F4F7),
                      radius: 6.r,
                    );
                }),
              ),
            ),
        ],
      );
  }
}

class TopStylistFilterContainer extends StatelessWidget {
  const TopStylistFilterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<FilterArtitsProvider>(context,listen: true);
    final refTopArtists = Provider.of<TopArtistsProvider>(context,listen: true);

    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            TitleWithLine(
              lineHeight: 25.h,
              lineWidth: 5.w,
              fontSize: 20.sp,
              text: ("Top Stylist").toUpperCase(),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 50.h,
             // width: 200.w,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(parent: ScrollPhysics()),
                itemCount: ref.filterCategories.length,
                itemBuilder: (contex,index){
          
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: TextButton(
                      onPressed: () async {
                          try {
                            Loading.showLoding(context);
                            final refLocation = await context.read<LocationProvider>().getLatLng();
                            final coords = [refLocation.longitude,refLocation.latitude];

                            final res = await ArtistsServices.getArtistsByCategory(coords: coords, page: 1, limit: 10, type: "male", category: ref.filterCategories[index]);
                            refTopArtists.setTopArtists(res,clear: true);
                            ref.setCategoryIndex(index);
                          } catch (e) {
                              if(contex.mounted){
                                showErrorSnackBar(context, e.toString());
                              }
                          }finally{
                            if(contex.mounted) Loading.closeLoading(context);
                          }
                      }, 
                      style: TextButton.styleFrom(
                         backgroundColor: (ref.getselectedCategoryIndex == index) ? const Color(0xFF101828) : const Color(0xFFF2F4F7),
                         padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 8.h),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r))
                      ),
                      child: Text(ref.filterCategories[index],
                           style: TextStyle(
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w600,
                             fontSize: 12.sp,
                             color: (ref.getselectedCategoryIndex == index) ? Colors.white  : const Color(0xFF373737)
                           ),
                        )
                    ),
                  );
                }
              ),
            )
        
        ],
      ),
    );
  }
}




