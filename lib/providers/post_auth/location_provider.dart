import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationProvider with ChangeNotifier {
  LatLng _latLng = const LatLng(28.6304, 77.2177);
  LatLng get latLng => _latLng;
  
  Placemark _place = const Placemark(country: "Naai Explore",locality: "");
  Placemark get place => _place;
  
  bool _isDeniedLocationForever = false;
  bool get isDeniedLocationForever => _isDeniedLocationForever;

  bool _isLocationPopUpShown = false;
  bool get isLocationPopUpShown => _isLocationPopUpShown;

  String _address = "Delhi";
  String get address => _address;

  Future<void> setLatLng(LatLng value) async {
    _latLng = value;
    final box = await Hive.openBox('userBox');
    box.put('lat',_latLng.latitude.toString());
    box.put('lng',_latLng.longitude.toString());

    _place = await getAddress(_latLng.latitude,_latLng.longitude);
    _address = "${place.subLocality}, ${place.locality}";
    notifyListeners();
  }

  Future<Placemark> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      return placemarks[0];
    } catch (e) {
      print("Error Getting Address: $e");
      return const Placemark();
    }
  }
  
  Future<bool> getDeniedLocationForever() async {
    if(isDeniedLocationForever) return true;
    final box = await Hive.openBox('userBox');
    bool ans = box.get('isDeniedForever', defaultValue: false) ?? false;
    _isDeniedLocationForever = ans;
    return ans;
  }

  Future<void> setDeniedLocationForever(bool value) async {
    final box = await Hive.openBox('userBox');
    box.put('isDeniedForever', value);
    _isDeniedLocationForever = value;
  }

  Future<bool> getIsPopUpShown() async {
    if(_isLocationPopUpShown) return true;
    final box = await Hive.openBox('userBox');
    bool ans = box.get('locationPopUp', defaultValue: false) ?? false;
    _isLocationPopUpShown = ans;
    return ans;
  }

  Future<LatLng> getLatLng() async {
    final box = await Hive.openBox('userBox');
    final lat = box.get('lat', defaultValue: (28.6304).toString()) ?? "28.6304";
    final lng = box.get('lng', defaultValue: (77.2177).toString()) ?? "77.2177";
    _latLng = LatLng(double.parse(lat), double.parse(lng));
    return _latLng;
  }

  Future<void> setIsPopUpShown(bool value) async {
    final box = await Hive.openBox('userBox');
    box.put('locationPopUp', value);
    _isLocationPopUpShown = value;
  }

  Future<void> intit() async {
     LatLng  value = await getLatLng();
    _place = await getAddress(value.latitude,value.longitude);
    _address = "${place.subLocality}, ${place.locality}";
    notifyListeners();
  }


  Future<void> resetAll() async {
    final box = await Hive.openBox('userBox');
    _isLocationPopUpShown = false;
    _isDeniedLocationForever = false;
    box.delete('locationPopUp');
    box.delete('lat');
    box.delete('lng');
    box.delete('isDeniedForever');
  }
}