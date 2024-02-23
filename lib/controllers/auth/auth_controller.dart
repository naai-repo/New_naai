import 'package:flutter/material.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:provider/provider.dart';

class AuthenticationConroller {
  static Future<void> setUserDetails(BuildContext context,String userId) async {
    final res = await UserServices.getUserByID(userId: userId);
    if(context.mounted) context.read<AuthenticationProvider>().setUserData(res.data!);
  }
}