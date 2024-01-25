
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/Time_Slot_model.dart';
import '../../../models/artist_detail.dart';
import '../../../models/artist_services.dart';
import '../../../models/salon_detail.dart';
import '../../../models/service_response.dart';
import '../../../utils/access_token.dart';

class SalonDetailsProvider with ChangeNotifier {
  List<String> _imageList = [];
  final Dio dio = Dio();
  List<Gender> _selectedGendersFilter = [];
  List<Services> _selectedServiceCategories = [];
  List<ServiceDetail> _serviceList = [];
  DataService? serviceDetail;
  // List<Review> _salonReviewList = [];
  List<ServiceDetail> _filteredServiceList = [];
  List<Artist> _artistList = [];
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  //List<String> _currentBooking.serviceIds = [];

  /// Used to display artist's availability
  List<int> _artistAvailabilityToDisplay = [];

  /// Used to calculate the start and end time of a service for a given artist
  List<int> _artistAvailabilityForCalculation = [];

  /// Used to store the total availability of the artist for a given day
  List<int> _initialAvailability = [];

  int _selectedSalonIndex = 0;
  double _totalPrice = 0;
  double _showPrice = 0;

  Booking _currentBooking = Booking();

  // TODO: Change this to [false] once multiple artist booking method is finished
  bool _selectedSingleStaff = true;
  bool _selectedMultipleStaff = false;

  bool _selectedMultipleServices = false; //for multiple services added

  bool _isOnSelectStaffType = true;
  bool _isOnSelectSlot = false;
  bool _isOnPaymentPage = false;
  bool _isNextButtonActive = false;

  SalonData _selectedSalonData = SalonData();

  TextEditingController _searchController = TextEditingController();

  PageController _salonImageCarouselController = PageController();

  //============= GETTERS =============//
  List<Artist> get artistList => _artistList;

  List<Gender> get selectedGendersFilter => _selectedGendersFilter;

  List<Services> get selectedServiceCategories => _selectedServiceCategories;

  List<ServiceDetail> get serviceList => _serviceList;

  List<ServiceDetail> get filteredServiceList => _filteredServiceList;

  // List<Artist> get artistList => _artistList;
  // List<Review> get salonReviewList => _salonReviewList;
  // List<String> get selectedServices => _currentBooking.serviceIds;
  List<String> get imageList => _imageList;

  List<int> get artistAvailabilityToDisplay => _artistAvailabilityToDisplay;

  List<int> get artistAvailabilityForCalculation =>
      _artistAvailabilityForCalculation;

  List<int> get initialAvailability => _initialAvailability;

  int get selectedSalonIndex => _selectedSalonIndex;

  double get totalPrice => _totalPrice;

  double get showPrice => _showPrice;

  Booking get currentBooking => _currentBooking;

  bool get isOnSelectStaffType => _isOnSelectStaffType;

  bool get isOnSelectSlot => _isOnSelectSlot;

  bool get isOnPaymentPage => _isOnPaymentPage;

  bool get selectedSingleStaff => _selectedSingleStaff;

  bool get selectedMultipleStaff => _selectedMultipleStaff;

  bool get selectedMultipleServices =>
      _selectedMultipleServices; // added for getting multiple services
  bool get isNextButtonActive => _isNextButtonActive;

  SalonData get selectedSalonData => _selectedSalonData;

  TextEditingController get searchController => _searchController;

  PageController get salonImageCarouselController =>
      _salonImageCarouselController;
  String? _salonId;

  String? get salonId => _salonId;

  ApiResponse? _salonDetails; // Replace SalonDetails with your actual model

  ApiResponse? get salonDetails => _salonDetails;

  TimeSlotResponse? _timeslot;

  TimeSlotResponse? get timeslot => _timeslot;


  ServiceResponse? _serviceData;
  ServiceResponse? get serviceData => _serviceData;

  Data? _artistDetail;

  Data? get artistDetail => _artistDetail;

  Data? salonid;

  void setSalonDetails(ApiResponse salonDetails) {
    _salonDetails = salonDetails;
    notifyListeners();
  }

  void setTimeSlot(TimeSlotResponse timeslot) {
    _timeslot = timeslot;
    notifyListeners();
  }

  String? _selectedTime;
  String? get selectedTime => _selectedTime;

