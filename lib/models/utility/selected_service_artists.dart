import 'dart:convert';
import 'package:naai/models/api_models/service_item_model.dart';

class SelectedServicesArtistModel {
  final String? salonId;
  final List<ServicesArtistItemModel>? requests;
  final String? date;

  SelectedServicesArtistModel({
    this.salonId,
    this.requests,
    this.date,
  });

  SelectedServicesArtistModel copyWith({
    String? salonId,
    List<ServicesArtistItemModel>? requests,
    String? date,
  }) {
    return SelectedServicesArtistModel(
      salonId: salonId ?? this.salonId,
      requests: requests ?? this.requests,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salonId': salonId,
      'requests': requests?.map((x) => x.toMap()).toList() ?? [],
      'date': date,
    };
  }

  factory SelectedServicesArtistModel.fromMap(Map<String, dynamic> map) {
    return SelectedServicesArtistModel(
      salonId: map['salonId'] != null ? map['salonId'] as String : null,
      requests: map['requests'] != null ? List<ServicesArtistItemModel>.from((map['requests'] as List<int>).map<ServicesArtistItemModel?>((x) => ServicesArtistItemModel.fromMap(x as Map<String,dynamic>),),) : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectedServicesArtistModel.fromJson(String source) => SelectedServicesArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SelectedServicesArtistModel(salonId: $salonId, requests: $requests, date: $date)';
}


class ServicesArtistItemModel {
  final String? service;
  final VariableService? variable;
  final String? artist;

  ServicesArtistItemModel({
    this.service,
    this.variable,
    this.artist,
  });

  ServicesArtistItemModel copyWith({
    String? service,
    VariableService? variable,
    String? artist,
  }) {
    return ServicesArtistItemModel(
      service: service ?? this.service,
      variable: variable ?? this.variable,
      artist: artist ?? this.artist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': service,
      'variable': variable?.toMap(),
      'artist': artist,
    };
  }

  factory ServicesArtistItemModel.fromMap(Map<String, dynamic> map) {
    return ServicesArtistItemModel(
      service: map['service'] != null ? map['service'] as String : null,
      variable: map['variable'] != null ? VariableService.fromMap(map['variable'] as Map<String,dynamic>) : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesArtistItemModel.fromJson(String source) => ServicesArtistItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServicesArtistItemModel(service: $service, variable: $variable, artist: $artist)';

}
