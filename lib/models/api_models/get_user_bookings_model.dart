// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/booking_appointment_model.dart';

class GetUserBookingResponseModel {
   final String? userId;
   final List<AppointmentDataModel>? current_bookings;
   final List<AppointmentDataModel>? prev_booking;
   final List<AppointmentDataModel>? coming_bookings;

  GetUserBookingResponseModel({
    this.userId,
    this.current_bookings,
    this.prev_booking,
    this.coming_bookings,
  });

  GetUserBookingResponseModel copyWith({
    String? userId,
    List<AppointmentDataModel>? current_bookings,
    List<AppointmentDataModel>? prev_booking,
    List<AppointmentDataModel>? coming_bookings,
  }) {
    return GetUserBookingResponseModel(
      userId: userId ?? this.userId,
      current_bookings: current_bookings ?? this.current_bookings,
      prev_booking: prev_booking ?? this.prev_booking,
      coming_bookings: coming_bookings ?? this.coming_bookings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'current_bookings': current_bookings?.map((x) => x.toMap()).toList() ?? [],
      'prev_booking': prev_booking?.map((x) => x.toMap()).toList() ?? [],
      'coming_bookings': coming_bookings?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory GetUserBookingResponseModel.fromMap(Map<String, dynamic> map) {
    return GetUserBookingResponseModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      current_bookings: map['current_bookings'] != null ? List<AppointmentDataModel>.from((map['current_bookings'] as List<dynamic>).map<AppointmentDataModel?>((x) => AppointmentDataModel.fromMap(x as Map<String,dynamic>),),) : null,
      prev_booking: map['prev_booking'] != null ? List<AppointmentDataModel>.from((map['prev_booking'] as List<dynamic>).map<AppointmentDataModel?>((x) => AppointmentDataModel.fromMap(x as Map<String,dynamic>),),) : null,
      coming_bookings: map['coming_bookings'] != null ? List<AppointmentDataModel>.from((map['coming_bookings'] as List<dynamic>).map<AppointmentDataModel?>((x) => AppointmentDataModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUserBookingResponseModel.fromJson(String source) => GetUserBookingResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetUserBookingResponseModel(userId: $userId, current_bookings: $current_bookings, prev_booking: $prev_booking, coming_bookings: $coming_bookings)';
  }


}
