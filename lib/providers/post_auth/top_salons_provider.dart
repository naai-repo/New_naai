import 'package:flutter/foundation.dart';
import 'package:naai/models/api_models/salon_item_model.dart';

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


