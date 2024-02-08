import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/Profile_model.dart';
import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/review_barber.dart';
import '../../../models/salon.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_response.dart';
import '../../../utils/access_token.dart';

class BarberProvider with ChangeNotifier {
  int _selectedArtistIndex = 0;

  List<Gender> _selectedGendersFilter = [];
  List<Services> _selectedServiceCategories= [];
  List<ServiceDetail> _serviceList = [];
  List<ServiceDetail> _filteredServiceList = [];
  // List<Review> _artistReviewList = [];
  List<Service2> _selectedServices = [];
  List<Service2> get SelectedServices => _selectedServices;

  List<Service2> _filteredServices = [];
  List<Service2> get FilteredServices  => _filteredServices;
  Set<String> _selectedServiceCategories2 = {};
  Set<String> get selectedServiceCategories2  => _selectedServiceCategories2;

  List<String> _selectedGendersFilter2 = [];
  List<String> get selectedGendersFilter2 => _selectedGendersFilter2;

  // Other properties and methods as needed

  // Method to toggle selected service
  void toggleSelectedService(Service2 service) {
    if (_selectedServices.contains(service)) {
      _selectedServices.remove(service);
    } else {
      _selectedServices.add(service);
    }
    notifyListeners();
  }

  // Method to set filtered services
  void setFilteredServices(List<Service2> services) {
    _filteredServices = services;
    notifyListeners();
  }

  // Method to set selected service categories
  void setSelectedServiceCategories({required String selectedServiceCategory}) {
    if (_selectedServiceCategories2.contains(selectedServiceCategory)) {
      _selectedServiceCategories2.remove(selectedServiceCategory);
    } else {
      _selectedServiceCategories2.add(selectedServiceCategory);
    }
    notifyListeners();
  }
  void setSelectedGendersFilter2({required String selectedGender}) {
    if (selectedGender == 'both') {
      _selectedGendersFilter2.clear(); // Clear the filter if 'both' is selected
    } else {
      if (_selectedGendersFilter2.contains('both')) {
        _selectedGendersFilter2.remove('both');
      }
      if (_selectedGendersFilter2.contains(selectedGender)) {
        _selectedGendersFilter2.remove(selectedGender);
      } else {
        _selectedGendersFilter2.add(selectedGender);
      }
    }

    filterSalonServices(genderFiltersApplied: true);
    notifyListeners();
  }
  Artist _artist = Artist();
  SalonData _selectedSalonData = SalonData();
  bool _shouldSetArtistData = true;

  TextEditingController _searchController = TextEditingController();

  //============= GETTERS =============//
  int get selectedArtistIndex => _selectedArtistIndex;

  List<Gender> get selectedGendersFilter => _selectedGendersFilter;
  List<Services> get selectedServiceCategories => _selectedServiceCategories;
  List<ServiceDetail> get serviceList => _serviceList;
  List<ServiceDetail> get filteredServiceList => _filteredServiceList;
  // List<Review> get artistReviewList => _artistReviewList;

  Artist get artist => _artist;
  SalonData get selectedSalonData => _selectedSalonData;
  bool get shouldSetArtistData => _shouldSetArtistData;

  TextEditingController get searchController => _searchController;
  Data? _artistDetails; // Replace ArtistDetails with your actual model

  Data? get artistDetails => _artistDetails;
  Map<String, ServiceResponse> serviceDetailsMap = {}; // Use a map to store service details

  ArtistData? artistid;
  ApiResponse? _salonDetails; // Replace SalonDetails with your actual model

  ApiResponse? get salonDetails => _salonDetails;

  void setSalonDetails(ApiResponse salonDetails) {
    _salonDetails = salonDetails;
    notifyListeners();
  }
  Gender? selectedGender; // Variable to store selected gender
  List<Service2> filteredServices = []; // List to store filtered services

  // Function to set selected gender
  void setSelectedGender(Gender gender) {
    selectedGender = gender;
    notifyListeners();
  }




  void setArtistDetails(Data artistDetails) {
    _artistDetails = artistDetails;
    notifyListeners();
  }
  String? Servicetitle;
  String? salonName2;

  void initArtistData(BuildContext context) async {
    if (_shouldSetArtistData) {
      setArtistData(context);
    }
    await Future.wait([
      // getArtistReviewList(context),
      getServiceList(context),
    ]);
    _shouldSetArtistData = true;
  }

