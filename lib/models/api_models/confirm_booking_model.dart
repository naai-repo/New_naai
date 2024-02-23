// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/booking_appointment_model.dart';

class ConfirmBookingModel {
  final String?  status;
  final String? message;
  final AppointmentDataModel? data;

  ConfirmBookingModel({
    this.status,
    this.message,
    this.data,
  });

  ConfirmBookingModel copyWith({
    String? status,
    String? message,
    AppointmentDataModel? data,
  }) {
    return ConfirmBookingModel(
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

  factory ConfirmBookingModel.fromMap(Map<String, dynamic> map) {
    return ConfirmBookingModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? AppointmentDataModel.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfirmBookingModel.fromJson(String source) => ConfirmBookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ConfirmBookingModel(status: $status, message: $message, data: $data)';
}
