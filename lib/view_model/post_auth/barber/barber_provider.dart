import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/reviews_barber.dart';
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

import '../../../models/artist_detail.dart';
import '../../../models/artist_model.dart';
import '../../../models/salon.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_response.dart';
import '../../../utils/access_token.dart';

class BarberProvider with ChangeNotifier {
  int _selectedArtistIndex = 0;

  List<Gender> _selectedGendersFilter = [];
  List<Services> _selectedServiceCategories = [];
  List<ServiceDetail> _serviceList = [];
  List<ServiceDetail> _filteredServiceList = [];
  // List<Review> _artistReviewList = [];

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
  Map<String, ServiceResponse> serviceDetailsMap =
      {}; // Use a map to store service details

  ArtistData? artistid;
  ApiResponse? _salonDetails; // Replace SalonDetails with your actual model

  ApiResponse? get salonDetails => _salonDetails;

  void setSalonDetails(ApiResponse salonDetails) {
    _salonDetails = salonDetails;
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

  Future<void> submitReview2(
    BuildContext context, {
    required int stars,
    required String text,
  }) async {
    String apiUrl = 'http://13.235.49.214:8800/partner/review/add';

    String? artistId = artistDetails?.id;

    // If salonId is null or empty, get it from the first booking in home provider
    if (artistId == null || artistId.isEmpty) {
      HomeProvider homeProvider =
          Provider.of<HomeProvider>(context, listen: false);
      if (homeProvider.previousBooking.isNotEmpty) {
        artistId =
            homeProvider.previousBooking.first.artistServiceMap.first.artistId;
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
      dio.interceptors.add(LogInterceptor(
          requestBody: true, responseBody: true, logPrint: print));

      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        Loader.hideLoader(
            context); // Handle the case where the user is not authenticated
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
  void setSelectedServiceCategories(
      {required Services selectedServiceCategory}) {
    _selectedServiceCategories.contains(selectedServiceCategory)
        ? _selectedServiceCategories.removeWhere(
            (serviceCategory) => serviceCategory == selectedServiceCategory)
        : _selectedServiceCategories.add(selectedServiceCategory);
    filterSalonServices(serviceCategoryFiltersApplied: true);
    notifyListeners();
  }

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

  Future<void> submitReview(
    BuildContext context, {
    required int stars,
    required String text,
  }) async {
    if (stars < 1) {
      ReusableWidgets.showFlutterToast(context, "Please add stars");
      return;
    }
    Loader.showLoader(context);
    Review review = Review(
      artistId: artist.id,
      artistName: artist.name,
      salonId: artist.salonId,
      salonName: artist.salonName,
      comment: text,
      createdAt: DateTime.now(),
      userId: context.read<HomeProvider>().userData.id,
      userName: context.read<HomeProvider>().userData.name,
      rating: stars.toDouble(),
    );

    try {
      await DatabaseService().addReview(reviewData: review).onError(
            (FirebaseException error, stackTrace) => throw ExceptionHandling(
              message: error.message ?? "",
            ),
          );
      context.read<HomeProvider>().reviewList.add(review);
      context.read<HomeProvider>().changeRatings(context);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
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

  void clearfilteredServiceList() {
    _filteredServiceList.clear();
    notifyListeners();
  }
}

class ReviewsProvider with ChangeNotifier {
  List<ReviewItem> reviews = [];

  Future<List<ReviewItem>> getReviewsApisArtist(String artistId) async {
    try {
      final String url =
          "http://13.235.49.214:8800/partner/review/artist/$artistId";
      final Dio dio = Dio();
      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      }
      final response = await dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        reviews = [];
        for (var e in response.data['data']) {
          reviews.add(ReviewItem.fromJson(jsonEncode(e)));
        }
        return reviews;
      } else {
        print("Review Response Code Error : ${response.data}");
        return [];
      }
    } catch (e) {
      print("Reviews Error :${e}");
      return [];
    }
  }

  Future<List<ReviewItem>> getReviewsApisSalon(String salonId) async {
    try {
      final String url =
          "http://13.235.49.214:8800/partner/review/salon/$salonId";
      final Dio dio = Dio();
      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      }
      final response = await dio.get(
        url,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        for (var e in response.data['data']) {
          reviews.add(ReviewItem.fromJson(jsonEncode(e)));
        }
        return reviews;
      } else {
        print("Review Response Code Error : ${response.data}");
        return [];
      }
    } catch (e) {
      print("Reviews Error :${e}");
      return [];
    }
  }
}
