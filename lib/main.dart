import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/artist_service_filter_provider.dart';
import 'package:naai/providers/post_auth/booking_screen_change_provider.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/providers/post_auth/filter_artist_provider.dart';
import 'package:naai/providers/post_auth/filter_salon_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/post_auth/reviews_provider.dart';
import 'package:naai/providers/post_auth/salon_services_filter_provider.dart';
import 'package:naai/providers/post_auth/single_artist_provider.dart';
import 'package:naai/providers/post_auth/single_salon_provider.dart';
import 'package:naai/providers/post_auth/top_artists_provider.dart';
import 'package:naai/providers/post_auth/top_salons_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/uni_deeplink_services/uni_deep_link_services.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/routing/routing_functions.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (_) => TopArtistsProvider()),
          ChangeNotifierProvider(create: (_) => TopSalonsProvider()),
          ChangeNotifierProvider(create: (_) => FilterSalonsProvider()),
          ChangeNotifierProvider(create: (_) => FilterArtitsProvider()),
          ChangeNotifierProvider(create: (_) => SingleSalonProvider()),
          ChangeNotifierProvider(create: (_) => SingleArtistProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => BottomChangeScreenIndexProvider()),
          ChangeNotifierProvider(create: (_) => ReviewsProvider()),
          ChangeNotifierProvider(create: (_) => SalonsServiceFilterProvider()),
          ChangeNotifierProvider(create: (_) => ArtistServicesFilterProvider()),
          ChangeNotifierProvider(create: (_) => BookingServicesSalonProvider()),
          ChangeNotifierProvider(create: (_) => BookingScreenChangeProvider()),
      ],
      
      child: ScreenUtilInit(
        designSize: const Size(414,896),
        splitScreenMode: true,
        minTextAdapt: true,
        ensureScreenSize: true,
        builder: (context, child) {
          RoutingFunctions.context = context;
          return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Naai',
                theme: ThemeData(
                  fontFamily: 'Poppins',
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: ColorsConstant.appColor
                  ),
                ),
                
               onGenerateRoute: RoutingFunctions.generateRoutes,
               initialRoute: NamedRoutes.splashRoute,
          );
        },
        child: const Center(child: Text("Hello world")),
      ),
    );
  }
}