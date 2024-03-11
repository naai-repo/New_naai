import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/service_artist_model.dart';
import 'package:naai/utils/constants/api_constant.dart';

class ServicesArtists {
   static Dio dio = Dio();

  static Future<ServiceArtistModel> getServicesByID({required String serviceId}) async {
    final apiUrl = "${UrlConstants.getSingleService}/$serviceId";
    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.get(apiUrl,options: Options(validateStatus: (s) => true));
      print("Services Request at : ${DateTime.now().second} - ${DateTime.now().millisecond}");
      

      if (response.statusCode == 200) {
        final res = ServiceArtistModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;

      }else if(response.statusCode == 404){
        throw ErrorDescription(jsonEncode(response.data));
      }else{
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error Services : ${e.toString()}");
      return ServiceArtistModel();
    }
  } 


}