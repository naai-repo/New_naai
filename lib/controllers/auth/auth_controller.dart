import 'package:flutter/material.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:provider/provider.dart';

class AuthenticationConroller {
  
  static Future<void> setUserDetails(BuildContext context,String userId) async {
    final res = await UserServices.getUserByID(userId: userId);
    if(context.mounted) context.read<AuthenticationProvider>().setUserData(res.data!);
  }

  static Future<void> logout(BuildContext context) async {
    try {
        Loading.showLoding(context);
        final ref = context.read<AuthenticationProvider>();

        await ref.logout();
        if(context.mounted) await context.read<LocationProvider>().resetAll();
        if(context.mounted) context.read<BottomChangeScreenIndexProvider>().setScreenIndex(0);

        Future.delayed(Durations.medium1,(){
          Navigator.pushNamedAndRemoveUntil(context, NamedRoutes.splashRoute, (route) => false);
        });
      } catch (e) {
        if(context.mounted){
          showErrorSnackBar(context, "Something Went Wrong");
        }
      }finally{
        if(context.mounted){
            Loading.closeLoading(context);
        }
      }
  }

}