import 'package:flutter/material.dart';
import 'package:naai/view/post_auth/barber_profile/barber_profile_screen.dart';
import 'package:naai/view/post_auth/bottom_navigation_screen.dart';
import 'package:naai/view/post_auth/create_booking/appointment_details.dart';
import 'package:naai/view/post_auth/create_booking/booking_confirmed_screen.dart';
import 'package:naai/view/post_auth/create_booking/create_booking_screen.dart';
import 'package:naai/view/post_auth/explore/explore_stylist.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/view/post_auth/home/set_home_location_screen.dart';
import 'package:naai/view/post_auth/map/map_screen.dart';
import 'package:naai/view/post_auth/profile/booking_history_screen.dart';
import 'package:naai/view/post_auth/profile/favourites_screen.dart';
import 'package:naai/view/post_auth/profile/reviews_screen.dart';
import 'package:naai/view/post_auth/salon_details/salon_details_screen.dart';
import 'package:naai/view/pre_auth/Authentication_screen.dart';
import 'package:naai/view/post_auth/explore/explore_screen.dart';
import 'package:naai/view/pre_auth/username_screen.dart';
import 'package:naai/view/pre_auth/verify_otp_screen.dart';
import 'package:naai/view/splash_screen.dart';
import 'package:naai/utils/routing/named_routes.dart';

import '../../view/post_auth/profile/profile_screen.dart';
import '../../view/pre_auth/forget_password_screen.dart';

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
      case NamedRoutes.addUserNameRoute:
        target = const UsernameScreen();
        break;
      case NamedRoutes.bottomNavigationRoute:
        target = BottomNavigationScreen();
        break;
      case NamedRoutes.bottomNavigationRoute4:
        target = BottomNavigationScreen4();
        break;
      case NamedRoutes.bottomNavigationRoute2:
        target = BottomNavigationScreen2();
        break;
      case NamedRoutes.bottomNavigationRoute3:
        target = BottomNavigationScreen3();
        break;
      case NamedRoutes.exploreRoute:
        target = const ExploreScreen();
        break;
      case NamedRoutes.exploreRoute2:
        target = const ExploreScreen2();
        break;
      case NamedRoutes.exploreRoute3:
        target = const ExploreScreen3();
        break;
      case NamedRoutes.exploreStylistRoute:
        target = const ExploreStylist();
        break;
      case NamedRoutes.exploreStylistRoute2:
        target = const ExploreStylist2();
        break;
      case NamedRoutes.homeRoute:
        target = const HomeScreen();
        break;
      case NamedRoutes.salonDetailsRoute:
        target = const SalonDetailsScreen();
        break;
      case NamedRoutes.salonDetailsRoute2:
        target = const SalonDetailsScreen2();
        break;
      case NamedRoutes.setHomeLocationRoute:
        target = const SetHomeLocationScreen();
        break;
      case NamedRoutes.setHomeLocationRoute2:
        target = const SetHomeLocationScreen2();
        break;
      case NamedRoutes.mapRoute:
        target = const MapScreen();
        break;
      case NamedRoutes.barberProfileRoute:
        target = BarberProfileScreen();
        break;
      case NamedRoutes.barberProfileRoute2:
        target = BarberProfileScreen2();
        break;
      case NamedRoutes.createBookingRoute:
        target = CreateBookingScreen();
        break;
      case NamedRoutes.createBookingRoute3:
        target = CreateBookingScreen3();
        break;
      case NamedRoutes.createBookingRoute2:
        target = const CreateBookingScreen2();
        break;
      case NamedRoutes.reviewsRoute:
        target = const ReviewsScreen();
        break;
      case NamedRoutes.favouritesRoute:
        target = const FavourtieScreen();
        break;
      case NamedRoutes.bookingConfirmedRoute:
        target = const BookingConfirmedSreen();
        break;
      case NamedRoutes.appointmentDetailsRoute:
        target = AppointmentDetails(index: settings.arguments as int);
        break;
      case NamedRoutes.appointmentDetailsRoute2:
        target = AppointmentDetails2(index: settings.arguments as int);
        break;
      case NamedRoutes.bookingHistoryRoute:
        target = const BookingHistoryScreen();
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
  static Route createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0, 0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
