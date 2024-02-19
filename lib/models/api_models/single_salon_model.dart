import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';

class SingleSalonResponseModel {
  final String? status;
  final String? message;
  final SingleSalonItemModel? data;

  SingleSalonResponseModel({
    this.status,
    this.message,
    this.data,
  });

  SingleSalonResponseModel copyWith({
    String? status,
    String? message,
    SingleSalonItemModel? data,
  }) {
    return SingleSalonResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory SingleSalonResponseModel.fromMap(Map<String, dynamic> map){
    return SingleSalonResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? SingleSalonItemModel.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleSalonResponseModel.fromJson(String source) => SingleSalonResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SingleSalonResponseModel(status: $status, message: $message, data: $data)';
}

class SingleSalonItemModel {
   final SalonResponseData? data;
   final List<ArtistDataModel>? artists;
   final List<ServiceDataModel>? services;

  SingleSalonItemModel({
    this.data,
    this.artists,
    this.services
  });


  SingleSalonItemModel copyWith({
    SalonResponseData? data,
    List<ArtistDataModel>? artists,
    List<ServiceDataModel>? services,
  }) {
    return SingleSalonItemModel(
      data: data ?? this.data,
      artists: artists ?? this.artists,
      services: services ?? this.services,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data?.toMap(),
      'artists': artists?.map((x) => x.toMap()).toList() ?? [],
      'services': services?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory SingleSalonItemModel.fromMap(Map<String, dynamic> map) {
    return SingleSalonItemModel(
      data: map['data'] != null ? SalonResponseData.fromMap(map['data'] as Map<String,dynamic>) : null,
      artists: map['artists'] != null ? List<ArtistDataModel>.from((map['artists'] as List<dynamic>).map<ArtistDataModel?>((x) => ArtistDataModel.fromMap(x as Map<String,dynamic>),),) : null,
      services: map['services'] != null ? List<ServiceDataModel>.from((map['services'] as List<dynamic>).map<ServiceDataModel?>((x) => ServiceDataModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleSalonItemModel.fromJson(String source) => SingleSalonItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SingleSalonItemModel(data: $data, artists: $artists, services: $services)';

}
