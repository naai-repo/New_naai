import '../models/update_user_model.dart';
import '../utils/loading_indicator.dart';
import '../view/widgets/reusable_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/api_constant.dart';



class UpdateUserController {
  final Dio dio = Dio();

  Future<UpdateUserResponse> updateUser(String userId, Map<String, dynamic> userData, BuildContext context) async {
    try {
      Loader.showLoader(context);

      final response = await dio.post(
        UrlConstants.updateUser,
        options: Options(contentType: Headers.jsonContentType),
        data: UpdateUserRequest(userId: userId, data: userData).toJson(),
      );

      Loader.hideLoader(context);

      if (response.statusCode == 200) {
        return UpdateUserResponse.fromJson(response.data);
      } else {
        return UpdateUserResponse(
          status: 'error',
          message: "User update failed with status code: ${response.statusCode}",
          data: UpdateUserData(
            acknowledged: false,
            modifiedCount: 0,
            upsertedId: null,
            upsertedCount: 0,
            matchedCount: 0,
          ),
        );
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, 'Something Went Wrong');
      return UpdateUserResponse(
        status: 'error',
        message: "Error: $e",
        data: UpdateUserData(
          acknowledged: false,
          modifiedCount: 0,
          upsertedId: null,
          upsertedCount: 0,
          matchedCount: 0,
        ),
      );
    }
  }
}