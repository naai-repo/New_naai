import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/providers/post_auth/filter_artist_provider.dart';
import 'package:naai/providers/post_auth/filter_salon_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/post_auth/top_artists_provider.dart';
import 'package:naai/providers/post_auth/top_salons_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/explore/artist_item_card.dart';
import 'package:naai/views/post_auth/explore/salon_item_card.dart';
import 'package:naai/views/post_auth/utility/artist_salon_extended.dart';
import 'package:provider/provider.dart';


Future<int> exploreFuture(BuildContext context) async {
    final ref = await context.read<LocationProvider>().getLatLng();
    final coords = [ref.longitude,ref.latitude];
    
    final refSalon = context.read<FilterSalonsProvider>();
    final refArtist = await context.read<FilterArtitsProvider>();
    refSalon.resetFilter(notify: false);
    refArtist.resetFilter(notify: false);

    // print("Exec Start ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
    // await Future.wait([
    //    (() async {
    //       // print("Exec ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
    //       final res = await SalonsServices.getTopSalons(coords: coords, page: refSalon.getPage, limit: refSalon.getLimit, type: "");
    //       if(context.mounted) context.read<TopSalonsProvider>().setTopSalons(res.data,clear: true);
    //    })(),
    //    (() async {
    //     //print("Exec T::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
    //       final ress = await ArtistsServices.getTopArtists(coords: coords, page: refArtist.getPage, limit: refArtist.getLimit, type: "");
    //       if(context.mounted) context.read<TopArtistsProvider>().setTopArtists(ress,clear: true);
    //    })()
    // ]);
    // print("Exec End ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");

    await Future.delayed(Durations.medium3);
    print("Exec Start ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
    (() async {
          //print("Exec ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
          final res = await SalonsServices.getTopSalons(coords: coords, page: refSalon.getPage, limit: refSalon.getLimit, type: "");
          if(context.mounted) context.read<TopSalonsProvider>().setTopSalons(res.data,clear: true);
     })();
    (() async {
      //print("Exec T::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
      final ress = await ArtistsServices.getTopArtists(coords: coords, page: refArtist.getPage, limit: refArtist.getLimit, type: "");
      if(context.mounted) context.read<TopArtistsProvider>().setTopArtists(ress,clear: true);
    })();
    print("Exec End ::: ${DateTime.now().second} - ${DateTime.now().millisecond}");
   
    return 200;
}


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>{
  late TopArtistsProvider ref;
  late TopSalonsProvider refSalons;
  late List<TopArtistResponseModel> artists;
  late List<SalonResponseData> salons;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final refFilterSalon = Provider.of<FilterSalonsProvider>(context,listen: true);
    bool isFilterSelected = (refFilterSalon.isFilterSelected() > 0);
    
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Stack(
              children: [
                CommonWidget.appScreenCommonBackground(),
                CustomScrollView(
                  //physics: const BouncingScrollPhysics(),
                  slivers: [
                    CommonWidget.transparentFlexibleSpace(),
                      titleContainer(),
                      searchBar(),
                  
                      FutureBuilder(future: exploreFuture(context), builder: (context,snapshot){
                         if(snapshot.hasData){
                            return SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Container(
                                    color: Colors.white,
                                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                                    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment.baseline,
                                                    baseline:
                                                        TextBaseline.ideographic,
                                                    child: SvgPicture.asset(
                                                      ImagePathConstant.scissorIcon,
                                                      color: ColorsConstant.appColor,
                                                      width: 30.w,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: SizedBox(width: 10.w),
                                                  ),
                                                  TextSpan(
                                                    text: StringConstant.artistNearMe,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp,
                                                      color: ColorsConstant.textLight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RedButtonWithText(
                                              buttonText: "View More",
                                              textColor: ColorsConstant.appColor,
                                              fontSize: 14.sp,
                                              border: Border.all(color: ColorsConstant.appColor),
                                              fillColor: ColorsConstant.lightAppColor,
                                              borderRadius: 20.h,
                                              onTap: () {
                                                   Navigator.pushNamed(context, NamedRoutes.exploreStylistRoute);
                                              },
                                              //icon: Icon(Icons.more_vert_outlined,color: ColorsConstant.appColor,size: 15.w,),
                                              shouldShowBoxShadow: false,
                                             // isIconSuffix: true,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5.w,
                                                horizontal: 15.w,
                                              ),
                                            ),
                                          
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        const ArtistNearYou(),
                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment.baseline,
                                                    baseline:
                                                        TextBaseline.ideographic,
                                                    child: SvgPicture.asset(
                                                      ImagePathConstant.scissorIcon,
                                                      color: ColorsConstant.appColor,
                                                      width: 30.w,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: SizedBox(width: 5.w),
                                                  ),
                                                  TextSpan(
                                                    text: StringConstant.salon,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22.sp,
                                                      color: ColorsConstant.textLight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RedButtonWithText(
                                              buttonText: StringConstant.filter,
                                              textColor: (isFilterSelected) ? Colors.white : ColorsConstant.appColor,
                                              fontSize: 16.sp,
                                              border: Border.all(
                                                  color: ColorsConstant.appColor),
                                              icon: (isFilterSelected)
                                            ? Text(
                                                '(${refFilterSalon.isFilterSelected()})',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: (isFilterSelected) ? Colors.white : ColorsConstant.appColor,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                ImagePathConstant.filterIcon,
                                                height: 18.h,
                                              ),
                                              fillColor: (isFilterSelected) ? ColorsConstant.appColor : ColorsConstant.lightAppColor,
                                              borderRadius: 20.h,
                                              onTap: () => showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(10.r),
                                                  ),
                                                ),
                                                builder: (context) {
                                                  return Container(
                                                    width: double.maxFinite,
                                                    height: 500.h,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10.r),
                                                            topRight:
                                                                Radius.circular(10.r))),
                                                    child: const FilterBarberSheet(),
                                                  );
                                                },
                                              ),
                                              shouldShowBoxShadow: false,
                                              isIconSuffix: true,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5.w,
                                                horizontal: 20.w,
                                              ),
                                            ),
                                          
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        const SalonsContainer(),
                                        SizedBox(height: 40.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                         }

                         return SliverFillRemaining(
                           child: Container(
                                    color: Colors.white,
                                    height: 500.h,
                                    child: Center(
                                      child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
                                    ),
                            ),
                         );
                      }),
                  ],
                ),
              ],
            ),
      ),
    );
    
  }

 
  Widget titleContainer(){
   return SliverAppBar(
          elevation: 10,
          automaticallyImplyLeading: false,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.h),
              topRight: Radius.circular(30.h),
            ),
          ),
          backgroundColor: Colors.white,
          pinned: false,
          floating: false,
          centerTitle: false,
          surfaceTintColor: Colors.white,
          title: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SizedBox(
              child: Text(
                StringConstant.exploreSalons,
                style:TextStyle(
                    color: ColorsConstant.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 25.sp,
                  ),
              ),
            ),
          ),
        );
  }
  
  Widget searchBar() {
   return SliverAppBar(
      elevation: 10,
      automaticallyImplyLeading: false,
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      pinned: true,
      floating: true,
      centerTitle: true,
      surfaceTintColor: Colors.white,
      title: Consumer<LocationProvider>(builder: (context,ref,child){
              return Container(
               // margin: EdgeInsets.symmetric(vertical: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 0.h),
                child: TextFormField(
                  cursorColor: ColorsConstant.appColor,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (searchText) => {},
                  decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                        address: ref.address
                  ),
                ),
          );
          }
        ),
    );
  }
  
}

