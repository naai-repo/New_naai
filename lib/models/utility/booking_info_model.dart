// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/booking_appointment_model.dart';
import 'package:naai/models/api_models/service_artist_model.dart';
import 'package:naai/models/api_models/single_artist_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/api_models/user_model.dart';

class BookingInfoModel {
   final UserItemModel? user;
   final List<BookingInfoItemModel>? prevBooking;
   final List<BookingInfoItemModel>? upcommingBookings;
   final List<BookingInfoItemModel>? currentBookings;

  BookingInfoModel({
    this.user,
    this.prevBooking,
    this.upcommingBookings,
    this.currentBookings,
  });

  BookingInfoModel copyWith({
    UserItemModel? user,
    List<BookingInfoItemModel>? prevBooking,
    List<BookingInfoItemModel>? upcommingBookings,
    List<BookingInfoItemModel>? currentBookings,
  }) {
    return BookingInfoModel(
      user: user ?? this.user,
      prevBooking: prevBooking ?? this.prevBooking,
      upcommingBookings: upcommingBookings ?? this.upcommingBookings,
      currentBookings: currentBookings ?? this.currentBookings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'prevBooking': prevBooking?.map((x) => x.toMap()).toList() ?? [],
      'upcommingBookings': upcommingBookings?.map((x) => x.toMap()).toList() ?? [],
      'currentBookings': currentBookings?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory BookingInfoModel.fromMap(Map<String, dynamic> map) {
    return BookingInfoModel(
      user: map['user'] != null ? UserItemModel.fromMap(map['user'] as Map<String,dynamic>) : null,
      prevBooking: map['prevBooking'] != null ? List<BookingInfoItemModel>.from((map['prevBooking'] as List<dynamic>).map<BookingInfoItemModel?>((x) => BookingInfoItemModel.fromMap(x as Map<String,dynamic>),),) : null,
      upcommingBookings: map['upcommingBookings'] != null ? List<BookingInfoItemModel>.from((map['upcommingBookings'] as List<dynamic>).map<BookingInfoItemModel?>((x) => BookingInfoItemModel.fromMap(x as Map<String,dynamic>),),) : null,
      currentBookings: map['currentBookings'] != null ? List<BookingInfoItemModel>.from((map['currentBookings'] as List<dynamic>).map<BookingInfoItemModel?>((x) => BookingInfoItemModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingInfoModel.fromJson(String source) => BookingInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookingInfoModel(user: $user, prevBooking: $prevBooking, upcommingBookings: $upcommingBookings, currentBookings: $currentBookings)';
  }

  
}

class BookingInfoItemModel {
   final SingleSalonResponseModel? salonDetails;
   final AppointmentDataModel? appointmentData;
   final List<BookingInfoArtistServiceMapItemModel>? artistMapServices;

  BookingInfoItemModel({
    this.salonDetails,
    this.appointmentData,
    this.artistMapServices,
  });

  BookingInfoItemModel copyWith({
    SingleSalonResponseModel? salonDetails,
    AppointmentDataModel? appointmentData,
    List<BookingInfoArtistServiceMapItemModel>? artistMapServices,
  }) {
    return BookingInfoItemModel(
      salonDetails: salonDetails ?? this.salonDetails,
      appointmentData: appointmentData ?? this.appointmentData,
      artistMapServices: artistMapServices ?? this.artistMapServices,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salonDetails': salonDetails?.toMap(),
      'appointmentData': appointmentData?.toMap(),
      'artistMapServices': artistMapServices?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory BookingInfoItemModel.fromMap(Map<String, dynamic> map) {
    return BookingInfoItemModel(
      salonDetails: map['salonDetails'] != null ? SingleSalonResponseModel.fromMap(map['salonDetails'] as Map<String,dynamic>) : null,
      appointmentData: map['appointmentData'] != null ? AppointmentDataModel.fromMap(map['appointmentData'] as Map<String,dynamic>) : null,
      artistMapServices: map['artistMapServices'] != null ? List<BookingInfoArtistServiceMapItemModel>.from((map['artistMapServices'] as List<dynamic>).map<BookingInfoArtistServiceMapItemModel?>((x) => BookingInfoArtistServiceMapItemModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingInfoItemModel.fromJson(String source) => BookingInfoItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookingInfoItemModel(salonDetails: $salonDetails, appointmentData: $appointmentData, artistMapServices: $artistMapServices)';

}

class BookingInfoArtistServiceMapItemModel {
  final ArtistServiceMap? artistMap;
  final SingleArtistModel? artist;
  final ServiceArtistModel? serviceArtist;

  BookingInfoArtistServiceMapItemModel({
    this.artistMap,
    this.artist,
    this.serviceArtist,
  });

  BookingInfoArtistServiceMapItemModel copyWith({
    ArtistServiceMap? artistMap,
    SingleArtistModel? artist,
    ServiceArtistModel? serviceArtist,
  }) {
    return BookingInfoArtistServiceMapItemModel(
      artistMap: artistMap ?? this.artistMap,
      artist: artist ?? this.artist,
      serviceArtist: serviceArtist ?? this.serviceArtist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistMap': artistMap?.toMap(),
      'artist': artist?.toMap(),
      'serviceArtist': serviceArtist?.toMap(),
    };
  }

  factory BookingInfoArtistServiceMapItemModel.fromMap(Map<String, dynamic> map) {
    return BookingInfoArtistServiceMapItemModel(
      artistMap: map['artistMap'] != null ? ArtistServiceMap.fromMap(map['artistMap'] as Map<String,dynamic>) : null,
      artist: map['artist'] != null ? SingleArtistModel.fromMap(map['artist'] as Map<String,dynamic>) : null,
      serviceArtist: map['serviceArtist'] != null ? ServiceArtistModel.fromMap(map['serviceArtist'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingInfoArtistServiceMapItemModel.fromJson(String source) => BookingInfoArtistServiceMapItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookingInfoArtistServiceMapItemModel(artistMap: $artistMap, artist: $artist, serviceArtist: $serviceArtist)';

}

