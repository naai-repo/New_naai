import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/models/api_models/salon_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/utils/constants/api_constant.dart';

class SalonsServices {
  static Dio dio = Dio();

  static Future<SingleSalonResponseModel> getSalonByID({required String salonId}) async {
    final apiUrl = "${UrlConstants.getSingleSalon}/$salonId";
    
    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.get(apiUrl);
     
      if (response.statusCode == 200) {
        final res = SingleSalonResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       return SingleSalonResponseModel(status: 'failed', message: e.toString(), data: SingleSalonItemModel());
    }
  }

  static Future<SalonResponseModel> getSalonsByDiscount({required List<double> coords,required int page,required int limit,required String type,required int min,required int max}) async {
    final apiUrl = "${UrlConstants.salonsFilter}?page=${page.toString()}&limit=${limit.toString()}&filter=discount&min=${min.toString()}&max=${max.toString()}&type=$type";

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final res = SalonResponseModel.fromJson(jsonEncode(response.data).replaceAll('_id', 'id'));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       return SalonResponseModel(status: 'failed', message: e.toString(), data: []);
    }
  }

  static Future<SalonResponseModel> getSalonsByRating({required List<double> coords,required int page,required int limit,required String type,required int min}) async {
    final apiUrl = "${UrlConstants.salonsFilter}?page=${page.toString()}&limit=${limit.toString()}&filter=rating&min=${min.toString()}&type=$type";

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final res = SalonResponseModel.fromJson(jsonEncode(response.data).replaceAll('_id', 'id'));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       return SalonResponseModel(status: 'failed', message: e.toString(), data: []);
    }
  } 
  
  static Future<List<SalonResponseData>> getSalonsByCategory({required List<double> coords,required int page,required int limit,required String type,required String category}) async {
    final apiUrl = "${UrlConstants.getSalonsByCategory}?page=${page.toString()}&limit=${limit.toString()}&name=${category.toString()}&type=${type.toString()}";
    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      List<SalonResponseData> ans = [];

      if (response.statusCode == 200) {
        if((response.data["data"] as dynamic).isNotEmpty){
          for(var e in (response.data["data"]["list"] as dynamic)){
              final res = SalonResponseData.fromJson(jsonEncode(e).replaceAll("_id", "id"));
              ans.add(res);
          }
        }
        return ans;
      }else{
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error : ${e.toString()}");
      return [];
    }
  } 
  
  static Future<SalonResponseModel> getTopSalons({required List<double> coords,required int page,required int limit,required String type}) async {
    final apiUrl = "${UrlConstants.topSalon}?page=${page.toString()}&limit=${limit.toString()}&type=$type";

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        final res = SalonResponseModel.fromJson(jsonEncode(response.data).replaceAll('_id', 'id'));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       return SalonResponseModel(status: 'failed', message: e.toString(), data: []);
    }
  } 


}