class FilterBarberSheet extends StatelessWidget {
  const FilterBarberSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<FilterSalonsProvider>(context, listen: true);
    final refTopSalons = Provider.of<TopSalonsProvider>(context, listen: false);

    List<Widget> screens = [
     // priceWidget(),
      ratingWidget(),
      discountWidget(),
      salonTypeWidget()
    ];
    
    bool isFilterSelected = ref.isFilterSelected() > 0; 
      
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),topRight: Radius.circular(10.r)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Container(
                      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Filters",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.black, fontSize: 16.sp),
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
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            //width: 150.w,
                            child: Material(
                              color: ColorsConstant.appColorAccent,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.r)),
                              child: ListView.builder(
                                  shrinkWrap: true,
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
                                              if (ref.getSelectdIndex != idx){
                                                ref.changeIndex(idx);
                                              }
                                            },
                                            title: Text(
                                              ref.getFilterTypes[idx],
                                              style: TextStyle(
                                                  color: itemTColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: weight),
                                            ),
                                          ),
                                          (idx < ref.getFilterTypes.length-1) ? Divider(
                                            thickness: 0.5.h,
                                            height: 0.1,
                                            color: ColorsConstant.divider,
                                          ) : const SizedBox()
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 2,
                              child: (ref.getSelectdIndex < screens.length)
                                  ? screens[ref.getSelectdIndex]
                                  : const SizedBox())
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
           (isFilterSelected) ? Container(
              width: double.maxFinite,
              //height: 15 * height,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(horizontal: BorderSide(color: ColorsConstant.divider,width: 1.w))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                     FilterButton(
                        onTap: () async {
                            
                            try {
                                Loading.showLoding(context);
                                final refLocation = await context.read<LocationProvider>().getLatLng();
                                final coords = [refLocation.longitude,refLocation.latitude];
                                if(!context.mounted) return;
                              
                                final response = await SalonsServices.getTopSalons(coords: coords, page: 1, limit: 10, type: "");
                                await refTopSalons.setTopSalons(response.data,clear: true);
                                ref.resetFilter();
                            } catch (e) {
                              if(context.mounted){
                                showErrorSnackBar(context, e.toString());
                              }
                            } finally {
                              if(context.mounted){
                                  Loading.closeLoading(context);
                              }
                            }
                        },
                        bgColor: ColorsConstant.appColorAccent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: ColorsConstant.appColor,width: 1.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w,vertical: 10.w),
                        child: Text(
                          "Clear Filters",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorsConstant.appColor
                          ),
                    )),
                     FilterButton(
                        onTap: () async {
                            Navigator.pop(context);
                        },
                        bgColor: ColorsConstant.appColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: ColorsConstant.appColor,width: 1.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w,vertical: 10.w),
                        child: Text(
                          "Show Results",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white
                          ),
                    )),
                ],
              ),
            ) :  const SizedBox()
          ],
        ),
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
          const SizedBox()
        ],
      ),
    );
  }

  Widget discountWidget() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Discounts",
          style: TextStyle(
            fontSize: 18.sp
          ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const DiscountsButtons()
        ],
      ),
    );
  }

  Widget salonTypeWidget() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Salon Type",
          style: TextStyle(
            fontSize: 18.sp
          ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const SalonTypeFilterContainer()
        ],
      ),
    );
  }
  Widget ratingWidget() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rating",
          style: TextStyle(
            fontSize: 18.sp
          ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const RatingButtions()
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
  
  Widget categoryWidget() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Category",
          style: TextStyle(
            fontSize: 18.sp
          ),
          ),
          SizedBox(
            height: 20.h,
          ),
          const CategoryFilterContainer()
        ],
      ),
    );
  }

}

