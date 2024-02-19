import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/utility/booking_service_salon_model.dart';

class SingleStaffServicesModel {
  final List<BookingServiceSalonModel>? selectedServices;
  final List<ArtistDataModel>? artists;

  SingleStaffServicesModel({
    this.selectedServices,
    this.artists,
  });

  SingleStaffServicesModel copyWith({
    List<BookingServiceSalonModel>? selectedServices,
    List<ArtistDataModel>? artists,
  }) {
    return SingleStaffServicesModel(
      selectedServices: selectedServices ?? this.selectedServices,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedServices': selectedServices?.map((x) => x.toMap()).toList() ?? [],
      'artists': artists?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory SingleStaffServicesModel.fromMap(Map<String, dynamic> map) {
    return SingleStaffServicesModel(
      selectedServices: map['selectedServices'] != null ? List<BookingServiceSalonModel>.from((map['selectedServices'] as List<int>).map<BookingServiceSalonModel?>((x) => BookingServiceSalonModel.fromMap(x as Map<String,dynamic>),),) : null,
      artists: map['artists'] != null ? List<ArtistDataModel>.from((map['artists'] as List<int>).map<ArtistDataModel?>((x) => ArtistDataModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleStaffServicesModel.fromJson(String source) => SingleStaffServicesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SingleStaffServicesModel(selectedServices: $selectedServices, artists: $artists)';
}
