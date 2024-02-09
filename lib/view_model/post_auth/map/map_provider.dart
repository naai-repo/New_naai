import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';

class MapProvider with ChangeNotifier {
  late MapboxMapController _controller;

  late Symbol _symbol;

  final _mapLocation = location.Location();

  late LatLng _userCurrentLatLng;

  TextEditingController _mapSearchController = TextEditingController();

  //============= GETTERS =============//
  LatLng get userCurrentLatLng => _userCurrentLatLng;

  TextEditingController get mapSearchController => _mapSearchController;

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      SymbolOptions(),
    );
  }

  /// Initialising map related values as soon as the map is rendered on screen.
  Future<void> onMapCreated(
    MapboxMapController mapController,
    BuildContext context,
  ) async {
    this._controller = mapController;

    var _serviceEnabled = await _mapLocation.serviceEnabled();
    var _permissionGranted = await _mapLocation.hasPermission();

    double savedLat = 0.0;
    double savedLong = 0.0;
    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    if (_permissionGranted != location.PermissionStatus.granted) {
      final box = await Hive.openBox('userBox');
      savedLat = box.get('savedLatitude') ?? 0.0;
      savedLong = box.get('savedLongitude') ?? 0.0;
    }

    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    Loader.showLoader(context);
    try {
      var _locationData;
      if (_permissionGranted == location.PermissionStatus.granted) {
        _locationData = await _mapLocation.getLocation();
      } else {

        _userCurrentLatLng =
            LatLng(savedLat , savedLong);

      }


      _userCurrentLatLng =
          LatLng(_locationData.latitude!, _locationData.longitude!);

      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userCurrentLatLng,
            zoom: 16,
          ),
        ),
      );

      List<SalonData> _salonData = [...context
          .read<ExploreProvider>()
          .salonData
      ];

      _salonData.forEach((salon) async {
        //_symbol = await this._controller.addSymbol(
        // UtilityFunctions.getCurrentLocationSymbolOptions(
        //  latLng: salonGeoLocation,
        //),
        //{StringConstant.salonData: salon},
        //);
      });

      this._controller.onSymbolTapped.add((argument) {
        ReusableWidgets.salonOverviewOnMapDialogue(
          context,
          clickedSalonData: argument.data?[StringConstant.salonData],
        );
      });
    } catch (e){
      print("Error gettig location : $e");
    }
      Loader.hideLoader(context);

  }
  /// Get place suggestions according to the search text
  Future<List<Feature>> getPlaceSuggestions(BuildContext context) async {
    List<Feature> _data = [];

    Uri uri = Uri.parse(
            "${ApiEndpointConstant.mapboxPlacesApi}${_mapSearchController.text}.json")
        .replace(queryParameters: UtilityFunctions.mapSearchQueryParameters());

    try {
      var response = await BaseClient()
          .get(baseUrl: '', api: uri.toString())
          .onError((error, stackTrace) => throw Exception(error));

      UserLocationModel responseData =
          UserLocationModel.fromJson(jsonDecode(response.body));

      _data = responseData.features ?? [];
      _data = [
        Feature(id: StringConstant.yourCurrentLocation),
        ..._data,
      ];
    } catch (e) {
      Logger().d(e);
      ReusableWidgets.showFlutterToast(context, e.toString());
    }

    return _data;
  }

  /// Take user to the place, selected from search suggestions
  Future<void> handlePlaceSelectionEvent(
    Feature place,
    BuildContext context,
  ) async {
    _mapSearchController.text = place.placeName ?? "";

    LatLng selectedLatLng =
        LatLng(place.center?[1] ?? 0.0, place.center?[0] ?? 0.0);

    await _controller.removeSymbol(_symbol);

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLatLng, zoom: 16),
      ),
    );

    clearMapSearchController();

    notifyListeners();
  }

  /// Method to fetch the current location of the user using [location] package
  Future<LatLng> fetchCurrentLocation(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    var _locationData = await _mapLocation.getLocation();

    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  /// Animate the map to given [latLng]
  Future<void> animateToPosition(LatLng latLng) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16),
      ),
    );
  }

  /// Clear the value of[_mapSearchController]
  void clearMapSearchController() {
    _mapSearchController.clear();
    notifyListeners();
  }
}
