import 'package:flutter/foundation.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
//  Future<bool> getGeoPermission() async {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return false;
//         }
//       }
//       if(permission == LocationPermission.deniedForever) return false;
//       return true;
//   }

//   Future<Position> getGeoPosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return Future.error('Location services are disabled.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

class TopSalonsProvider with ChangeNotifier {
  final List<SalonResponseData> _topSalons = [];

  int _page = 0,_limit = 10;
  set page(int i) => _page = i;
  set limit(int i) => _limit = i;
  int get getPage => _page;
  int get getLimit => _limit;

  Future<void> setTopSalons(List<SalonResponseData> value,{bool clear = false}) async {
    if(clear) _topSalons.clear();
    _topSalons.addAll(value);
    notifyListeners();
  }
  
  List<SalonResponseData> getTopSalons(){
      return _topSalons;
  }
}


