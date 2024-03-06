import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/views/post_auth/artist_details/artist_details_screen.dart';
import 'package:naai/views/post_auth/salon_details/salon_details_screen.dart';
import 'package:uni_links/uni_links.dart';

class UniServices{
  static GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
 
  static StreamSubscription? _sub;
  static StreamSubscription? get sub => _sub;

  static Uri? _uri;
  static Uri? get uri => _uri;

  // static void setContext(BuildContext context){
  //     _context = context;
  // }
  static Future<void> init() async {
    try {
      Uri? uri = await getInitialUri();
      handleUri(uri);
    } catch (e) {
      print("UniLink Get Initial Url Error :${e.toString()}");
    }

    _sub = uriLinkStream.listen((Uri? uri) { 
      print("DeepLink Listner activated....");
    },onError: (e){
      print("UniLinks Listen Error : ${e.toString()}");
    });
  }



  static handleUri(Uri? uri) async {
    _uri = uri;
    if(uri == null || uri.pathSegments.isEmpty) return;
    List<String> paths = uri.pathSegments;

    if(paths.length != 2) return;

    if(paths[0] == "salon"){
        Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (_) => SalonDetailsScreen(salonDetails: SalonResponseData(id : paths[1]))));
    }else{
        Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (_) => ArtistDetailScreen(artistId: paths[1])));
    }
  }
}