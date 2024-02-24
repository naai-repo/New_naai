import 'package:flutter/material.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';


class SingleArtistProvider with ChangeNotifier{
  SingleArtistScreenModel _artistDetails = SingleArtistScreenModel();
  SingleArtistScreenModel get artistDetails => _artistDetails;

  void setArtistDetails(SingleArtistScreenModel value){
      _artistDetails = value;
      notifyListeners();
  }
}