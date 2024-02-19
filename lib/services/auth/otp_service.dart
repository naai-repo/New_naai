import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:naai/models/auth/mobile_otp_model.dart';
import 'package:naai/utils/constants/api_constant.dart';

class LoginController{
  static final Dio dio = Dio();

  static Future<GetOTPModel> login(String phoneNumber) async {
    try {
      dio.options.connectTimeout = const Duration(milliseconds: 30000);

      final response = await dio.post(UrlConstants.login,
        data: {
          "phoneNumber": phoneNumber,
        }
      );

      if (response.data['status'] == 'failed') {
        throw ErrorDescription(response.data['message']);

      } else if (response.statusCode == 200) {
        return GetOTPModel.fromJson(jsonEncode(response.data));
      } else {
         throw ErrorDescription("Login failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return GetOTPModel(status: 'failed', message: e.toString(), data: OtpData(userId: '', phoneNumber: 0, otp: ''));
    }
  }

  static Future<OtpVerifyModel> verifyOtp(String userId, String otp) async {
    try {
      dio.options.connectTimeout = const Duration(milliseconds: 30000);
      
      final response = await dio.post(
        UrlConstants.verifyOtp,
        options: Options(contentType: Headers.jsonContentType),
        data: {
            "userId" : userId,
            "otp" : otp
        },
      );
      
      if (response.statusCode == 200) {
        return OtpVerifyModel.fromJson(jsonEncode(response.data));
      } else {
        throw ErrorDescription("OTP verification failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return OtpVerifyModel(status: 'failed', message: e.toString(), data: VerifyOtpData());
    }
  }

}