  void setSelectedTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }
  void setServiceDetails(ServiceResponse serviceData) {
    _serviceData = serviceData;
    notifyListeners();
  }

  ArtistServiceList? artistServiceList;


  Future<void> fetchArtistListAndNavigate(context, String salonId, List<String> selectedServiceIds) async {
    try {
      Loader.showLoader(context);
      final response = await Dio().post(
        'http://13.235.49.214:8800/appointments/singleArtist/list',
        data: {
          "salonId": salonId,
          "services": selectedServiceIds,
        },
      );
      Loader.hideLoader(context);

      if (response.statusCode == 200) {
        artistServiceList = ArtistServiceList.fromJson(response.data);
        // Check the length of selectedServiceIds
        if (selectedServiceIds.length == 1) {
          // Navigate to createBookingRoute if there is only one service
          Navigator.pushNamed(
            context,
            NamedRoutes.createBookingRoute3,
            arguments: {
              'salonId': salonId,
              'selectedServiceIds': selectedServiceIds,
            },
          );
        } else {
          // Navigate to createBooking3Route if there are multiple services
          Navigator.pushNamed(
            context,
            NamedRoutes.createBookingRoute,
            arguments: {
              'salonId': salonId,
              'selectedServiceIds': selectedServiceIds,
            },
          );
        }
      } else {
        // Handle other status codes
        print('Failed to fetch artist list: ${response.statusCode}');
      }
    } catch (error) {
      Loader.hideLoader(context);
      // Handle errors
      print('Failed to fetch artist list: $error');
    }
  }


  Future<void> submitReview2( BuildContext context, {
    required int stars,
    required String text,
  }) async {
    final Dio dio = Dio();

    final Map<String, dynamic> requestData = {
      "title": "Review Salon",
      "description": text,
      "salonId": salonid,
      "rating": stars
    };

    try {
      Loader.showLoader(context);

      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken == null) {
        Loader.hideLoader(context);
        print("Access token not found. User may not be authenticated.");
        // Handle the case where the user is not authenticated
        return;
      }

      // Include Bearer token in the headers
      dio.options.headers["Authorization"] = "Bearer $authToken";


      final response = await dio.post(
        'http://13.235.49.214:8800/partner/review/add',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: json.encode(requestData),
      );
      Loader.hideLoader(context);
      if (response.statusCode == 200) {
        // Review submitted successfully, handle the response data if needed
        print("Review submitted successfully!");
        print(response.data);
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


  void setApiResponse(ApiResponse apiResponse) {
    ApiResponse salonDetails = ApiResponse(
      status: apiResponse.status,
      message: apiResponse.message,
      data: ApiResponseData(
        data: apiResponse.data.data,
        artists: apiResponse.data.artists,
        services: apiResponse.data.services,
      ),
    );
    setSalonDetails(salonDetails);
  }

  String? Servicetitle;

  Future<void> fetchData() async {
    try {
      final response = await Dio().get(
        'http://13.235.49.214:8800/partner/service/single/${salonid!.salonId}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'];
        final String title = data['serviceTitle'];
        Servicetitle = title;
        print('titleis $title');
      } else {
        // Handle other status codes
        print('Failed to fetch service title: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors
      print('Failed to fetch service title: $error');
    }
  }
  Set<DataService> _selectedServices = Set<DataService>();
  Set<Service2> _barberselectedServices = Set<Service2>();
  Set<DataService> getSelectedServices() => _selectedServices;

  Set<Service2> barbergetSelectedServices() => _barberselectedServices;

  void toggleSelectedService(DataService service) {
    if (_selectedServices.contains(service)) {
      _selectedServices.remove(service);
    } else {
      _selectedServices.add(service);
    }
    _totalPrice = calculateTotalPrice();
    // Recalculate show price if a discount is applied
    setShowPrice(_totalPrice, _salonDetails?.data.data.discount ?? 0);

    notifyListeners();
  }

  void toggleSelectedServicebarber(Service2 service) {
    if ( _barberselectedServices.contains(service)) {
      _barberselectedServices.remove(service);
    } else {
      _barberselectedServices.add(service);
    }
    _totalPrice = calculateTotalPrice();
    // Recalculate show price if a discount is applied
    setShowPrice(_totalPrice, _salonDetails?.data.data.discount ?? 0);

    notifyListeners();
  }

  /// Initialise the salon details screen
  void initSalonDetailsData(BuildContext context) async {
    Loader.showLoader(context);
    setSelectedSalonData(context);
    await getImageList(context, _selectedSalonData.id!);
    await getArtistList(context);
    await Future.wait([
      getServiceList(context),
      // getSalonReviewsList(context),
    ]).onError(
          (error, stackTrace) =>
          ReusableWidgets.showFlutterToast(context, '$error'),
    );

    Loader.hideLoader(context);
  }
  void setShowPrice(double totalPrice, num discountPercentage) {
    _showPrice = totalPrice - (totalPrice * discountPercentage/100);
  }

  double calculateTotalPrice() {
    // Calculate total price by summing up the base prices of selected services
    return _selectedServices.fold(0.0, (sum, service) => sum + service.basePrice);
  }
  /// Get details related to a given service.
  dynamic getServiceDetails({
    required String serviceId,
    bool getServiceName = false,
    bool getServiceCharge = false,
    bool getGender = false,
  }) {
    ServiceDetail? service =
    _serviceList.firstWhere((element) => element.id == serviceId);
    if (getServiceCharge) {
      return service.price;
    }
    if (getServiceName) {
      return service.serviceTitle;
    }
    if (getGender) {
      return service.targetGender;
    }
  }

  /// Update the state of the next button on booking flow
  void updateIsNextButtonActive() {
    if ((_isOnSelectStaffType && _currentBooking.artistId != null) ||
        (_isOnSelectSlot &&
            _currentBooking.startTime != null &&
            _currentBooking.endTime != null)) {
      _isNextButtonActive = true;
    } else {
      _isNextButtonActive = false;
    }

    notifyListeners();
  }

  /// Set the type of staff selection method
  void setStaffSelectionMethod({required bool selectedSingleStaff}) {
    _selectedSingleStaff = selectedSingleStaff;
    _selectedMultipleStaff = !selectedSingleStaff;
    notifyListeners();
  }

  /// Get the name of the artist whose [artistId] is given
  String getSelectedArtistName(String artistId, BuildContext context) {
    return context
        .read<HomeProvider>()
        .artistList2
        .firstWhere((element) => element.id == artistId)
        .name ??
        '';
  }

  String getSelectedMultipleArtistName(String artistId, BuildContext context) {
    return context
        .read<HomeProvider>()
        .artistList
        .firstWhere((element) => element.id == artistId)
        .name ??
        '';
  }

  /// Set values of booking related data
  void setBookingData(BuildContext context, {
    bool setArtistId = false,
    bool setSelectedDate = false,
    bool setSelectedTime = false,
    String? artistId,
    DateTime? selectedDate,
    int? startTime,
  }) {
    if (setArtistId) {
      _currentBooking.artistId = artistId;
    }
    if (setSelectedDate) {
      String formattedDate =
      DateFormat('dd-MM-yyyy').format(selectedDate ?? DateTime.now());
      _currentBooking.selectedDate = formattedDate;
      _currentBooking.selectedDateInDateTimeFormat = selectedDate;
      setArtistStartEndTime();
    }
    if (setSelectedTime) {
      int indexOfStartTime =
      _artistAvailabilityForCalculation.indexOf(startTime ?? 0);
      _currentBooking.startTime = startTime;
      _currentBooking.endTime = _artistAvailabilityForCalculation[
      indexOfStartTime + (_currentBooking.serviceIds?.length ?? 0) * 2];
      if (_currentBooking.serviceIds?.length != null &&
          _currentBooking.serviceIds?.length != 1) {
        _selectedMultipleServices = true;
        print("Start time is");
        print(startTime);
        //TODO:
      }
    }
    updateIsNextButtonActive();
    notifyListeners();
  }

  /// Show the given [contentWidget] into a pre-styled dialogue box
  void showDialogue(BuildContext context,
      Widget contentWidget,) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (BuildContext context) {
        return Dialog(
          child: contentWidget,
        );
      },
    );
  }

  /// Set the artist's availability i.e. start and end time of working for a given date
  void setArtistStartEndTime() {
    int startTime = 0;
    int endTime = 0;
    String day = DateFormat.E().format(
        DateFormat('dd-MM-yyyy').parse(_currentBooking.selectedDate ?? ''));
    Availability artistAvailability = _artistList
        .firstWhere((element) => element.id == _currentBooking.artistId)
        .availability ??
        Availability();
    switch (day) {
      case 'Mon':
        startTime = artistAvailability.monday?.start ?? 0;
        endTime = artistAvailability.monday?.end ?? 0;
        break;
      case 'Tue':
        startTime = artistAvailability.tuesday?.start ?? 0;
        endTime = artistAvailability.tuesday?.end ?? 0;
        break;
      case 'Wed':
        startTime = artistAvailability.wednesday?.start ?? 0;
        endTime = artistAvailability.wednesday?.end ?? 0;
        break;
      case 'Thu':
        startTime = artistAvailability.thursday?.start ?? 0;
        endTime = artistAvailability.thursday?.end ?? 0;
        break;
      case 'Fri':
        startTime = artistAvailability.friday?.start ?? 0;
        endTime = artistAvailability.friday?.end ?? 0;
        break;
      case 'Sat':
        startTime = artistAvailability.saturday?.start ?? 0;
        endTime = artistAvailability.saturday?.end ?? 0;
        break;
      case 'Sun':
        startTime = artistAvailability.sunday?.start ?? 0;
        endTime = artistAvailability.sunday?.end ?? 0;
        break;
    }

    _artistAvailabilityForCalculation.clear();
    _artistAvailabilityToDisplay.clear();

    for (int i = startTime; i <= endTime; i += 1800) {
      _artistAvailabilityToDisplay.add(i);
      _artistAvailabilityForCalculation.add(i);
    }

    _initialAvailability.clear();
    _initialAvailability.addAll(_artistAvailabilityForCalculation);

    notifyListeners();
  }

  /// Get the current bookings of a given artist
  Future<void> getArtistBooking(BuildContext context) async {
    Loader.showLoader(context);
    try {
      String bookingDate = DateFormat('dd-MM-yyyy')
          .parse(_currentBooking.selectedDate ?? '')
          .toString();
      List<Booking> _bookingList = await DatabaseService().getArtistBookingList(
        _currentBooking.artistId,
        bookingDate,
      );
      Loader.hideLoader(context);
      _bookingList.forEach((booking) {
        for (int i = booking.startTime ?? 0;
        i < (booking.endTime ?? 0);
        i += 1800) {
          _artistAvailabilityForCalculation
              .removeWhere((availability) => availability == i);
          _artistAvailabilityToDisplay
              .removeWhere((availability) => availability == i);
        }
      });

      _initialAvailability.forEach((element) {
        if (_artistAvailabilityToDisplay.contains(element)) {
          bool accessibleSlot =
              _artistAvailabilityToDisplay.contains(element + 1800) &&
                  ((element + 3600) <= _initialAvailability.last);
          if (!accessibleSlot) {
            _artistAvailabilityToDisplay.removeWhere((e) => e == element);
          }
        }
      });

      if (_currentBooking.selectedDateInDateTimeFormat!.day ==
          DateTime
              .now()
              .day &&
          _currentBooking.selectedDateInDateTimeFormat!.month ==
              DateTime
                  .now()
                  .month) {
        int secondsElapsedTillNow =
            DateTime
                .now()
                .hour * 3600 + DateTime
                .now()
                .minute * 60;
        _artistAvailabilityToDisplay
            .removeWhere((element) => element <= secondsElapsedTillNow);
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  Future<void> getSalonData(BuildContext context, {
    required String salonId,
  }) async {
    Loader.showLoader(context);
    try {
      _selectedSalonData = await DatabaseService().getSalonData(salonId);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }

    notifyListeners();
  }

  ///Get the list of image for current
  Future<void> getImageList(BuildContext context,
      String salonId,) async {
    Loader.showLoader(context);
    try {
      _imageList = _selectedSalonData.imageList!.cast();
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }

    notifyListeners();
  }

  /// For a given seconds data which signifies total seconds passed in a day till now,
  /// get the corresponding time stamp of it.
  /// Note: 12:00 AM is considered as 0 seconds
  /// Example:
  /// String timeStamp = convertSecondsToTimeString(7200);
  /// print(timeStamp); // 02:00 AM
  String convertSecondsToTimeString(int seconds) {
    DateTime now = DateTime.now();

    DateTime midnight = DateTime(now.year, now.month, now.day);
    DateTime currentTime = midnight.add(Duration(seconds: seconds));

    String timeString =
        "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute
        .toString().padLeft(2, '0')}";

    return timeString;
  }

  String formatTime(int timeInSeconds) {
    int hours = (timeInSeconds ~/ 3600) % 12;
    int minutes = ((timeInSeconds % 3600) ~/ 60);
    String amPm = (timeInSeconds ~/ 43200) == 0 ? 'AM' : 'PM';

    if (hours == 0) {
      hours = 12;
    }

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(
        2, '0')} $amPm';
    return formattedTime;
  }

  /// Set the current status of scheduling flow
  void setSchedulingStatus({
    bool onSelectStaff = false,
    bool selectStaffFinished = false,
    bool selectSlotFinished = false,
  }) {
    if (selectSlotFinished &&
        _selectedTime != null) {
      _isOnSelectStaffType = false;
      _isOnSelectSlot = false;
      _isOnPaymentPage = true;
    } else if (selectStaffFinished && artistServiceList!.selectedArtist != null) {
      _isOnSelectStaffType = false;
      _isOnSelectSlot = true;
      _isOnPaymentPage = false;
    } else if (onSelectStaff) {
      _isOnSelectStaffType = true;
      _isOnSelectSlot = false;
      _isOnPaymentPage = false;
    }

    updateIsNextButtonActive();
    notifyListeners();
  }

  /// Set the value of selected [SalonData] instance in [SalonDetailsProvider]
  void setSelectedSalonData(BuildContext context) {
    _selectedSalonData =
    context
        .read<ExploreProvider>()
        .filteredSalonData[_selectedSalonIndex];

    _filteredServiceList.clear();
    _filteredServiceList.addAll(_serviceList);
  }

  DataService? _selectedService;

  DataService? get selectedService => _selectedService;

  void setSelectedService2(String serviceId) {
    // Find the service with the given id in salonDetails
    DataService? selectedService = salonDetails?.data.services.firstWhereOrNull(
          (service) => service.id == serviceId,
    );

    // If the service is found, update the selected service
    if (selectedService != null) {
      _selectedService = selectedService;
      notifyListeners();
    }
  }



  /// Add selected service's id into [_currentBooking]
  void setSelectedService(
    String id, {
    bool removeService = false,
  }) {
    if (_currentBooking.serviceIds == null) {
      _currentBooking.serviceIds = [];
    }
    var service = _serviceList.firstWhere((element) => element.id == id);
    if (removeService) {
      _currentBooking.serviceIds?.removeWhere((element) => element == id);
      _totalPrice -= service.price ?? 0;

    } else {
      if (_currentBooking.serviceIds?.contains(id) == true) {
        _currentBooking.serviceIds?.remove(id);
        _totalPrice -= service.price ?? 0;
      } else {
        _currentBooking.serviceIds?.add(id);
        _totalPrice += service.price ?? 0;
      }
    }
    notifyListeners();
  }
   /// Set Service Time

  void setServiceIds({
    required List<String> ids,
    required double totalPrice,
  }) {
    _currentBooking.serviceIds = [];
    _currentBooking.serviceIds?.addAll(ids);
    _totalPrice = totalPrice;
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
      salonId: selectedSalonData.id,
      salonName: selectedSalonData.name,
      comment: text,
      createdAt: DateTime.now(),
      userId: context.read<HomeProvider>().userData.id,
      userName: context.read<HomeProvider>().userData.name,
      rating: stars.toDouble(),
    );

    try {
      await DatabaseService()
          .addReview(
            reviewData: review,
          )
          .onError(
            (FirebaseException error, stackTrace) =>
                throw ExceptionHandling(message: error.message ?? ""),
          );
      context.read<HomeProvider>().addReview(review);
      context.read<HomeProvider>().changeRatings(context, notify: true);
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



  /// Get the list of services provided by the selected salon
  Future<void> getServiceList(BuildContext context) async {
    List<String> _artistIdList = _artistList.map((e) => e.id ?? '').toList();
    if (_artistIdList.isNotEmpty) {
      try {
        _serviceList = await DatabaseService().getServiceList(_artistIdList);
        print(_serviceList);
        _filteredServiceList.clear();
        _filteredServiceList.addAll(_serviceList);
      } catch (e) {
        ReusableWidgets.showFlutterToast(context, '$e');
      }
    }
    notifyListeners();
  }

  // /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  // Future<void> getSalonReviewsList(BuildContext context) async {
  //   try {
  //     _salonReviewList = context.read<HomeProvider>().reviewList;
  //   } catch (e) {
  //     ReusableWidgets.showFlutterToast(context, '$e');
  //   }
  //   notifyListeners();
  // }

  Future<void> createBooking(
    BuildContext context,
    String transactionStatus, {
    String? paymentId,
    String? orderId,
    String? errorMessage,
  }) async {
    Loader.showLoader(context);
    _currentBooking.salonId = _selectedSalonData.id;
    _currentBooking.userId = context.read<HomeProvider>().userData.id;
    _currentBooking.bookingCreatedOn = DateTime.now().toString();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime parsedDate = dateFormat.parse(_currentBooking.selectedDate ?? '');
    String timeString = convertSecondsToTimeString(_currentBooking.startTime ?? 0);
    List<String> timeParts = timeString.split(':');
    DateTime parsedTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(timeParts[0]), int.parse(timeParts[1]));
    String formattedTime = DateFormat('HH:mm').format(parsedTime);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String combinedDateTime = '$formattedDate $formattedTime';
    _currentBooking.bookingCreatedFor = combinedDateTime;
    _currentBooking.price = context.read<SalonDetailsProvider>().totalPrice;
    _currentBooking.transactionStatus = transactionStatus;
    _currentBooking.errorMessage = errorMessage;

    Map<String, dynamic> _finalData = _currentBooking.toJson();

    try {
      await DatabaseService().createBooking(bookingData: _finalData);
      Loader.hideLoader(context);
      context.read<HomeProvider>().getUserBookings(context);
      if (transactionStatus == "Paid not yet") {
        Navigator.pushReplacementNamed(
          context,
          NamedRoutes.bookingConfirmedRoute,
        );
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getArtistList(BuildContext context) async {
    try {
      _artistList =
          await DatabaseService().getArtistListOfSalon(_selectedSalonData.id);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Save the index of selected [SalonData] instance in [SalonDetailsProvider]
  void setSelectedSalonIndex(int value) {
    _selectedSalonIndex = value;
    notifyListeners();
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

  /// Set the index of selected artist in [BarberProvider]
  void setSelectedArtistIndex(BuildContext context, {required int index}) {
    context.read<BarberProvider>().setSelectedArtistIndex(index);
  }

  /// Reset values of slot related information
  void resetSlotInfo() {
    _artistAvailabilityToDisplay = [];
    _artistAvailabilityForCalculation = [];
    _initialAvailability = [];
    _currentBooking.selectedDate = null;
    _currentBooking.startTime = null;
    _currentBooking.endTime = null;
    _currentBooking.bookingCreatedFor = null;
    notifyListeners();
  }

  /// Reset values of booking related data
  void resetCurrentBooking() {
    _currentBooking = Booking();
    // TODO: Uncomment this once multiple artist booking method is finished
    // _selectedMultipleStaff = false;
    // _selectedSingleStaff = false;
    _isOnSelectStaffType = true;
    _isOnSelectSlot = false;
    _isOnPaymentPage = false;
    _isNextButtonActive = false;
    _artistAvailabilityToDisplay = [];
    _artistAvailabilityForCalculation = [];
    _initialAvailability = [];
    _totalPrice = 0;
    _currentBooking.serviceIds = [];
    // TODO: Make for two services.
    // Approach get the length of _currentBooking.serviceIds and select that much number of slots


    notifyListeners();
  }
  void resetCurrentBooking2() {
    _selectedServices.clear(); // Clear selected services
    _totalPrice = 0; // Reset total price
    _showPrice = 0; // Reset show price
_selectedDate = null;
_selectedTime = null;

    // Add any other data you want to reset here

    notifyListeners();
  }

  /// Reset value of start and end time of current booking
  void resetTime() {
    _currentBooking.startTime = null;
    _currentBooking.endTime = null;
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

  void clearServiceList () {
    _serviceList.clear();
    notifyListeners();
  }

  Future<void> addPreferedSalon(BuildContext context, String? salonId) async {
    if (salonId == null) return;
    context.read<HomeProvider>().userData.preferredSalon!.add(salonId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }

  Future<void> removePreferedSalon(
      BuildContext context, String? salonId) async {
    context.read<HomeProvider>().userData.preferredSalon!.remove(salonId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }

}
