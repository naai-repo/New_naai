// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/location_item_model.dart';

class LocationGetResponseModel {
   final String? status;
   final String? message;
   final Location? data;

  LocationGetResponseModel({
    this.status,
    this.message,
    this.data,
  });

  LocationGetResponseModel copyWith({
    String? status,
    String? message,
    Location? data,
  }) {
    return LocationGetResponseModel(
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

  factory LocationGetResponseModel.fromMap(Map<String, dynamic> map) {
    return LocationGetResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? Location.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationGetResponseModel.fromJson(String source) => LocationGetResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocationGetResponseModel(status: $status, message: $message, data: $data)';

}
