import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ArtistExtendedLoading extends StatefulWidget {
  const ArtistExtendedLoading({super.key});

  @override
  State<ArtistExtendedLoading> createState() => _ArtistExtendedLoadingState();
}

class _ArtistExtendedLoadingState extends State<ArtistExtendedLoading> {
  bool isDataFetching = false;
  bool terminate = false;

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<TopArtistsProvider>(context,listen: false);

    return VisibilityDetector(
              key: Key("stylist"), 
              child: (terminate) ? SizedBox() : SizedBox(
                child: Center(
                  child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 5.w),
                ),
              ), 
              onVisibilityChanged: (visible) async {
                  if(isDataFetching || terminate) return;

                  if(visible.visibleFraction == 0){
                    print("Element is No Visible");
                    return;
                  }
 
                  setState(() {
                     isDataFetching = true;
                  });
                 
                  try {
                    final refLocation = await context.read<LocationProvider>().getLatLng();
                    final coords = [refLocation.longitude,refLocation.latitude];
                    final refArtits = await context.read<FilterArtitsProvider>(); 
                    //final refAuth = await context.read<AuthenticationProvider>();
                    
                    String gender = ""; 
                    List<TopArtistResponseModel> res = [];

                    if(refArtits.getselectedCategoryIndex != -1){
                          refArtits.page = refArtits.getPage + 1;
                          res = await ArtistsServices.getArtistsByCategory(coords: coords, page: refArtits.getPage, limit: refArtits.getLimit, type: gender.toLowerCase(), category: refArtits.filterCategories[refArtits.getselectedCategoryIndex]);
                    }else{
                          ref.page = ref.getPage + 1;
                          res = await ArtistsServices.getTopArtists(coords: coords, page: ref.getPage, limit: ref.getLimit, type: gender.toLowerCase());
                    }
                    
                    setState(() {
                      isDataFetching = false;
                      terminate = (res.length == 0);
                    });
                    ref.setTopArtists(res,clear: false);
                    
                  } catch (e) {
                      if(context.mounted){
                        showErrorSnackBar(context, e.toString());
                      }
                  }
              }
            );
  }

}


class SalonExtendedLoading extends StatefulWidget {
  const SalonExtendedLoading({super.key});

  @override
  State<SalonExtendedLoading> createState() => _SalonExtendedLoadingState();
}

class _SalonExtendedLoadingState extends State<SalonExtendedLoading> {
  bool isDataFetching = false;
  bool terminate = false;

  Widget build(BuildContext context) {
    final ref = Provider.of<TopSalonsProvider>(context,listen: false);

    return VisibilityDetector(
              key: Key("salons home"), 
              child: (terminate) ? SizedBox() : Container(
                padding: EdgeInsets.all(10.w),
                child: Center(
                  child: CircularProgressIndicator(color: ColorsConstant.appColor,strokeWidth: 5.w),
                ),
              ), 
              onVisibilityChanged: (visible) async {
                  if(isDataFetching || terminate) return;

                  if(visible.visibleFraction == 0){
                    print("Element is No Visible");
                    return;
                  }
 
                  setState(() {
                     isDataFetching = true;
                  });
                 
                  try {
                    final refLocation = await context.read<LocationProvider>().getLatLng();
                    final coords = [refLocation.longitude,refLocation.latitude];
                    final refArtits = await context.read<FilterSalonsProvider>(); 
                    //final refAuth = await context.read<AuthenticationProvider>();
                    
                    String gender = (refArtits.selectedSalonTypeIndex == -1 || refArtits.selectedSalonTypeIndex == 2) ? "" : refArtits.filterSalonType[refArtits.selectedSalonTypeIndex]; 
                    List<SalonResponseData> res = [];

                    if(refArtits.getselectedCategoryIndex != -1){
                         refArtits.page = refArtits.getPage + 1;
                         res = await SalonsServices.getSalonsByCategory(coords: coords, page: refArtits.getPage, limit: refArtits.getLimit, type: gender.toLowerCase(), category: refArtits.filterCategories[refArtits.getselectedCategoryIndex]);
                    }else{
                          ref.page = ref.getPage + 1;
                          final ress = await SalonsServices.getTopSalons(coords: coords, page: ref.getPage, limit: ref.getLimit, type: gender.toLowerCase());
                          res = ress.data;
                    }
                    
                    setState(() {
                      isDataFetching = false;
                      terminate = (res.length == 0);
                    });
                    ref.setTopSalons(res,clear: false);
                    
                  } catch (e) {
                      if(context.mounted){
                        showErrorSnackBar(context, e.toString());
                      }
                  }
              }
            );
  }

}
