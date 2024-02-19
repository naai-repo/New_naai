import 'package:flutter/material.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';


class SingleArtistProvider with ChangeNotifier{
  late SingleArtistScreenModel _artistDetails;
  SingleArtistScreenModel get artistDetails => _artistDetails;

  void setArtistDetails(SingleArtistScreenModel value){
      _artistDetails = value;
      notifyListeners();
  }
}