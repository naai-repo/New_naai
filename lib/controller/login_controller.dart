import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/login_model.dart';
import '../utils/api_constant.dart';
import '../utils/loading_indicator.dart';
import '../utils/routing/named_routes.dart';
import '../view/widgets/reusable_widgets.dart';
import '../view_model/pre_auth/loginResult.dart';

class LoginController {
  final Dio dio = Dio();

  LoginController() {
    dio.options.connectTimeout = const Duration(milliseconds: 30000);
  }



  Future<Map<String, dynamic>> login(
      LoginModel LoginData, BuildContext context) async {
    try {
      Loader.showLoader(context);
      final response = await dio.post(
        UrlConstants.login,
        data: {
          "phoneNumber": LoginData.phoneNumber,
        },
      );
      Loader.hideLoader(context);

      if (response.data['status'] == 'failed') {
        ReusableWidgets.showFlutterToast(context, 'Something Went Wrong');
        return {
          "status": 'failed',
          "message": response.data['message'],
        };
      } else if (response.statusCode == 200) {
        final userId = response.data['data']['userId'];
        final otp = response.data['data']['otp'];
        print('otp is $otp');

        return {
          "status": 'success',
          "message": 'Login successful!',
          "userId": userId,
          "otp": otp,
        };
      } else {
        ReusableWidgets.showFlutterToast(
            context, 'Something Went Wrong');
        return {
          "status": 'failed',
          "message": "Login failed with status code: ${response.statusCode}",
        };
      }
    } on DioError catch (e) {
      Loader.hideLoader(context);
      if (e.type == DioErrorType.receiveTimeout) {
        ReusableWidgets.showFlutterToast(
            context, 'Connection timeout. Please try again.');
      } else {
        ReusableWidgets.showFlutterToast(
            context, 'An error occurred. Please try again.');
      }
      return {
        "status": 'failed',
        "message": "Error: $e",
      };
    }
  }
}


