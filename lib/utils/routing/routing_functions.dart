import 'package:flutter/material.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/views/post_auth/bottom_navigation/bottom_navigation.dart';
import 'package:naai/views/post_auth/explore/explore_stylist_screen.dart';
import 'package:naai/views/post_auth/map/map_screen.dart';
import 'package:naai/views/post_auth/set_location/set_location_screen.dart';
import 'package:naai/views/pre_auth/auth/auth_screen.dart';
import 'package:naai/views/pre_auth/auth/otp_verify_screen.dart';
import 'package:naai/views/splash_screen.dart';

class ScreenArguments {
  num showPrice;
  ScreenArguments(this.showPrice);
}

/// Class that contains string constants for all routes used in the app
class RoutingFunctions {
  /// Handles routes that can't be handled using simple named routes map.
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    print("generateRoutes($settings)");
    Uri routeUri = Uri.parse(settings.name!);

    Widget? target;

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