class SalonTypeFilterContainer extends StatefulWidget {
  const SalonTypeFilterContainer({super.key});

  @override
  State<SalonTypeFilterContainer> createState() => _SalonTypeFilterContainerState();
}

class _SalonTypeFilterContainerState extends State<SalonTypeFilterContainer> {
  int selectedSalonTypeIndex = 0;
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    Color selectButtonColor = ColorsConstant.appColor,unselectButtonColor = ColorsConstant.appColorAccent,
    borderButtonColor = ColorsConstant.appColor;
    final ref = Provider.of<FilterSalonsProvider>(context, listen: true);
    final refTopSalons = Provider.of<TopSalonsProvider>(context, listen: false);

    categories = ref.filterSalonType;

    selectedSalonTypeIndex = ref.selectedSalonTypeIndex;
    print('SalanType Select Idx : $selectedSalonTypeIndex');
    
    return SizedBox(
      height: 260.h,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: double.maxFinite,
          runSpacing: 8.w,
          verticalDirection: VerticalDirection.down,
          children: List.generate(categories.length, (i) {
            return FilterButton(
              onTap: () async {
                try {
                  Loading.showLoding(context);
                     
                  if(i != selectedSalonTypeIndex){
                    final refLocation = await context.read<LocationProvider>().getLatLng();
                    final coords = [refLocation.longitude,refLocation.latitude];
                    if(!context.mounted) return;
                    //final genderType =  context.read<AuthenticationProvider>().userData.gender ?? "male";
                    final response = await SalonsServices.getTopSalons(coords: coords, page: 1, limit: 10, type: categories[i].toLowerCase());
                    await refTopSalons.setTopSalons(response.data,clear: true);
                    ref.setGenderFilter(i);
                  }
                } catch (e) {
                  if(context.mounted){
                    showErrorSnackBar(context, e.toString());
                  }
                } finally {
                  if(context.mounted){
                      Loading.closeLoading(context);
                  }
                }
              },
              bgColor: (selectedSalonTypeIndex != -1 && i == selectedSalonTypeIndex) ? selectButtonColor : unselectButtonColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderButtonColor,width: 1.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 8.w),
              child: Text(
                categories[i],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: (selectedSalonTypeIndex != -1 && i == selectedSalonTypeIndex) ? unselectButtonColor : selectButtonColor
                ),
              ));
            
          }),
        ),
      ),
    );
        
  }
}

class CategoryFilterContainer extends StatefulWidget {
  const CategoryFilterContainer({super.key});

  @override
  State<CategoryFilterContainer> createState() => _CategoryFilterContainerState();
}

