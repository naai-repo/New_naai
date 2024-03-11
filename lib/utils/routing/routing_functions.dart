import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/services/uni_deeplink_services/uni_deep_link_services.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/views/post_auth/bottom_navigation/bottom_navigation.dart';
import 'package:naai/views/post_auth/explore/explore_stylist_screen.dart';
import 'package:naai/views/post_auth/map/map_screen.dart';
import 'package:naai/views/post_auth/set_location/set_location_screen.dart';
import 'package:naai/views/pre_auth/auth/auth_screen.dart';
import 'package:naai/views/pre_auth/auth/otp_verify_screen.dart';
import 'package:naai/views/pre_auth/auth/user_details_screen.dart';
import 'package:naai/views/splash_screen.dart';
import 'package:provider/provider.dart';

import '../../views/post_auth/artist_details/artist_details_screen.dart';
import '../../views/post_auth/salon_details/salon_details_screen.dart';

class ScreenArguments {
  num showPrice;
  ScreenArguments(this.showPrice);
}

/// Class that contains string constants for all routes used in the app
class RoutingFunctions {
  static BuildContext? _context;
  static BuildContext get context => _context!;
  static void set context(BuildContext ctx) => _context = ctx;

  /// Handles routes that can't be handled using simple named routes map.
  static Route<dynamic>? generateRoutes(RouteSettings settings){
    print("generateRoutes($settings)");
    Uri routeUri = Uri.parse(settings.name!);
    List<String> paths = routeUri.pathSegments;

    Widget? target;
    print(paths);


    if(paths.length == 2){
      int idx = context.read<BottomChangeScreenIndexProvider>().screenIndex;
      print("Routing Bottom Index ::: $idx");
      if(idx == -1){
        return createRoute(SplashScreen());
      }

      if(paths[0] == "salon"){
         target = SalonDetailsScreen(salonDetails: SalonResponseData(id : paths[1]),isFromDeepLink: true);
      }else if(paths[0] == "artist"){
         target = ArtistDetailScreen(artistId: paths[1],isFromDeepLink: true);
      }
      if (target != null) return createRoute(target);
    }

    switch (routeUri.path) {
      case NamedRoutes.splashRoute:
        target = const SplashScreen();
        break;
      case NamedRoutes.authenticationRoute:
        target = const AuthenticationScreen();
        break;
      case NamedRoutes.verifyOtpRoute:
        target = const VerifyOtpScreen();
        break;
      case NamedRoutes.bottomNavigationRoute:
        target = const BottomNavigationScreen();
        break;
      case NamedRoutes.exploreStylistRoute:
        target = const ExploreStylist();

      case NamedRoutes.setHomeLocationRoute:
        target = const SetLocationScreen();
        break;
      case NamedRoutes.mapRoute:
        target = const MapScreen();
        break;
      case NamedRoutes.addUserNameRoute:
        target = const UserDetailsEnterScreen();
        break;
    }

    if (target != null) {
      print("Found route, opening it");
      return createRoute(target);
    } else {
      print("Unknown route found");
      return null;
    }
  }

  /// Function used to create custom animated route
  static Route createRoute(Widget widget){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0, 0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}