import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/verify_model.dart';
import '../utils/api_constant.dart';
import '../utils/loading_indicator.dart';
import '../view/widgets/reusable_widgets.dart';


class OtpVerificationController {
  final Dio dio = Dio();
  String ? name;
  String ? email;
  String ? phoneNumber;
  Future<OtpVerificationResponse> verifyOtp(String userId, String otp, BuildContext context) async {
    try {
      Loader.showLoader(context);
      final response = await dio.post(
        UrlConstants.verifyOtp,
        options: Options(contentType: Headers.jsonContentType),
        data: OtpVerificationRequest(userId: userId, otp: otp).toJson(),
      );
      Loader.hideLoader(context);
      if (response.statusCode == 200) {
        name = response.data['name'];
         email = response.data['email'];
        phoneNumber = response.data['phoneNumber'];
        return OtpVerificationResponse.fromJson(response.data);
      } else {
        Loader.hideLoader(context);
        return OtpVerificationResponse(
          status: 'error',
          message: "OTP verification failed with status code: ${response.statusCode}",
          data: null,
        );
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, 'Something Went Wrong');
      return OtpVerificationResponse(
        status: 'error',
        message: "Error: $e",
        data: null,
      );
    }
  }

}