  Future<void> submitReview2( BuildContext context, {
    required int stars,
    required String text,
  }) async {
    String apiUrl = 'http://13.235.49.214:8800/partner/review/add';

    String? artistId = artistDetails?.id;

    // If salonId is null or empty, get it from the first booking in home provider
    if (artistId == null || artistId.isEmpty) {
      HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
      if (homeProvider.previousBooking.isNotEmpty) {
        artistId = homeProvider.previousBooking.first.artistServiceMap.first.artistId;
      }
    }

    if (artistId == null || artistId.isEmpty) {
      // Handle the case where salonId is still null or empty
      print("Salon ID is null or empty");
      return;
    }

    final Map<String, dynamic> requestData = {
      "title": "Review Artist",
      "description": text,
      "artistId": artistDetails?.id,
      "rating": stars
    };

    try {
      Loader.showLoader(context);
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        Loader.hideLoader(context); // Handle the case where the user is not authenticated
      }
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {"Content-Type": "application/json"}),
        data: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Review submitted successfully, handle the response data if needed
        print("Review submitted successfully!");
        print(response.data);
        Loader.hideLoader(context);
      } else {
        Loader.hideLoader(context);
        // Failed to submit the review, handle the error
        print("Failed to submit the review");
        print(response.data);
      }
    } catch (error) {
      Loader.hideLoader(context);
      // Handle any exceptions that occurred during the request
      print("Error: $error");
    }
  }

  /// Filter the [_filteredServiceList] according to the filters that the user
  /// has chosen
  void filterSalonServices({
    bool genderFiltersApplied = false,
    bool serviceCategoryFiltersApplied = false,
  }) {
    _filteredServiceList.clear();
    if (_selectedGendersFilter.isEmpty && _selectedServiceCategories.isEmpty) {
      _filteredServiceList.addAll(_serviceList);
    }

    if (_selectedGendersFilter.isNotEmpty) {
      _filteredServiceList.addAll(
        _serviceList.where(
          (service) => (_selectedGendersFilter.contains(service.targetGender)),
        ),
      );
    }

    if (_selectedServiceCategories.isNotEmpty) {
      _filteredServiceList.addAll(
        _serviceList.where(
          (service) => _selectedServiceCategories.contains(service.category),
        ),
      );
    }
    notifyListeners();
  }



  /// Set the value of [_selectedGendersFilter] according to the gender filter selected
  /// by user
  void setSelectedGendersFilter({required Gender selectedGender}) {
    _selectedGendersFilter.contains(selectedGender)
        ? _selectedGendersFilter
            .removeWhere((gender) => gender == selectedGender)
        : _selectedGendersFilter.add(selectedGender);

    filterSalonServices(genderFiltersApplied: true);
    notifyListeners();
  }

  /// Set the value of [_selectedServiceCategories] according to the service categories selected
  /// by the user

  /// Filter the [_filteredServiceList] according to the entered
  /// search text by the user
  void filterOnSearchText(String searchText) {
    _filteredServiceList.clear();
    _serviceList.forEach((service) {
      if (service.serviceTitle!
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        _filteredServiceList.add(service);
      }
    });
    notifyListeners();
  }

  /// Set the data of the selected [_artist]
  void setArtistData(
    BuildContext context, {
    Artist? artistData,
  }) {
    _artist = context.read<HomeProvider>().artistList[_selectedArtistIndex];
    notifyListeners();
  }

  /// Set the data of the selected [_artist] if the user selects the artist
  /// from [HomeScreen]
  void setArtistDataFromHome(Artist artistData) {
    _artist = artistData;
    _shouldSetArtistData = false;
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  // Future<void> getArtistReviewList(BuildContext context) async {
  //   Loader.showLoader(context);
  //   try {
  //     _artistReviewList =
  //         await DatabaseService().getArtistReviewList(_artist.id);
  //     Loader.hideLoader(context);
  //   } catch (e) {
  //     Loader.hideLoader(context);
  //     ReusableWidgets.showFlutterToast(context, '$e');
  //   }
  //   notifyListeners();
  // }

  /// Get the list of services provided by the selected salon
  Future<void> getServiceList(BuildContext context) async {
    try {
      _serviceList =
          await DatabaseService().getServiceListForArtist(_artist.id ?? '');
      _filteredServiceList.clear();
      _filteredServiceList.addAll(_serviceList);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  void getArtistSalonData(BuildContext context) async {
    int index = context
        .read<HomeProvider>()
        .salonList
        .indexWhere((element) => element.id == _artist.salonId);
    context.read<SalonDetailsProvider>().setSelectedSalonIndex(index);

    notifyListeners();
  }



  /// Set the index of selected artist
  void setSelectedArtistIndex(int artistIndex) {
    _selectedArtistIndex = artistIndex;
    notifyListeners();
  }

  /// Clear the value of [_selectedGendersFilter]
  void clearSelectedGendersFilter() {
    _selectedGendersFilter.clear();
    notifyListeners();
  }

  /// Clear the value of [_searchController]
  void clearSearchController() {
    _searchController.clear();
    notifyListeners();
  }

  /// Clear the value of [_selectedServiceCategories]
  void clearSelectedServiceCategories() {
    _selectedServiceCategories.clear();
    notifyListeners();
  }
  void clearfilteredServiceList () {
    _filteredServiceList.clear();
    notifyListeners();
  }
}
class ReviewsProvider with ChangeNotifier {
  final Dio _dio = Dio(); // Initialize Dio instance
  List<Review> reviews = []; // Add a property to store reviews
List <SalonReview> salonReviews = [];

  Future<void> fetchReviews(String artistId) async {
    try {


        Options options = Options(
          validateStatus: (status) {
            return status == 200 || status == 404;
          },
        );

        // Make the GET request
        Response response = await _dio.get(
          'http://13.235.49.214:8800/partner/review/artist/$artistId',
          options: options,
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;

          ReviewBarber reviewBarber = ReviewBarber.fromJson(responseData);
          reviews = reviewBarber.data.map((datum) => datum.review).toList();

          for (var artistReview in reviewBarber.data) {
            var userId = artistReview.review.userId;
            var artistReviewResponse = await Dio().get(
                'http://13.235.49.214:8800/customer/user/$userId');

            dynamic reviewResponse = ProfileResponse.fromJson(
                artistReviewResponse.data).data.name;

            artistReview.review.setArtistName(reviewResponse);
          }
        } else if (response.statusCode == 404) {
          // Handle the case when no reviews are found
          reviews = []; // or leave reviews as is, depending on your use case
          print('No reviews found for the artist.');
        }
        else {
          print('Error: ${response.statusCode}');
        }

    } catch (error) {
      // Handle any Dio errors
      print('Dio Error: $error');
    }
    notifyListeners(); // Notify listeners after updating reviews
  }


  Future<void> fetchSalonReviews(String salonId) async {

    try {
        Options options = Options(
          validateStatus: (status) {
            return status == 200 || status == 404; // Include status code 404 as valid
          },
        );
        // Make the GET request
        Response response = await _dio.get(
          'http://13.235.49.214:8800/partner/review/salon/$salonId',
          options: options,
        );
        if (response.statusCode == 200) {
          SalonReviewBarber salonBarber = SalonReviewBarber.fromJson(response.data);
          salonReviews = salonBarber.data.map((salonDatum) => salonDatum.salonreview).toList();

          // Fetch user names for all salon reviews
          for (var salonReview in salonBarber.data) {
            var userId = salonReview.salonreview.userId;
            var salonReviewResponse = await Dio().get('http://13.235.49.214:8800/customer/user/$userId');
            dynamic salonReviewsResponse = ProfileResponse.fromJson(salonReviewResponse.data).data.name;

            salonReview.salonreview.setUserName(salonReviewsResponse);
          }

          // Fetch artist names for all salon reviews
          for (var salonReview in salonBarber.data) {
            var artistId = salonReview.salonreview.artistId;
            var salonReviewResponse = await Dio().get('http://13.235.49.214:8800/partner/artist/single/$artistId');
            dynamic salonReviewsResponse = ArtistResponse.fromJson(salonReviewResponse.data).data.name;

            salonReview.salonreview.setArtistName(salonReviewsResponse);
          }
        }

        else if (response.statusCode == 404) {
          // Handle the case when no reviews are found
          salonReviews = []; // or leave reviews as is, depending on your use case
          print('No reviews found for the artist.');
        }
        else {
          print('Error: ${response.statusCode}');
        }
    } catch (error) {
      // Handle any Dio errors
      print('Dio Error: $error');
    }
    notifyListeners();
  }
}