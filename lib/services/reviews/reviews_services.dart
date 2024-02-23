import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/reviews_item_model.dart';
import 'package:naai/models/api_models/reviews_model.dart';
import 'package:naai/models/utility/reviews_username_model.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/constants/api_constant.dart';

class ReviewsServices {
  static Dio dio = Dio();

  static Future<List<ReviewsModel>> getReviewsBySalonId({required String salonId,required String accessToken}) async {
    final apiUrl = "${UrlConstants.getSalonReview}/$salonId";

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {"Content-Type": "application/json","Authorization": "Bearer $accessToken"},
        validateStatus: (status){
            return true;
        }
        ),
      );
      List<ReviewsModel> ans = [];

      if (response.statusCode == 200) {
        
        final reviews = ReviewResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        List<ReviewItem> list = reviews.data ?? [];
        for(var e in list){
            final userResponse = await UserServices.getUserByID(userId: e.review.userId ?? "");
            ans.add(ReviewsModel(
              user: userResponse,
              reviews: e
            ));
        }
        return ans;
      } else if(response.statusCode == 404){
        return [];
      }else{
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error Reviews: ${e.toString()}");
       return [];
    }
  }
  
  static Future<ReviewData> addReviewToSalon({required String salonId,required int rating,required String discription,required String accessToken}) async {
    const apiUrl = UrlConstants.addReview;
    
    final Map<String, dynamic> requestData = {
        "title": "Review Salon",
        "description": discription,
        "salonId": salonId,
        "rating": rating,
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
        final res = ReviewData.fromJson(jsonEncode(response.data['data']).replaceAll("_id", "id"));
        return res;
      } else {
        throw ErrorDescription(response.data['message']);
      }
    } catch (e,stacktrace) {
       print(stacktrace.toString());
       print("Error : ${e.toString()}");
       return ReviewData();
    }
  }
  
}