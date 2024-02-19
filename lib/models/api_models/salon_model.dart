import 'dart:convert';
import 'package:naai/models/api_models/salon_item_model.dart';

class SalonResponseModel {
  final String status;
  final String message;
  final List<SalonResponseData> data;

  SalonResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  SalonResponseModel copyWith({
    String? status,
    String? message,
    List<SalonResponseData>? data,
  }) {
    return SalonResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory SalonResponseModel.fromMap(Map<String, dynamic> map) {
    return SalonResponseModel(
      status: map['status'] as String,
      message: map['message'] as String,
      data: List<SalonResponseData>.from((map['data'] as List<dynamic>).map<SalonResponseData>((x) => SalonResponseData.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonResponseModel.fromJson(String source) => SalonResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SalonResponseModel(status: $status, message: $message, data: $data)';
}
