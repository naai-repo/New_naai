import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/add_user_fav_response_model.dart';
import 'package:naai/models/api_models/delete_user_model.dart';
import 'package:naai/models/api_models/location_get_response_model.dart';
import 'package:naai/models/api_models/location_update_response_model.dart';
import 'package:naai/models/api_models/update_user_response_model.dart';
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
              name: "Unknown User",
              id: "0000"
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

  static Future<UpdateUserResponseModel> updateUserByID({required String userId,required String name,required String gender,required String email}) async {
    const String apiUrl = UrlConstants.updateUser;
    
    final Map<String, dynamic> requestData = {
        "userId": userId,
        "data" : {
            "name": name,
            "gender": gender,
            "email" : email
        }
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
        final res = UpdateUserResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Update User : ${e.toString()}");
       return UpdateUserResponseModel();
    }
  }

  static Future<AddUserFavResponseModel> addUserFav({required String userId,String salonId = "",String artistId = "",required String accessToken}) async {
    const String apiUrl = UrlConstants.addUserFav;

    final Map<String, dynamic> requestData = {
        if(salonId.isNotEmpty) "salon": salonId,
        if(artistId.isNotEmpty) "artist": artistId,
        "userId": userId
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
        final res = AddUserFavResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Add User Fav : ${e.toString()}");
       return AddUserFavResponseModel();
    }
  }
  
  static Future<LocationGetResponseModel> getUserFav({required String userId,required String accessToken}) async {
    const apiUrl = UrlConstants.getUserFav;

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get(apiUrl);
     
      
      if (response.statusCode == 200) {
        final res = LocationGetResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error User Get Location : ${e.toString()}");
       return LocationGetResponseModel();
    }
  }

  static Future<LocationUpdateResponseModel> updateUserLocation({required String userId,required List<double> coords}) async {
    const String apiUrl = UrlConstants.updateLocation;

    final Map<String, dynamic> requestData = {
        "userId" : userId,
        "coords" : coords
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
          apiUrl,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: json.encode(requestData),
      );
     
      
      if (response.statusCode == 200) {
        final res = LocationUpdateResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Update User Location : ${e.toString()}");
       return LocationUpdateResponseModel();
    }
  }
  
  static Future<LocationGetResponseModel> getUserLocation({required String userId}) async {
    final apiUrl = "${UrlConstants.getUserLoaction}/$userId";

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.get(apiUrl);
     
      
      if (response.statusCode == 200) {
        final res = LocationGetResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error User Get Location : ${e.toString()}");
       return LocationGetResponseModel();
    }
  }

  static Future<DeleteUserResponseModel> deleteUser({required String userId,required String accessToken}) async {
    const apiUrl = UrlConstants.deleteUser;

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get(apiUrl);
     
      
      if (response.statusCode == 200) {
        final res = DeleteUserResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return res;
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Delete User : ${e.toString()}");
       return DeleteUserResponseModel();
    }
  }
  
  
}