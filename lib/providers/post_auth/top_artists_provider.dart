import 'package:flutter/foundation.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/top_artist_model.dart';

class TopArtistsProvider with ChangeNotifier {
  final List<TopArtistResponseModel> _topArtists = [];
  
  int _page = 0,_limit = 10;
  set page(int i) => _page = i;
  set limit(int i) => _limit = i;
  int get getPage => _page;
  int get getLimit => _limit;


  Future<void> setTopArtists(List<TopArtistResponseModel> value,{bool clear = false}) async {
      if(clear){
        _topArtists.clear();
      }
      _topArtists.addAll(value);
      notifyListeners();
  }

  Future<void> setTopSalons(List<SalonResponseData> value) async {
      notifyListeners();
  }

  List<TopArtistResponseModel> getTopArtists(){
      return _topArtists;
  }
}