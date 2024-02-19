import 'dart:convert';
import 'package:naai/models/api_models/service_item_model.dart';

class ServiceArtistModel {
  final String? status;
  final String? message;
  final ServiceDataModel? data;
  
  ServiceArtistModel({
    this.status,
    this.message,
    this.data,
  });

  ServiceArtistModel copyWith({
    String? status,
    String? message,
    ServiceDataModel? data,
  }) {
    return ServiceArtistModel(
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

  factory ServiceArtistModel.fromMap(Map<String, dynamic> map) {
    return ServiceArtistModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? ServiceDataModel.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceArtistModel.fromJson(String source) => ServiceArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServiceArtistModel(status: $status, message: $message, data: $data)';

}
