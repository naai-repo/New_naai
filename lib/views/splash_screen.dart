import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/uni_deeplink_services/uni_deep_link_services.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/artist_details/artist_details_screen.dart';
import 'package:naai/views/post_auth/salon_details/salon_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
    UtilityFunctions.changeSystemBarReset();
  }

  @override
  void initState() {
    super.initState();
    checkIfUserExists();
    UtilityFunctions.changeSystemBarToRed();
  }

  Future<void> deepLinkRedirect(Uri? uri) async {
    if(uri != null && uri.pathSegments.isNotEmpty){
          List<String> paths = uri.pathSegments;
          print("DeepLink Urii :: ${uri}");

          if(paths.length == 2){
            if(paths[0] == "salon"){
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SalonDetailsScreen(salonDetails: SalonResponseData(id : paths[1]),isFromDeepLink: true)));
            }else if(paths[0] == "artist"){
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArtistDetailScreen(artistId: paths[1],isFromDeepLink: true)));
            }
          }
    }
  }
  
  void checkIfUserExists() async{
    Timer(const Duration(seconds: 2), () async {
      String? accessToken = await context.read<AuthenticationProvider>().getAccessToken();
      if(!context.mounted) return;
      

      context.read<BottomChangeScreenIndexProvider>().setScreenIndex(0);
      if(!context.mounted) return;
      
      await context.read<LocationProvider>().intit();
      if(!context.mounted) return;
      
      
      final refAuth = await context.read<AuthenticationProvider>();
      String userId = await refAuth.getUserId();
      if(!context.mounted) return;


      if(userId.isNotEmpty){
          await AuthenticationConroller.setUserDetails(context, userId);
          print("User Ids :: ${userId}");
      }else{
         await refAuth.setIsGuestTemp(true);
      }

      bool isGuest = await context.read<AuthenticationProvider>().getIsGuest();
      bool isGuestLocally = await context.read<AuthenticationProvider>().getIsGuestLocally();

      if(!context.mounted) return;

      print("Access Token : $accessToken");
      print("Guest Status : $isGuest - $isGuestLocally");

      try {
        final uri = await getInitialUri();
        await deepLinkRedirect(uri);

        uriLinkStream.listen((Uri? uri) async { 
          print("DeepLink Listner activated....");
          await deepLinkRedirect(uri);
        },onError: (e){
           throw ErrorDescription("Stream Listen Error : ${e.toString()}");
        });
      } catch (e) {
        print("UniLinks Error :::: ${e.toString()}");
      }
      
      if (accessToken.isNotEmpty) {
         Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
      }else if (isGuest && isGuestLocally){
         Navigator.pushReplacementNamed(context, NamedRoutes.bottomNavigationRoute);
      } else {
         Navigator.pushReplacementNamed(context,NamedRoutes.authenticationRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: ColorsConstant.appColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImagePathConstant.splashLogo),
            SizedBox(height: 2.h),
            Text(
              StringConstant.splashScreenText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }


}