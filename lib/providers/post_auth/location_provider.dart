import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationProvider with ChangeNotifier {
  LatLng _latLng = const LatLng(28.6304, 77.2177);
  LatLng get latLng => _latLng;
  Placemark _place = Placemark(country: "Naai Explore",locality: "");
  Placemark get place => _place;
  
  String _address = "Delhi";
  String get address => _address;

  Future<void> setLatLng(LatLng value) async {
    _latLng = value;
    _place = await getAddress(_latLng.latitude,_latLng.longitude);
    _address = "${place.subLocality}, ${place.locality}";
    notifyListeners();
  }

  Future<Placemark> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      return placemarks[0];
    } catch (e) {
      print("Error getting address: $e");
      return Placemark();
    }
  }
}