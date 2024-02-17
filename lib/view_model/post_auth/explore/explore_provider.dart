import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naai/models/artist.dart';
import 'package:location/location.dart' as location;
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/shared_preferences/shared_keys.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/artist_model.dart';
import '../../../models/salon_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/routing/named_routes.dart';
import '../../pre_auth/loginResult.dart';

class ExploreProvider with ChangeNotifier {
  TextEditingController _salonSearchController = TextEditingController();
  TextEditingController _artistSearchController = TextEditingController();
  final Dio dio = Dio();
  String userAddress = '';
  location.Location get mapLocation => _mapLocation;
  final _mapLocation = location.Location();
  List<FilterType> _selectedFilterTypeList = [];
  List<SalonData> _salonData = [];
  List<SalonData> _filteredSalonData = [];
  List<ServiceDetail> _currentSalonServices = [];
  List<Artist> _artistList = [];
  List<ArtistData> _artistList2 = [];
  List<SalonData2> _salonList2 = [];
  bool _applyServiceFilter = false;
  Services _appliedServiceFilter = Services.HAIR;


  int _selectedDiscountIndex = -1;
  int get selectedDiscountIndex => _selectedDiscountIndex;

  int _selectedRatingIndex = -1;
  int get selectedRatingIndex => _selectedRatingIndex;

  set setSelectedRatingIndex(int i){
    _selectedRatingIndex = i;
    notifyListeners();
  }

  //============= GETTERS =============//
  TextEditingController get salonSearchController => _salonSearchController;
  TextEditingController get artistSearchController => _artistSearchController;

  List<FilterType> get selectedFilterTypeList => _selectedFilterTypeList;
  List<SalonData> get salonData => _salonData;
  List<SalonData2> get salonData2 => _salonList2;
  List<SalonData> get filteredSalonData => _filteredSalonData;
  List<Artist> get artistList => _artistList;
  List<ArtistData> get artistList2 => _artistList2;

  set salonList2(List<SalonData2> value) {
    _salonList2 = value;
    notifyListeners();
  }

  set artistList2(List<ArtistData> value) {
    _artistList2 = value;
    notifyListeners();
  }

  String formatTime(int timeInSeconds) {
    int hours = (timeInSeconds ~/ 3600) % 12;
    int minutes = ((timeInSeconds % 3600) ~/ 60);
    String amPm = (timeInSeconds ~/ 43200) == 0 ? 'AM' : 'PM';

    if (hours == 0) {
      hours = 12;
    }

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPm';
    return formattedTime;
  }

  /// Reset [_artistSearchController]
  void resetStylistSearchBar() {
    _artistSearchController.clear();
    notifyListeners();
  }

