import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../models/salon_model.dart';
import '../../../view/post_auth/salon_details/salon_details_screen.dart';
import '../salon_details/salon_details_provider.dart';

class MapProvider with ChangeNotifier {
  late MapboxMapController _controller;

  late Symbol _symbol;
  Dio dio = Dio(); // Initialize Dio instance

  final _mapLocation = location.Location();
  List<SalonData2> salonList2 = []; // Define salonList2 as a global variable.
  late LatLng _userCurrentLatLng;

  final TextEditingController _mapSearchController = TextEditingController();

  //============= GETTERS =============//
  LatLng get userCurrentLatLng => _userCurrentLatLng;

  TextEditingController get mapSearchController => _mapSearchController;

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      const SymbolOptions(),
    );
  }

  /// Initialising map related values as soon as the map is rendered on screen.
  Future<void> onMapCreated(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    _controller = mapController;

    var serviceEnabled = await _mapLocation.serviceEnabled();
    var permissionGranted = await _mapLocation.hasPermission();

    double savedLat = 0.0;
    double savedLong = 0.0;
    if (!serviceEnabled) {
      serviceEnabled = await _mapLocation.requestService();
    }
    if (permissionGranted != location.PermissionStatus.granted) {
      final box = await Hive.openBox('userBox');
      savedLat = box.get('savedLatitude') ?? 0.0;
      savedLong = box.get('savedLongitude') ?? 0.0;
    }

    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await _mapLocation.requestPermission();
    }

    Loader.showLoader(context);
    try {
      var locationData;
      if (permissionGranted == location.PermissionStatus.granted) {
        locationData = await _mapLocation.getLocation();
      } else {
        _userCurrentLatLng = LatLng(savedLat, savedLong);
      }

      _userCurrentLatLng = locationData != null
          ? LatLng(locationData.latitude!, locationData.longitude!)
          : _userCurrentLatLng;

      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userCurrentLatLng,
            zoom: 16,
          ),
        ),
      );
      await getTopSalons(coords: [_userCurrentLatLng.longitude, _userCurrentLatLng.latitude]);
      // Iterate over salon data and add symbols on the map
      for (var salon in salonList2) {
        List<double> coordinates = salon.location.coordinates;
        LatLng salonGeoLocation = LatLng(coordinates[1], coordinates[0]);

        _symbol = await _controller.addSymbol(
          UtilityFunctions.getCurrentLocationSymbolOptions(
            latLng: salonGeoLocation,
          ),
          {StringConstant.salonData: salon},
        );
      }

      // Add symbol tapped listener
      _controller.onSymbolTapped.add((argument) {
        ReusableWidgets.salonOverviewOnMapDialogue(
          context,
          clickedSalonData: argument.data?[StringConstant.salonData],
        );
      });

    } catch (e) {
      print('error $e');
    } finally {
      Loader.hideLoader(context);
    }
  }

  Future<void> getTopSalons({required List<double> coords}) async {
    final apiUrl = 'http://13.235.49.214:8800/partner/salon/topSalons?page=1&limit=30&type=male';

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
        data: requestData,
      );

      if (response.statusCode == 200) {
        // Save response data in salonList2
        salonList2 = SalonApiResponse.fromJson(response.data).data;
        print("Top Salons: $salonList2");
      } else {
        print("Failed to fetch top salons");
        print(response.data);
      }
    } catch (e) {
      print("Dio error for top salons: $e");
    }
  }

  /// Get place suggestions according to the search text
  Future<List<Feature>> getPlaceSuggestions(BuildContext context) async {
    List<Feature> data = [];

    Uri uri = Uri.parse(
            "${ApiEndpointConstant.mapboxPlacesApi}${_mapSearchController.text}.json")
        .replace(queryParameters: UtilityFunctions.mapSearchQueryParameters());

    try {
      var response = await BaseClient()
          .get(baseUrl: '', api: uri.toString())
          .onError((error, stackTrace) => throw Exception(error));

      UserLocationModel responseData =
          UserLocationModel.fromJson(jsonDecode(response.body));

      data = responseData.features ?? [];
      data = [
        Feature(id: StringConstant.yourCurrentLocation),
        ...data,
      ];
    } catch (e) {
      Logger().d(e);
      ReusableWidgets.showFlutterToast(context, e.toString());
    }

    return data;
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
    var serviceEnabled = await _mapLocation.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await _mapLocation.requestService();
    }
    var permissionGranted = await _mapLocation.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await _mapLocation.requestPermission();
    }

    var locationData = await _mapLocation.getLocation();

    return LatLng(locationData.latitude!, locationData.longitude!);
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
