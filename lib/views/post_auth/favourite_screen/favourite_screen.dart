import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/single_artist_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/explore/artist_item_card.dart';
import 'package:naai/views/post_auth/explore/salon_item_card.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  int screenIndex =  0;

  @override
  Widget build(BuildContext context){
  
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Stack(
              children: [
                CommonWidget.appScreenCommonBackground(),
                CustomScrollView(
                //  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CommonWidget.transparentFlexibleSpace(),
                    titleContainer(),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            color: Colors.white,
                            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20.h),
                                 TabBar(
                                    labelColor: ColorsConstant.appColor,
                                    indicatorColor: ColorsConstant.appColor,
                                    unselectedLabelColor: ColorsConstant.divider,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    onTap: (index){
                                      setState(() {
                                          screenIndex = index;
                                      });
                                    },
                                    tabs: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1.h),
                                            child: const Tab(
                                              child: Text("SALONS"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1.h),
                                            child: const Tab(
                                              child: Text("ARTISTS"),
                                            ),
                                          ),
                                      ]
                                ),
                                SizedBox(height: 20.h),
                                (screenIndex == 0) ? FavSalonContainer() : FavArtistContainer()
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
                StringConstant.favourties,
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
  
}



Future<List<SalonResponseData>> getFavSalons(BuildContext context) async {
    final refUser = context.read<AuthenticationProvider>();
    final salonsIds = refUser.userData.favourite?.salons ?? [];
    List<SalonResponseData> ans = [];
    List<Future<SingleSalonResponseModel>> salonRequests = [];
    
    salonsIds.asMap().forEach((key, res) => salonRequests.add(SalonsServices.getSalonByID(salonId: res ?? "")));
    final salonResponses = await Future.wait(salonRequests);
 
    salonResponses.asMap().forEach((key, res) => ans.add(res.data?.data ?? SalonResponseData()));
    
    return ans;
}

class FavSalonContainer extends StatelessWidget {
  const FavSalonContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getFavSalons(context), 
      builder: (context,snapshot){
        if(snapshot.hasData && ConnectionState.done == snapshot.connectionState){
          final salons = snapshot.data ?? [];

          return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return SalonItemCard(salon: salons[index]);
              },
              itemCount: salons.length
            );
        }

        return SizedBox(
        height: 500.h,
          child: Center(
          child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
          ),
        );
      }
    );
  }
}

Future<List<TopArtistResponseModel>> getFavArtists(BuildContext context) async {
    final refUser = Provider.of<AuthenticationProvider>(context,listen: false);
    final artistsIds = refUser.userData.favourite?.artists ?? [];
    List<TopArtistResponseModel> ans = [];

    List<Future<SingleArtistModel>> artistRequests = [];
    List<Future<SingleSalonResponseModel>> salonRequests = [];

    artistsIds.asMap().forEach((key, e) => artistRequests.add(ArtistsServices.getSimpleArtistByID(artistId: e)));
    final artistResponses = await Future.wait(artistRequests);

    artistResponses.asMap().forEach((key, res) => salonRequests.add(SalonsServices.getSalonByID(salonId: res.data?.salonId ?? "")));
    final salonResponses = await Future.wait(salonRequests);
    
    salonResponses.asMap().forEach((i, res) {
      ans.add(TopArtistResponseModel(
          artistDetails:  artistResponses[i].data,
          salonDetails: res
      ));
    });

    return ans;
}

class FavArtistContainer extends StatelessWidget {
  const FavArtistContainer({super.key});

  @override
  Widget build(BuildContext context) {
   
    return FutureBuilder(
      future: getFavArtists(context), 
      builder: (context,snapshot){
        if(snapshot.hasData && ConnectionState.done == snapshot.connectionState){
          final artists = snapshot.data ?? [];

          return GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 10.w,
              childAspectRatio: 7.5 / 10.0,
              children: List.generate(artists.length, (index) {
                  return ArtistCard(artist: artists[index],index: index,isAlternate: false);
              }),
            );
        }

        return SizedBox(
        height: 500.h,
          child: Center(
          child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 4.w),
          ),
        );
      }
    );
  }
}