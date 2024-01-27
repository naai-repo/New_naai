import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/user.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/api_constant.dart';
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
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../models/allbooking.dart';
import '../../../models/artist_model.dart';
import '../../../models/review.dart';
import '../../../models/salon_model.dart';
import '../../../models/service_detail.dart';
import '../../../utils/access_token.dart';
import '../../pre_auth/loginResult.dart';

class HomeProvider with ChangeNotifier {
  bool _changedLocation = false;
  final Dio dio = Dio();
 // Use the phone number from the response
  final _mapLocation = location.Location();
  late LatLng _userCurrentLatLng;

  String userAddress = 'No Location Found';


  location.Location get mapLocation => _mapLocation;
  LatLng get userCurrentLatLng => _userCurrentLatLng;

  List<SalonData> _salonList = [];
  List<SalonData2> _salonList2 = [];
  List<ArtistData> _artistList2 = [];
  List<Artist> _artistList = [];
  List<Review> _allReviewList = [];
  List<ServiceDetail> _services = [];

  late Symbol _symbol;
  Position ? position;
String ?  _addressText;
  late MapboxMapController _controller;

 // String _addressText = StringConstant.loading;
  List<ServiceDetail> get filteredServiceList => _filteredServiceList;
  List<ServiceDetail> _filteredServiceList = [];

  TextEditingController _mapSearchController = TextEditingController();

  UserModel _userData = UserModel();


  List<Booking> _lastOrNextBooking = [];
  List<Booking> _allBookings = [];

  List<AllBooking> _upcomingBooking = [];
  List<AllBooking> _previousBooking = [];

  //============= GETTERS =============//
  List<SalonData> get salonList => _salonList;
  List<SalonData2> get salonList2 => _salonList2;
  List<ArtistData> get artistList2 => _artistList2;
  List<Artist> get artistList => _artistList;
  List<Review> get reviewList => _allReviewList;
  List<ServiceDetail> get service => _services;

  String? get addressText => _addressText;

  TextEditingController get mapSearchController => _mapSearchController;

  UserModel get userData => _userData;
  ArtistData get artistData => artistData;

  List<Booking> get lastOrNextBooking => _lastOrNextBooking;
  List<Booking> get allBookings => _allBookings;



  List<AllBooking> get upcomingBooking => _upcomingBooking;
  List<AllBooking> get previousBooking => _previousBooking;
  int displayedSalonCount = 5; // Number of salons to display initially
  int displayedArtistCount = 5;
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
  List<ArtistData> getDisplayedArtists() {
    // Logic to return the currently displayed artists
    return artistList2.take(displayedArtistCount).toList();
  }

  bool shouldShowArtistLoadButton() {
    // Logic to determine whether to show the load more button for artists
    return displayedArtistCount < artistList2.length && artistList2.isNotEmpty;
  }

  void loadMoreArtists() {
    // Logic to load more artists
    // For demonstration purposes, we'll add dummy data here
    //  artistList.addAll(getDummyArtists());
    displayedArtistCount += 5; // Increase the count to show the newly loaded artists
    notifyListeners();
  }
  List<SalonData2> getDisplayedSalons() {
    // Logic to return the currently displayed salons
    return salonList2.take(displayedSalonCount).toList();

  }
  bool shouldShowLoadButton() {
    return displayedSalonCount < salonList2.length && salonList2.isNotEmpty;
  }
  void loadMoreSalons() {
    displayedSalonCount += 5;
    notifyListeners();
  }

  set salonList2(List<SalonData2> value) {
    _salonList2 = value;
    notifyListeners();
  }

