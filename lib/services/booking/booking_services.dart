import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/booking_appointment_model.dart';
import 'package:naai/models/api_models/booking_single_artist_list_model.dart';
import 'package:naai/models/api_models/confirm_booking_model.dart';
import 'package:naai/models/api_models/scheduling_response_model.dart';
import 'package:naai/models/utility/selected_service_artists.dart';
import 'package:naai/utils/constants/api_constant.dart';

class BookingServices {
  static Dio dio = Dio();
  
  static Future<ScheduleResponseModel> scheduleAppointment({required SelectedServicesArtistModel data,required String accessToken}) async {
    const apiUrl = UrlConstants.scheduleAppointment;
    final Map<String, dynamic> requestData = data.toMap();
    

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
        final res = ScheduleResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error ScheduleAppointment : ${e.toString()}");
       return ScheduleResponseModel(salonId: "0000");
    }
  }
  
  static Future<BookingSingleArtistListResponseModel> singleArtistList({required String salonId,required List<String> services}) async {
    const apiUrl = UrlConstants.bookingSingleArtistList;
    final Map<String, dynamic> requestData = {
      "salonId": salonId,
      "services" : services
    };
  

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
        final res = BookingSingleArtistListResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Booking Single List : ${e.toString()}");
       return BookingSingleArtistListResponseModel();
    }
  }
  
  static Future<BookingAppointmentResponseModel> makeAppointment({required String salonId,required String bookingDate,required List<String> selectedTimeSlot,required List<TimeSlotResponseTimeSlot> timeSlots,required String accessToken}) async {
    const apiUrl = UrlConstants.bookingMakeAppointment;

    final Map<String, dynamic> requestData = {
      "key": 1,
      "timeSlot" : selectedTimeSlot,
      "bookingDate" : bookingDate,
      "salonId": salonId,
      "timeSlots": []
    };

    for(var e in timeSlots){
        requestData["timeSlots"].add(e.toMap());
    }

    // print(json.encode(requestData["timeSlots"][0]["order"]));
    // print(json.encode(requestData["timeSlot"]));
     // print(json.encode(requestData));
  

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
      //  print(response.data);
        final res = BookingAppointmentResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Booking MakeAppointMent : ${e.toString()}");
       return BookingAppointmentResponseModel();
    }
  }

  
  static Future<ConfirmBookingModel> confirmBooking({required String salonId,required BookingAppointmentResponseModel confirmBookingPaylaod,required String accessToken}) async {
    const apiUrl = UrlConstants.bookingConfirm;

    final Map<String, dynamic> requestData = confirmBookingPaylaod.toMap();

    // print(json.encode(requestData["timeSlots"][0]["order"]));
    // print(json.encode(requestData["timeSlot"]));
    //print(json.encode(requestData));
  

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
      //  print(response.data);
        final res = ConfirmBookingModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Confirm Booking : ${e.toString()}");
       return ConfirmBookingModel();
    }
  }
  
}