  /// Set selected filter
  void setSelectedFilter(FilterType filterType) {
    if (_selectedFilterTypeList.contains(filterType)) {
      _selectedFilterTypeList.remove(filterType);
      _filteredSalonData = _salonData;
    } else {
      _selectedFilterTypeList.add(filterType);
      _filteredSalonData.sort((a, b) {
        return b.rating!.compareTo(a.rating!);
      });
    }

    notifyListeners();
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.locality}, ${place.country}";
    } catch (e) {
      print("Error getting address: $e");
      return "Error: $e";
    }
  }
  Future<void> initHome(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
      if (!_serviceEnabled) return;
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      print("User denied permissions to access the device's location.");
      await loadSavedCoordinates(context);
      return;
    }

    if (_permissionGranted != location.PermissionStatus.granted) return;

    Loader.showLoader(context);

    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    if (userId.isNotEmpty) {
      print('Retrieved userId from Hive: $userId');
      try {
        Position currentLocation = await Geolocator.getCurrentPosition();

        if (currentLocation != null) {
          // Use current location if available
          print('Current Location: ${currentLocation.longitude}, ${currentLocation.latitude}');
          userAddress = await getAddress(currentLocation.latitude, currentLocation.longitude);
          await updateUserLocation(
            userId: userId,
            coords: [currentLocation.longitude, currentLocation.latitude],
          );
        } else {
          // Use saved coordinates if current location is not available
          await loadSavedCoordinates(context); // Load and use saved coordinates
        }

        await Future.wait([
          getTopSalons(coords: [currentLocation.longitude, currentLocation.latitude]),
          getTopArtists(coords: [currentLocation.longitude, currentLocation.latitude]),
         ]);

      } catch (e) {
        print("Error getting location: $e");
      }
    }
    Loader.hideLoader(context);
  }

  Future<void> loadSavedCoordinates(BuildContext context) async {
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    double savedLatitude = box.get('savedLatitude') ?? 0.0;
    double savedLongitude = box.get('savedLongitude') ?? 0.0;

    if (savedLatitude != 0.0 && savedLongitude != 0.0) {
      print('Using saved coordinates: $savedLongitude, $savedLatitude');
      userAddress = await getAddress(savedLatitude, savedLongitude);
      await updateUserLocation(
        userId: userId,
        coords: [savedLongitude, savedLatitude],
      );
      await Future.wait([
        getTopSalons(coords: [savedLongitude, savedLatitude]),
        getTopArtists(coords: [savedLongitude, savedLatitude]),
      ]);
    } else {
      // Handle the case when both current location and saved coordinates are not available
      print('No location information available.');
    }
  }

  Future<void> loadSavedCoordinatesForFilter(BuildContext context) async {
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    double savedLatitude = box.get('savedLatitude') ?? 0.0;
    double savedLongitude = box.get('savedLongitude') ?? 0.0;

    if (savedLatitude != 0.0 && savedLongitude != 0.0) {
      print('Using saved coordinates: $savedLongitude, $savedLatitude');
      userAddress = await getAddress(savedLatitude, savedLongitude);
      await updateUserLocation(
        userId: userId,
        coords: [savedLongitude, savedLatitude],
      );
      await Future.wait([
        getDistanceAndRating(coords: [savedLongitude, savedLatitude]),
        getArtistRating(coords: [savedLongitude, savedLatitude]),
      ]);
    } else {
      // Handle the case when both current location and saved coordinates are not available
      print('No location information available.');
    }
  }


  Future<void> OnlyArtist(BuildContext context) async {

    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    if (userId.isNotEmpty) {
      print('Retrieved userId from Hive: $userId');
      try {
        Position currentLocation = await Geolocator.getCurrentPosition();
        print('Current Location: ${currentLocation.longitude}, ${currentLocation.latitude}');
        await updateUserLocation(
          userId: userId,
          coords: [currentLocation.longitude, currentLocation.latitude],
        );

        // Run top salon and top artist requests concurrently
        await Future.wait([
       //   getTopSalons(coords: [currentLocation.longitude, currentLocation.latitude]),
          getTopArtists(coords: [currentLocation.longitude, currentLocation.latitude]),
          //   getDistanceAndRating(coords: [currentLocation.longitude, currentLocation.latitude]),
          //   getArtistRating(coords: [currentLocation.longitude, currentLocation.latitude]),
        ]);

      } catch (e) {
        print("Error getting location: $e");
      }
    }

    Loader.hideLoader(context);
  }

  Future<void> Filter(BuildContext context) async {

    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    if (userId.isNotEmpty) {
      print('Retrieved userId from Hive: $userId');
      try {
        Position currentLocation = await Geolocator.getCurrentPosition();
        if (currentLocation != null) {
          print(
              'Current Location: ${currentLocation.longitude}, ${currentLocation
                  .latitude}');
          // Update user location
          await updateUserLocation(
            userId: userId,
            coords: [currentLocation.longitude, currentLocation.latitude],
          );
        }else{
          await loadSavedCoordinatesForFilter(context);
        }
        await Future.wait([
            getDistanceAndRating(coords: [currentLocation.longitude, currentLocation.latitude]),
             getArtistRating(coords: [currentLocation.longitude, currentLocation.latitude]),
        ]);

      } catch (e) {

        print("Error getting location: $e");
      }
    }

    Loader.hideLoader(context);
  }



  Future<void> updateUserLocation({
    required String userId,
    required List<double> coords,
  }) async {
    final apiUrl = UrlConstants.updateLocation;

    final Map<String, dynamic> requestData = {
      "userId": userId,
      "coords": coords,
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print("Location updated successfully!");
        print(response.data);
      } else {
        // Handle error response
        print("Failed to update location");
        print(response.data);
      }
    } catch (e) {
      // Handle Dio errors
      print("Dio error: $e");
    }
  }

  Future<void> getTopSalons({required List<double> coords}) async {
    final apiUrl = UrlConstants.topSalon;

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        salonList2 = SalonApiResponse.fromJson(response.data).data;
        print("Top Salons: ${response.data}");
      } else {
        // Handle error response for top salons
        print("Failed to fetch top salons");
        print(response.data);
      }
    } catch (e) {
      // Handle Dio errors for top salons
      print("Dio error for top salons: $e");
    }
  }

  Future<void> getTopArtists({required List<double> coords}) async {
    final apiUrl = UrlConstants.topArtist;

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        artistList2 = ArtistApiResponse.fromJson(response.data).data;
        print("Top Artists: ${response.data}");
      } else {
        // Handle error response for top artists
        print("Failed to fetch top artists");
        print(response.data);
      }
    } catch (e) {
      // Handle Dio errors for top artists
      print("Dio error for top artists: $e");
    }
  }

  Future<void> getDistanceAndRating({required List<double> coords}) async {
    final apiUrl = UrlConstants.discountAndRatingForWomen;

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );
      if (response.statusCode == 200) {
        salonList2 = SalonApiResponse.fromJson(response.data).data;
        print("Top Salons: ${response.data}");
      }
      else {
        // Handle error response for top artists
        print("Failed to fetch top artists");
        print(response.data);
      }
    } catch (e) {
      // Handle Dio errors for top artists
      print("Dio error for top artists: $e");
    }
  }

  Future<void> getArtistRating({required List<double> coords}) async {
    final apiUrl = UrlConstants.ratingFilter;

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );
      if (response.statusCode == 200) {
        artistList2 = ArtistApiResponse.fromJson(response.data).data;
        print("Top Artists: ${response.data}");
      }
       else {
        // Handle error response for top artists
        print("Failed to fetch top artists");
        print(response.data);
      }
    } catch (e) {
      // Handle Dio errors for top artists
      print("Dio error for top artists: $e");
    }
  }


  /// Method to initialize values of Explore screen viz. [_salonData] and [_userCurrentLatLng]
  void initExploreScreen(BuildContext context) async {
    Loader.showLoader(context);
    //await getSalonList(context);
    artistList.forEach((artist) {
      artist.distanceFromUser = salonData
          .firstWhere((element) => element.id == artist.salonId)
          .distanceFromUser;
    });
    artistList.sort(
      (first, second) =>
          first.distanceFromUser!.compareTo(second.distanceFromUser!),
    );

    if (_applyServiceFilter) {
      filterSalonListByService(selectedServiceCategory: _appliedServiceFilter);
    }

    setApplyServiceFilter(value: false);

    Loader.hideLoader(context);
    notifyListeners();
  }

  /// Get all artist list from home screen
  void setArtistList(List<Artist> artists) {
    _artistList = artists;
    notifyListeners();
  }







  /// Set the value of [_filteredSalonData] according to the search query entered by user.
  Future<void> filterArtistList(String searchText) async {
    try {
      final response = await Dio().get(
        'http://13.235.49.214:8800/partner/artist?name=$searchText',
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');

        // Check if response.data['data'] is a list
        if (response.data['data'] is List<dynamic>) {
          List<ArtistData> filteredList = (response.data['data'] as List<dynamic>).map((artistJson) {
            return ArtistData.fromJson(artistJson as Map<String, dynamic>);
          }).toList();

          // Update the artist list in your provider
          artistList2 = filteredList;

          // Notify listeners that the data has changed
          notifyListeners();
        } else {
          // If response.data['data'] is not a list, handle it accordingly
          print('Unexpected response format. Expected a list.');
        }
      } else {
        // Handle error response
        print('Failed to fetch artists. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      print('Error fetching artists: $error');
    }
  }


  /// Set the value of [_filteredSalonData] according to the selected service.
  void filterSalonListByService({required Services selectedServiceCategory}) {
    _filteredSalonData.clear();
    _salonData.forEach((salon) {
      _currentSalonServices.forEach((salonService) {
        if (salonService.category == selectedServiceCategory) {
          _filteredSalonData.add(salon);
        }
      });
    });
    notifyListeners();
  }

  /// Set the value of [_filteredSalonData] according to the selected service.
  // void filterSalonListByDistance({required Services selectedServiceCategory}) {
  //   _filteredSalonData.sort((first, second) => );
  //   notifyListeners();
  // }

  /// Save the index of the selected salon from the list of salons
  void setSelectedSalonIndex(BuildContext context, {int index = 0}) {
    context.read<SalonDetailsProvider>().setSelectedSalonIndex(index);
  }

  /// Search the index of selected salon and set the index value
  void setSalonIndexByData(
    BuildContext context,
    SalonData2 clickedSalonData,
  ) {
    int indexOfSalon =
    _salonList2.indexWhere((salon) => salon.id == clickedSalonData.id);
    setSelectedSalonIndex(context, index: indexOfSalon);
  }

  /// Clear the value of [_salonSearchController]
  void clearSalonSearchController() {
    _salonSearchController.clear();
    notifyListeners();
  }

  void setApplyServiceFilter({
    required bool value,
    Services? service,
  }) {
    _applyServiceFilter = value;
    _appliedServiceFilter = service ?? Services.HAIR;
    notifyListeners();
  }

  Future<void> addPreferedSalon(BuildContext context, String? salonId) async {
    if (salonId == null) return;
    context.read<HomeProvider>().salonList2.add(salonId as SalonData2);
    /*
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    */
    notifyListeners();
  }

  Future<void> removePreferedSalon(
      BuildContext context, String? salonId) async {
    context.read<HomeProvider>().salonList2.remove(salonId);
    /*   await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    */
    notifyListeners();
  }

  Future<void> addPreferedArtist(BuildContext context, String? artistId) async {
    if (artistId == null) return;
    context.read<HomeProvider>().artistList2.add(artistId as ArtistData);
    /*
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    */
    notifyListeners();
  }

  Future<void> removePreferedArtist(
      BuildContext context, String? artistId) async {
    context.read<HomeProvider>().artistList2.remove(artistId);
    /*
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    */
    notifyListeners();
  }
}
