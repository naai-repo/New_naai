import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';

class BookingServiceSalonModel {
  final ServiceDataModel? service;
  final List<ArtistDataModel>? artists;
  
  BookingServiceSalonModel({
    this.service,
    this.artists,
  });


  BookingServiceSalonModel copyWith({
    ServiceDataModel? service,
    List<ArtistDataModel>? artists,
  }) {
    return BookingServiceSalonModel(
      service: service ?? this.service,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': service?.toMap(),
      'artists': artists?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory BookingServiceSalonModel.fromMap(Map<String, dynamic> map) {
    return BookingServiceSalonModel(
      service: map['service'] != null ? ServiceDataModel.fromMap(map['service'] as Map<String,dynamic>) : null,
      artists: map['artists'] != null ? List<ArtistDataModel>.from((map['artists'] as List<int>).map<ArtistDataModel?>((x) => ArtistDataModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingServiceSalonModel.fromJson(String source) => BookingServiceSalonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookingServiceSalonModel(service: $service, artists: $artists)';
}
