import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/providers/post_auth/filter_artist_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/post_auth/top_artists_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/explore/artist_item_card.dart';
import 'package:provider/provider.dart';

class ExploreStylist extends StatefulWidget {
  const ExploreStylist({Key? key}) : super(key: key);

  @override
  State<ExploreStylist> createState() => _ExploreStylistState();
}

class _ExploreStylistState extends State<ExploreStylist>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    final ref = Provider.of<TopArtistsProvider>(context,listen: true);
    final refFilter = Provider.of<FilterArtitsProvider>(context,listen: false);
    List<TopArtistResponseModel> artists = ref.getTopArtists();
    bool isFilterSelected = (refFilter.isFilterSelected() > 0);

    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              CommonWidget.appScreenCommonBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CommonWidget.transparentFlexibleSpace(),
                  titleContainer(),
                  searchBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                          alignment: PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.ideographic,
                                          child: SvgPicture.asset(ImagePathConstant.scissorIcon,
                                            color: ColorsConstant.appColor,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(width: 10.w),
                                        ),
                                        TextSpan(
                                          text: StringConstant.stylists,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 //Filter Widget Here
                                  RedButtonWithText(
                                        buttonText: StringConstant.filter,
                                        textColor: (isFilterSelected) ? Colors.white : ColorsConstant.appColor,
                                        fontSize: 16.sp,
                                        border: Border.all(color: ColorsConstant.appColor),
                                        icon: (isFilterSelected)
                                            ? Text(
                                                '(${refFilter.isFilterSelected()})',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:(isFilterSelected) ? Colors.white : ColorsConstant.appColor,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                ImagePathConstant.filterIcon),
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
                                                      topRight:Radius.circular(10.r)
                                                  )),
                                               child: const FilterArtistSheet(),
                                              //child: const SizedBox(),
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
                              GridView.count(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                physics: const BouncingScrollPhysics(),
                                mainAxisSpacing: 10.w,
                                childAspectRatio: 7.5 / 10.0,
                                children: List.generate(artists.length, (index) {
                                   return ArtistCard(artist: artists[index], index: index,isAlternate: false);
                                }),
                              ),
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


class FilterArtistSheet extends StatelessWidget {
  const FilterArtistSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<FilterArtitsProvider>(context, listen: true);
    final refTopArtist = Provider.of<TopArtistsProvider>(context, listen: false);

    List<Widget> screens = [
      priceWidget(),
      categoryWidget(),
      ratingWidget(),
      discountWidget(),
      distanceWidget()
    ];
    
    bool isFilterSelected = (ref.isFilterSelected() > 0);
      
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
                                final genderType =  context.read<AuthenticationProvider>().userData.gender ?? "male";
                                final response = await ArtistsServices.getTopArtists(coords: coords, page: 1, limit: 10, type: genderType);
                                await refTopArtist.setTopArtists(response,clear: true);
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
          const SizedBox()
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


class CategoryFilterContainer extends StatefulWidget {
  const CategoryFilterContainer({super.key});

  @override
  State<CategoryFilterContainer> createState() => _CategoryFilterContainerState();
}

class _CategoryFilterContainerState extends State<CategoryFilterContainer> {
  int selectedCategoryIndex = 0;
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    Color selectButtonColor = ColorsConstant.appColor,unselectButtonColor = ColorsConstant.appColorAccent,
    borderButtonColor = ColorsConstant.appColor;
    final ref = Provider.of<FilterArtitsProvider>(context, listen: true);
    final refTopArtists = Provider.of<TopArtistsProvider>(context, listen: false);

    categories = ref.filterCategories;

    selectedCategoryIndex = ref.getselectedCategoryIndex;
    print('Category Select Idx : $selectedCategoryIndex');
    
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
                      
                  if(i != selectedCategoryIndex){
                    final refLocation = await context.read<LocationProvider>().getLatLng();
                    final coords = [refLocation.longitude,refLocation.latitude];
                    if(!context.mounted) return;
                    final genderType =  context.read<AuthenticationProvider>().userData.gender ?? "male";
                    final response = await ArtistsServices.getArtistsByCategory(coords: coords, page: 1, limit: 10, type: genderType,category: categories[i]);
                    await refTopArtists.setTopArtists(response,clear: true);
                    ref.setCategoryIndex(i);
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
              bgColor: (selectedCategoryIndex != -1 && i == selectedCategoryIndex) ? selectButtonColor : unselectButtonColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderButtonColor,width: 1.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 8.w),
              child: Text(
                categories[i],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: (selectedCategoryIndex != -1 && i == selectedCategoryIndex) ? unselectButtonColor : selectButtonColor
                ),
              ));
            
          }),
        ),
      ),
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
    final ref = Provider.of<FilterArtitsProvider>(context, listen: true);
    final refTopArtist = Provider.of<TopArtistsProvider>(context, listen: false);

    selectedRatingIndex = ref.getSelectedRatingIndex;
    print('Rating Select Idx : $selectedRatingIndex');
    
    for (int i = 0; i < ratingsText.length; i++) {
      buttons.add(FilterButton(
          onTap: () async {
              try {
              Loading.showLoding(context);

              if(i != selectedRatingIndex){
                final response = await ArtistsServices.getArtistsByRating(coords: [77.077451, 28.676784], page: 1, limit: 10, type: "male", min: 0);
                if(i == 0) response.sort((a, b) => a.artistDetails!.rating!.toInt() - b.artistDetails!.rating!.toInt());
                if(i == 1) response.sort((a, b) => b.artistDetails!.rating!.toInt() - a.artistDetails!.rating!.toInt());
                await refTopArtist.setTopArtists(response,clear: true);
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


