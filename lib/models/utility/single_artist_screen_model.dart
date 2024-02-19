// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_artist_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';

class SingleArtistScreenModel {
  final SingleArtistModel? artistDetails;
  final SingleSalonResponseModel? salonDetails;
  final List<ServiceDataModel>? services;

  SingleArtistScreenModel({
    this.artistDetails,
    this.salonDetails,
    this.services
  });

  
  SingleArtistScreenModel copyWith({
    SingleArtistModel? artistDetails,
    SingleSalonResponseModel? salonDetails,
    List<ServiceDataModel>? services,
  }) {
    return SingleArtistScreenModel(
      artistDetails: artistDetails ?? this.artistDetails,
      salonDetails: salonDetails ?? this.salonDetails,
      services: services ?? this.services,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistDetails': artistDetails?.toMap(),
      'salonDetails': salonDetails?.toMap(),
      'services': services?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory SingleArtistScreenModel.fromMap(Map<String, dynamic> map) {
    return SingleArtistScreenModel(
      artistDetails: map['artistDetails'] != null ? SingleArtistModel.fromMap(map['artistDetails'] as Map<String,dynamic>) : null,
      salonDetails: map['salonDetails'] != null ? SingleSalonResponseModel.fromMap(map['salonDetails'] as Map<String,dynamic>) : null,
      services: map['services'] != null ? List<ServiceDataModel>.from((map['services'] as List<int>).map<ServiceDataModel?>((x) => ServiceDataModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleArtistScreenModel.fromJson(String source) => SingleArtistScreenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SingleArtistScreenModel(artistDetails: $artistDetails, salonDetails: $salonDetails, services: $services)';

}
