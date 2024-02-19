import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/user_model.dart';
import 'package:naai/utils/constants/api_constant.dart';

class UserServices {
  static Dio dio = Dio();

  static Future<UserResponseModel> getUserByID({required String userId}) async {
    final apiUrl = "${UrlConstants.getUser}/$userId";

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.get(apiUrl,options: Options(
        validateStatus: (status) {
            return true;
        },
      ));
     
      
      if (response.statusCode == 200) {
        final res = UserResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      } else if(response.statusCode == 404){
          return UserResponseModel(
            status: response.data["status"],
            message: response.data["message"],
            data: UserItemModel(
              name: "Unknown User"
            )
          );
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error : ${e.toString()}");
       return UserResponseModel();
    }
  }

}