class _CategoryFilterContainerState extends State<CategoryFilterContainer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
    final ref = Provider.of<FilterSalonsProvider>(context, listen: true);
    final refTopSalons = Provider.of<TopSalonsProvider>(context, listen: false);

    selectedDiscountIndex = ref.getSelectedDiscountIndex;
    print('Discount Select Idx : $selectedDiscountIndex');
    
    for (int i = 0; i < discounts.length; i++) {
      buttons.add(FilterButton(
          onTap: () async {
            try {
              Loading.showLoding(context);

              if(i != selectedDiscountIndex){
                final refLocation = await context.read<LocationProvider>().getLatLng();
                final coords = [refLocation.longitude,refLocation.latitude];
                if(!context.mounted) return;
                final genderType =  context.read<AuthenticationProvider>().userData.gender ?? "male";
                final response = await SalonsServices.getSalonsByDiscount(coords: coords, page: 1, limit: 10, type: genderType, min: int.parse(discounts[i]), max: 100);
                await refTopSalons.setTopSalons(response.data,clear: true);
                ref.setDiscountIndex(i);
              }
            } catch (e) {
              if(context.mounted){
                showErrorSnackBar(context, e.toString());
              }
            } finally {
               if(context.mounted){
                  Loading.closeLoading(context);
               }
            }
          },
          bgColor: (selectedDiscountIndex != -1 && i == selectedDiscountIndex) ? selectButtonColor : unselectButtonColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderButtonColor,width: 1.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 8.w),
          child: Text(
            "${discounts[i].toString()}% Off or more",
             style: TextStyle(
              fontSize: 12.sp,
              color: (selectedDiscountIndex != -1 && i == selectedDiscountIndex) ? unselectButtonColor : selectButtonColor
            ),
          )));
    }
    return Wrap(
      spacing: double.maxFinite,
      runSpacing: 8.w,
      children: buttons,
    );
  }

}

class RatingButtions extends StatelessWidget {
  const RatingButtions({super.key});
  
  @override
  Widget build(BuildContext context) {
    int selectedRatingIndex = -1;
    List<String> ratingsText = ["Low to High", "High to Low"];
    List<Widget> buttons = [];
    Color selectButtonColor = ColorsConstant.appColor,unselectButtonColor = ColorsConstant.appColorAccent,
    borderButtonColor = ColorsConstant.appColor;
    final ref = Provider.of<FilterSalonsProvider>(context, listen: true);
    final refTopSalons = Provider.of<TopSalonsProvider>(context, listen: false);

    selectedRatingIndex = ref.getSelectedRatingIndex;
    print('Rating Select Idx : $selectedRatingIndex');
    
    for (int i = 0; i < ratingsText.length; i++) {
      buttons.add(FilterButton(
          onTap: () async {
              try {
              Loading.showLoding(context);

              if(i != selectedRatingIndex){
                final refLocation = await context.read<LocationProvider>().getLatLng();
                final coords = [refLocation.longitude,refLocation.latitude];
                if(!context.mounted) return;
                final genderType =  context.read<AuthenticationProvider>().userData.gender ?? "male";
                final response = await SalonsServices.getSalonsByRating(coords: coords, page: 1, limit: 10, type: genderType, min: 0);
                
                if(i == 0) response.data.sort((a, b) => a.rating!.toInt() - b.rating!.toInt());
                if(i == 1) response.data.sort((a, b) => b.rating!.toInt() - a.rating!.toInt());
                await refTopSalons.setTopSalons(response.data,clear: true);
                ref.setRatingIndex(i);
              }
            } catch (e) {
              if(context.mounted){
                showErrorSnackBar(context, e.toString());
              }
            } finally {
               if(context.mounted){
                  Loading.closeLoading(context);
               }
            }
          },
          bgColor: (selectedRatingIndex != -1 && i == selectedRatingIndex) ? selectButtonColor : unselectButtonColor,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: borderButtonColor,width: 1.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 8.w),
          child: Text(
            ratingsText[i],
             style: TextStyle(
              fontSize: 12.sp,
              color: (selectedRatingIndex != -1 && i == selectedRatingIndex) ? unselectButtonColor : selectButtonColor
            ),
          )));
    }
    return Wrap(
      spacing: double.maxFinite,
      runSpacing: 8.w,
      children: buttons,
    );
  }
}

class SalonsContainer extends StatefulWidget {
  const SalonsContainer({super.key});

  @override
  State<SalonsContainer> createState() => _SalonsContainerState();
}

class _SalonsContainerState extends State<SalonsContainer> {
  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<TopSalonsProvider>(context,listen: true);
    List<SalonResponseData> salons = ref.getTopSalons();

    return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){
               if(index == salons.length){
                   return SalonExtendedLoading();
               }
               return SalonItemCard(salon: salons[index]);
            },
            itemCount: salons.length + 1
    );
  }
}


class ArtistNearYou extends StatelessWidget {
  const ArtistNearYou({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<TopArtistsProvider>(context,listen: true);
    List<TopArtistResponseModel> artists = ref.getTopArtists();

    return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250.h),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: artists.length  + 1,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if(index == artists.length){
                  return ArtistExtendedLoading();
                }
                return ArtistCard(artist: artists[index],index: index,isAlternate: true);
              },
            ),
      );
  }
}