  set artistList2(List<ArtistData> value) {
    _artistList2 = value;
    notifyListeners();
  }

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      const SymbolOptions(),
    );
  }
  bool _isSearchExpanded = false;

  bool get isSearchExpanded => _isSearchExpanded;

  set isSearchExpanded(bool value) {
    _isSearchExpanded = value;
    notifyListeners();
  }
  /// Method to trigger all the API functions of home screen

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

  Future<void> DiscountFilterforWomen(BuildContext context) async {
    Loader.showLoader(context);

    try {
      Position currentLocation = await Geolocator.getCurrentPosition();
      print('Current Location: ${currentLocation.longitude}, ${currentLocation.latitude}');
      userAddress = await getAddress(currentLocation.latitude, currentLocation.longitude);

      await getDistanceAndRatingForWomen(coords: [currentLocation.longitude, currentLocation.latitude]);

    } catch (e) {
      Loader.hideLoader(context);
      print("Error getting location: $e");

      await handleFallbackLocationForWomen(context);
    }

    Loader.hideLoader(context);
  }

  Future<void> handleFallbackLocationForWomen(BuildContext context) async {
    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    double savedLatitude = box.get('savedLatitude') ?? 0.0;
    double savedLongitude = box.get('savedLongitude') ?? 0.0;

    if (savedLatitude != 0.0 && savedLongitude != 0.0) {
      print('Using saved coordinates: $savedLongitude, $savedLatitude');
      userAddress = await getAddress(savedLatitude, savedLongitude);

      await getDistanceAndRatingForWomen(coords:[savedLongitude, savedLatitude]);
      Loader.hideLoader(context);
    } else {
      Loader.hideLoader(context);
      print('No location information available.');
    }
  }

  Future<void> handleFallbackLocationForMen(BuildContext context) async {
    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    double savedLatitude = box.get('savedLatitude') ?? 0.0;
    double savedLongitude = box.get('savedLongitude') ?? 0.0;

    if (savedLatitude != 0.0 && savedLongitude != 0.0) {
      print('Using saved coordinates: $savedLongitude, $savedLatitude');
      userAddress = await getAddress(savedLatitude, savedLongitude);

      await getDistanceAndRatingForMen(coords:[savedLongitude, savedLatitude]);
      Loader.hideLoader(context);
    } else {
      Loader.hideLoader(context);
      print('No location information available.');
    }
  }

  Future<void> DiscountFilterforMen(BuildContext context) async {

    Loader.showLoader(context);
    try {
      Position currentLocation = await Geolocator.getCurrentPosition();
      print(
          'Current Location: ${currentLocation.longitude}, ${currentLocation
              .latitude}');
      userAddress =
      await getAddress(currentLocation.latitude, currentLocation.longitude);
      print('Addressssss: $userAddress');
      await Future.wait([
        getDistanceAndRatingForMen(coords: [currentLocation.longitude, currentLocation.latitude]),
      ]);
    } catch (e) {
      Loader.hideLoader(context);
      print("Error getting location: $e");
      await handleFallbackLocationForMen(context);
    }
    Loader.hideLoader(context);
  }

  bool _locationPopupShown = false;
  bool get isLocationPopupShown => _locationPopupShown;

  Future<void> initHome(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_locationPopupShown) {
      await locationPopUp(context);
      _locationPopupShown = true;
    }

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
      if (!_serviceEnabled) return;
    }

    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted != location.PermissionStatus.granted) {
      // Handle the case when user denies location permission
      print("User denied permissions to access the device's location.");
      await loadSavedCoordinates(context); // Load and use saved coordinates
      return;
    }

    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';

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
        getAppointments(),
        // Additional asynchronous tasks based on location
      ]);

    } catch (e) {
      Loader.hideLoader(context);
      print("Error getting location: $e");
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
        getAppointments(),
        // Additional asynchronous tasks based on location
      ]);
    } else {
      // Handle the case when both current location and saved coordinates are not available
      print('No location information available.');
    }
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

  Future<void> getDistanceAndRatingForWomen({required List<double> coords}) async {
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
        print("Top salon discount: ${response.data}");
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

  Future<void> getDistanceAndRatingForMen({required List<double> coords}) async {
    final apiUrl = UrlConstants.discountAndRatingForMen;

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
        // Handle successful response for top artists
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


  Future locationPopUp(BuildContext context) async {
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      await showModalBottomSheet(isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        "Set your location to Start \n exploring\n salons near you",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/loc_image.png'),
                  const SizedBox(height: 20),
                  Column(
                    children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text(
                              "Enable Device Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsConstant.appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side:BorderSide(color: ColorsConstant.appColor),
                            ),
                            onPressed: () async {
                              await Geolocator.requestPermission();
                            //  _mapLocation.requestService();
                         //    await _mapLocation.requestPermission();
                                Navigator.pop(context);

                            },
                          ),
                        ),
                      ],
                    ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                "Enter your Location Manually",
                                style: TextStyle(
                                  color: ColorsConstant.appColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                 Navigator.pop(context);
                                 Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute);
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future locationPopUp2(BuildContext context) async {
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        "Set your location to Start \n exploring\n salons near you",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/loc_image.png'),
                  const SizedBox(height: 20),
                  Column(
                    children:[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                "Enable Device Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsConstant.appColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await Geolocator.requestPermission();
                                //  _mapLocation.requestService();
                                //    await _mapLocation.requestPermission();
                                Navigator.pop(context);

                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                "Enter your Location Manually",
                                style: TextStyle(
                                  color: ColorsConstant.appColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute2);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }


  Future<void> getAppointments() async {
    final String apiUrl = 'http://13.235.49.214:8800/appointments/user/bookings';
    String? bearerToken =  await AccessTokenManager.getAccessToken();

    try {
      Dio dio = Dio();

      dio.options.headers['Authorization'] = 'Bearer $bearerToken';

      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        // Successfully fetched data
        print('Response: ${response.data}');

        // Parse JSON and convert it into Dart objects
        AllBooking userBookings = AllBooking.fromJson(response.data);

        // Accessing the parsed data
        print('User ID: ${userBookings.userId}');
        print('Current Bookings:');
        for (var booking in userBookings.currentBookings) {
          print('${booking.id} - ${booking.bookingDate}');
        }

        print('Previous Bookings:');
        for (var booking in userBookings.prevBooking) {
          print('${booking.id} - ${booking.bookingDate}');
        }

        print('Coming Bookings:');
        for (var booking in userBookings.comingBookings) {
          print('${booking.id} - ${booking.bookingDate}');
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}, ${response.data}');
      }
    } catch (error) {
      // Handle DioError or other exceptions
      print('Error: $error');
    }
  }

  Future<void> initHome2(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_locationPopupShown) {
      await locationPopUp2(context);
      _locationPopupShown = true;
    }

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
      if (!_serviceEnabled) return;
    }

    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted != location.PermissionStatus.granted) {
      // Handle the case when user denies location permission
      print("User denied permissions to access the device's location.");
      await loadSavedCoordinates(context); // Load and use saved coordinates
      return;
    }

    Loader.showLoader(context);
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';

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
        getAppointments(),
        // Additional asynchronous tasks based on location
      ]);

    } catch (e) {
      Loader.hideLoader(context);
      print("Error getting location: $e");
    }

    Loader.hideLoader(context);
  }


  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getUserDetails(BuildContext context) async {
    try {
      _userData = await DatabaseService().getUserDetails();
    } catch (e) {
    //  ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getAllArtists(BuildContext context) async {
    try {
      _artistList = await DatabaseService().getAllArtists();
      _artistList.sort((a, b) => ((a.rating ?? 0) - (b.rating ?? 0)).toInt());
      context.read<ExploreProvider>().setArtistList(_artistList);
    } catch (e) {
     // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  Future<void> getAllReviews(context) async {
    try {
      _allReviewList = await DatabaseService().getAllReviews();
    } catch (e) {
     // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the booking details of user from [FirebaseFirestore]
  Future<void> getUserBookings(BuildContext context) async {
    try {
      List<Booking> response =
      await DatabaseService().getUserBookings(userId: userData.id ?? '');
      _allBookings = response;
      _lastOrNextBooking.clear();
      for (int i = 0; i < response.length; i++) {
        if (DateTime.parse(response[i].bookingCreatedFor ?? '')
            .isAfter(DateTime.now())) {
          _lastOrNextBooking.add(response[i]);
          if (_salonList.isNotEmpty) {
            _lastOrNextBooking.last.salonName = _salonList
                .firstWhere(
                    (element) => element.id == _lastOrNextBooking.last.salonId)
                .name;
          }
          _lastOrNextBooking.last.createdOnString =
              getTimeAgoString(_lastOrNextBooking.last.bookingCreatedOn);
          if (_artistList.isNotEmpty) {
            _lastOrNextBooking.last.artistName = _artistList
                .firstWhere(
                    (element) => element.id == _lastOrNextBooking.last.artistId)
                .name;
          }
          _lastOrNextBooking.last.isUpcoming = true;
        }
      }

      if (_lastOrNextBooking.isEmpty && response.isNotEmpty) {
        _lastOrNextBooking.add(response.last);
        _lastOrNextBooking.last.isUpcoming = false;
        if (_salonList.isNotEmpty) {
          _lastOrNextBooking.last.salonName = _salonList
              .firstWhere(
                  (element) => element.id == _lastOrNextBooking.last.salonId)
              .name;
        }
        _lastOrNextBooking.last.createdOnString =
            getTimeAgoString(_lastOrNextBooking.last.bookingCreatedOn);
        if (_artistList.isNotEmpty) {
          _lastOrNextBooking.last.artistName = _artistList
              .firstWhere(
                  (element) => element.id == _lastOrNextBooking.last.artistId)
              .name;
        }
      }
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }


  String getTimeAgoString(String? dateTimeString) {
    DateTime dateTime =
    DateTime.parse(dateTimeString ?? DateTime.now().toString());
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final daysAgo = difference.inDays;
    final weeksAgo = daysAgo ~/ 7;
    final monthsAgo =
        (now.year * 12 + now.month) - (dateTime.year * 12 + dateTime.month);

    if (monthsAgo >= 1) {
      return '$monthsAgo Month${monthsAgo > 1 ? 's' : ''} Ago';
    } else if (weeksAgo >= 1) {
      return '$weeksAgo Week${weeksAgo > 1 ? 's' : ''} Ago';
    } else if (daysAgo >= 1) {
      return '$daysAgo Day${daysAgo > 1 ? 's' : ''} Ago';
    } else {
      return 'Today';
    }
  }

  /// Fetch the service names from [FirebaseFirestore]
  Future<void> getServicesNamesAndPrice(BuildContext context) async {
    try {
      var response = await DatabaseService().getAllServices();
      for (int i = 0; i < _lastOrNextBooking.length; i++) {
        _lastOrNextBooking[i].bookedServiceNames = [];
        response.forEach((element) {
          if (_lastOrNextBooking[i].serviceIds?.contains(element.id) == true) {
            _lastOrNextBooking[i]
                .bookedServiceNames
                ?.add(element.serviceTitle ?? '');
            _lastOrNextBooking[i].totalPrice += element.price ?? 0;
          }
        });
      }
    } catch (e) {
      // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Initialising map related values as soon as the map is rendered on screen.
  Future<void> onMapCreated(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    this._controller = mapController;
/*
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    */
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      LatLng dummyLocation = LatLng(28.7383,77.0822); // Set your desired dummy location
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: dummyLocation,
            zoom: 10,
          ),
        ),
      );
      return; // Exit the method
    }
    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation();

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


  }

  Future<void> onMapCreated2(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    this._controller = mapController;

    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      LatLng dummyLocation = LatLng(28.7383,77.0822); // Set your desired dummy location
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: dummyLocation,
            zoom: 10,
          ),
        ),
      );
      return; // Exit the method
    }
    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation();

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

  Future<void> getFormattedAddressConfirmation({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    Loader.showLoader(context);

    _addressText = await UtilityFunctions.getAddressCoordinateAndFormatAddress(
      context: context,
      latLng: coordinates,
    );
    await saveCoordinatesToHive(coordinates);

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
              _addressText??'',
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
              onPressed: () async {
                final box = await Hive.openBox('userBox');
                String userId = box.get('userId') ?? '';
               if (userId.isEmpty) {
             userId = '659e565fedf72717a11caf27';
             await box.put('userId', userId);
    }Loader.showLoader(context);
                  await updateUserLocation(
                    userId: userId,
                    coords: [coordinates.longitude, coordinates.latitude],
                  );
                userAddress =
                await getAddress(coordinates.latitude, coordinates.longitude);
                await Future.wait([
                  getTopSalons(
                      coords: [coordinates.longitude, coordinates.latitude]),
                  getTopArtists(
                      coords: [coordinates.longitude, coordinates.latitude]),
                  //  getDistanceAndRating(coords: [currentLocation.longitude, currentLocation.latitude]),
                  //  getArtistRating(coords: [currentLocation.longitude, currentLocation.latitude]),
                ]);
                Loader.hideLoader(context);
                  Navigator.pushNamed(
                      context, NamedRoutes.bottomNavigationRoute3);
              },
              child: const Text(StringConstant.confirmLocation),
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

  Future<void> getFormattedAddressConfirmation2({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    Loader.showLoader(context);

    _addressText = await UtilityFunctions.getAddressCoordinateAndFormatAddress(
      context: context,
      latLng: coordinates,
    );
    await saveCoordinatesToHive(coordinates);

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
              _addressText??'',
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
              onPressed: () async {
                final box = await Hive.openBox('userBox');
                String userId = box.get('userId') ?? '';
                if (userId.isEmpty) {
                  userId = '659e565fedf72717a11caf27';
                  await box.put('userId', userId);
                }
                Loader.showLoader(context);
                await updateUserLocation(
                  userId: userId,
                  coords: [coordinates.longitude, coordinates.latitude],
                );
                Loader.hideLoader(context);
                await Future.wait([
                  getTopSalons(
                      coords: [coordinates.longitude, coordinates.latitude]),
                  getTopArtists(
                      coords: [coordinates.longitude, coordinates.latitude]),
                  //  getDistanceAndRating(coords: [currentLocation.longitude, currentLocation.latitude]),
                  //  getArtistRating(coords: [currentLocation.longitude, currentLocation.latitude]),
                ]);
                Navigator.pushNamed(
                    context, NamedRoutes.bottomNavigationRoute4);
              },
              child: const Text(StringConstant.confirmLocation),
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

  Future<void> saveCoordinatesToHive(LatLng coordinates) async {
    final box = await Hive.openBox('userBox');
    await box.put('savedLatitude', coordinates.latitude);
    await box.put('savedLongitude', coordinates.longitude);
  }

  Future<void> onMapClick2({
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

    await getFormattedAddressConfirmation2(
      context: context,
      coordinates: coordinates,
    );
    notifyListeners();
  }

  /// Get complete address from the provided coordinates
  /// Format the address according to the need.
  /// Show a bottom sheet with the formatted address text and a button to confirm
  /// the new address.


  /// Method to fetch the current location of the user using [location] package
  Future<LatLng> fetchCurrentLocation(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      await openAppSettings();
      throw Exception('Location permission denied');

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

  void populateBookingData(BuildContext context, int index) async {
    await context.read<SalonDetailsProvider>().getSalonData(
      context,
      salonId: _lastOrNextBooking[index].salonId!,
    );

    await context.read<SalonDetailsProvider>().getArtistList(context);
    await context.read<SalonDetailsProvider>().getServiceList(context);

    context.read<SalonDetailsProvider>().setServiceIds(
      ids: _lastOrNextBooking[index].serviceIds!,
      totalPrice: _lastOrNextBooking[index].totalPrice,
    );

    context
        .read<SalonDetailsProvider>()
        .setStaffSelectionMethod(selectedSingleStaff: true);

    context.read<SalonDetailsProvider>().setBookingData(
      context,
      setArtistId: true,
      artistId: _lastOrNextBooking[index].artistId,
    );
    Navigator.pushNamed(
      context,
      NamedRoutes.createBookingRoute,
    );
  }

  /// Get date in the format [Month Date], abbreviated day of week or time schedule
  /// of the booking.
  String getFormattedDateOfBooking({
    bool getFormattedDate = false,
    bool getAbbreviatedDay = false,
    bool getTimeScheduled = false,
    bool getFullDate = false,
    bool secondaryDateFormat = false,
    String? dateTimeString,
    required int index,
  }) {
    DateTime dateTime =
    DateTime.parse(dateTimeString ?? DateTime.now().toString());
    _lastOrNextBooking[index].bookingCreatedFor ?? DateTime.now().toString();
    if (getFormattedDate) {
      return DateFormat('MMM dd').format(dateTime);
    } else if (getAbbreviatedDay) {
      return DateFormat('EEE').format(dateTime);
    } else if (getTimeScheduled) {
      return getTimeRangeString(_lastOrNextBooking[index].startTime ?? 0,
          _lastOrNextBooking[index].endTime ?? 0);
    } else if (getFullDate) {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } else {
      return DateFormat('dd MMMM yyyy').format(dateTime);
    }
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

  String getTimeRangeString(int startTime, int endTime) {
    String formattedStartTime = formatTime(startTime);
    String formattedEndTime = formatTime(endTime);

    return '$formattedStartTime - $formattedEndTime';
  }

  /// Get the address text from the user's home location
  String? getHomeAddressText() {
    return userData.homeLocation?.addressString ;
  }
  String? getDummyHomeAddressText() {
    return userData.homeLocation?.addressString??"Your Location will be show when you Sign In" ;
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

  Future<List<Review>> getUserReviews() async {
    return await DatabaseService().getUserReviewsList(userData.id);
  }

  void changeRatings(BuildContext context, {bool notify = false}) {
    salonList.forEach((salon) {
      num average = salon.originalRating ?? 0;
      final allReviews = _allReviewList.where(
            (review) => review.salonId == salon.id,
      );
      allReviews.forEach((review) {
        average += review.rating ?? 0;
      });
      average /= (allReviews.length + 1);
      final allArtist = artistList.where(
            (artist) => artist.salonId == salon.id,
      );
      allArtist.forEach((artist) {
        average += artist.originalRating ?? 0;
      });
      average /= (allArtist.length + 1);
      salon.rating = average;
    });
    artistList.forEach((artist) {
      double average = artist.originalRating ?? 0;
      final allReviews = _allReviewList.where(
            (review) => review.artistId != null && review.artistId == artist.id,
      );
      allReviews.forEach((review) {
        average += review.rating ?? 0;
      });
      average /= (allReviews.length + 1);
      artist.rating = average;
    });
    if (notify) notifyListeners();
  }

  void addReview(Review review) {
    _allReviewList.add(review);
  }
}