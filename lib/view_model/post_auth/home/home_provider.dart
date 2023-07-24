import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/user.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeProvider with ChangeNotifier {
  bool _changedLocation = false;

  final _mapLocation = location.Location();

  List<SalonData> _salonData = [];
  List<Artist> _artistList = [];

  late Symbol _symbol;

  late MapboxMapController _controller;

  String _addressText = StringConstant.loading;

  TextEditingController _mapSearchController = TextEditingController();

  UserModel _userData = UserModel();

  Booking? _lastOrNextBooking;

  //============= GETTERS =============//
  List<SalonData> get salonData => _salonData;
  List<Artist> get artistList => _artistList;

  String get addressText => _addressText;

  TextEditingController get mapSearchController => _mapSearchController;

  UserModel get userData => _userData;

  Booking? get lastOrNextBooking => _lastOrNextBooking;

  /// Check if there is a [uid] stored in [SharedPreferences] or not.
  /// If no [uid] is found, then get the userId of the currently logged in
  /// user and save it in [SharedPreferences].
  ///
  /// The [uid] is necessary to get the user data.
  void checkUserIdInSharedPref(String uid) async {
    String storedUid = await SharedPreferenceHelper.getUserId();
    if (storedUid.isEmpty) {
      await SharedPreferenceHelper.setUserId(uid);
    }
  }

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      SymbolOptions(),
    );
  }

  /// Method to trigger all the API functions
  Future<void> initHome(BuildContext context) async {
    Loader.showLoader(context);
    await Future.wait([
      context.read<ExploreProvider>().getSalonList(context),
      getUserDetails(context),
      getAllArtists(context),
    ]).onError(
      (error, stackTrace) =>
          ReusableWidgets.showFlutterToast(context, '$error'),
    );
    await getUserBookings(context);

    _salonData = [...context.read<ExploreProvider>().salonData];
    Loader.hideLoader(context);

    if (_userData.homeLocation?.geoLocation == null) {
      Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute,
      );
    }

    notifyListeners();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getUserDetails(BuildContext context) async {
    try {
      _userData = await DatabaseService().getUserDetails();
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getAllArtists(BuildContext context) async {
    try {
      _artistList = await DatabaseService().getAllArtists();
      _artistList.sort((a, b) => ((a.rating ?? 0) - (b.rating ?? 0)).toInt());
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the booking details of user from [FirebaseFirestore]
  Future<void> getUserBookings(BuildContext context) async {
    try {
      List<Booking> response =
          await DatabaseService().getUserBookings(userId: userData.id ?? '');

      for (int i = 0; i < response.length; i++) {
        if (DateTime.parse(response[i].bookingCreatedFor ?? '')
            .isAfter(DateTime.now())) {
          _lastOrNextBooking = response[i];
          break;
        } else if (i == response.length - 1) {
          _lastOrNextBooking = response[i];
        }
      }
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Initialising map related values as soon as the map is rendered on screen.
  Future<void> onMapCreated(
    MapboxMapController mapController,
    BuildContext context,
  ) async {
    this._controller = mapController;

    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation().timeout(
          const Duration(seconds: 7),
          onTimeout: () => UtilityFunctions.locationApiTimeout(context,
              message: StringConstant.locationApiTookTooLong),
        );

    LatLng currentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLatLng,
          zoom: 16,
        ),
      ),
    );

    _symbol = await this._controller.addSymbol(
          UtilityFunctions.getCurrentLocationSymbolOptions(
              latLng: currentLatLng),
        );

    Loader.hideLoader(context);

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: currentLatLng,
    );
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

    await _controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(latLng: selectedLatLng),
    );

    clearMapSearchText();

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: selectedLatLng,
    );
    notifyListeners();
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

      /// [Feature(id: StringConstant.yourCurrentLocation)] is added to show the current
      /// location card
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

  /// Handle the click event on the map.
  /// Fetches the coordinate of the point clicked by the user.
  Future<void> onMapClick({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    _mapSearchController.clear();
    print("Coordinates ===> $coordinates");
    await _controller.removeSymbol(_symbol);

    _symbol = await _controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(latLng: coordinates),
    );

    this._controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: coordinates, zoom: 16),
          ),
        );

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: coordinates,
    );

    notifyListeners();
  }

  /// Update the user's location related data in [FirebaseFirestore]
  void updateUserLocation(
    BuildContext context,
    LatLng latLng,
  ) async {
    UserModel user = UserModel.fromMap(_userData.toMap());

    user.homeLocation = HomeLocation();

    user.homeLocation?.addressString = _addressText;
    user.homeLocation?.geoLocation =
        GeoPoint(latLng.latitude, latLng.longitude);

    Map<String, dynamic> data = user.toMap();
    Loader.showLoader(context);
    try {
      await DatabaseService().updateUserData(data: data).onError(
          (FirebaseException error, stackTrace) =>
              throw ExceptionHandling(message: error.message ?? ""));
      _changedLocation = true;
      getUserDetails(context);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }

    Navigator.pop(context);
  }

  /// Get complete address from the provided coordinates
  /// Format the address according to the need.
  /// Show a bottom sheet with the formatted address text and a button to confirm
  /// the new address.
  Future<void> getFormattedAddressConfirmation({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    Loader.showLoader(context);

    _addressText = await UtilityFunctions.getAddressCoordinateAndFormatAddress(
      context: context,
      latLng: coordinates,
    );

    Loader.hideLoader(context);

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(2.h),
          ),
        ),
        height: 20.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _addressText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorsConstant.appColor),
              ),
              onPressed: () => updateUserLocation(context, coordinates),
              child: Text(StringConstant.confirmLocation),
            ),
          ],
        ),
      ),
    );
    if (_changedLocation) {
      Navigator.pop(context);
      _changedLocation = false;
    }
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

    var _locationData = await _mapLocation.getLocation().timeout(
          const Duration(seconds: BaseClient.TIME_OUT_DURATION),
          onTimeout: () => UtilityFunctions.locationApiTimeout(context,
              message: StringConstant.locationApiTookTooLong),
        );

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

  /// Get the address text from the user's home location
  String? getHomeAddressText() {
    return userData.homeLocation?.addressString;
  }

  /// Dispose [_controller] when the map is unmounted
  void disposeMapController() {
    _controller.dispose();
  }

  /// Clear the value of[_mapSearchController]
  void clearMapSearchText() {
    _mapSearchController.clear();
    notifyListeners();
  }
}