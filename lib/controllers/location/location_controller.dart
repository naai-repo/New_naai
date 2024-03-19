import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:provider/provider.dart';

class LocationController {
  static final location = Location();

  static Future<bool> getGeoPermission() async {
      PermissionStatus permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) return false;
      if (permission == PermissionStatus.deniedForever) return false;
      return true;
  }

  static Future<bool> checkGeoPermission() async {
    PermissionStatus permission = await location.hasPermission();
     if(permission == PermissionStatus.denied) return false;
     if(permission == PermissionStatus.deniedForever) return false;
     return true;
  }
  
  static Future<bool> checkServiceIsEnabled() async {
    bool serviceEnabled = await location.serviceEnabled();
    return serviceEnabled;
  }
  
  
  static Future<void> showLocationDialog(BuildContext context,Function() callback)  async {
    print("show Location Diaglog");

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 50.h,
              width: 50.w,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Location Not Enabled !',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20.sp
                  ),
                ),
                SizedBox(height: 8.h),
                const Text(
                  "App requires a Location For Finding best Near Salons Around You to Explore. By any chance If you not able to allow the permission for location now still you can change it from app settings manually.",
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
               //   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   child: const Text(
                    //     'Cancel',
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pop(); // Close the pop-up.
                    //   },
                    // ),
                    SizedBox(width: 15.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.appColor, // Change the button's background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: callback,
                      child: const Text('ok',
                       style: TextStyle(
                        color: Colors.white
                       ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    print("closed Location Dialog");
  }

  static Future<void> showOpenSettingsDialog(BuildContext context,Function() callback)  async {
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 50.h,
              width: 50.w,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Location Not Enabled !',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20.sp
                  ),
                ),
                SizedBox(height: 8.h),
                const Text(
                  "The app requires location access to find the best nearby salons for you to explore. If you're unable to grant permission for location at the moment, you can still change it manually from the app settings later on.",
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
               //   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   child: const Text(
                    //     'Cancel',
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pop(); // Close the pop-up.
                    //   },
                    // ),
                    SizedBox(width: 15.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.appColor, // Change the button's background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: callback,
                      child: const Text('Open App Settings',
                       style: TextStyle(
                        color: Colors.white
                       ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    print("closed Location Dialog");
  }
  
  static Future<void> checkNoti(Function getNoti) async {
     await Future.doWhile(() async{
          await Future.delayed(const Duration(milliseconds: 400));
          final res = getNoti();
          print("Permission From Check Noti ${res}");
          if(res == AppLifecycleState.resumed) return false;
          return true;
     });
  }
  static Future<bool> getLocationServicePermission(BuildContext context,int cnt) async {
    if(cnt >= 2) return false;
    bool serviceEnabled = await location.requestService();
    if(serviceEnabled) return true;
    if(cnt == 0 && !serviceEnabled) await showLocationDialog(context,() => Navigator.pop(context));
    bool res = await getLocationServicePermission(context,cnt + 1);
    if(res) return true;
    return false;
  }
  
  static Future<bool> handelLocationPermissionUI(BuildContext context,Function getNoti) async {
    final ref = Provider.of<LocationProvider>(context,listen: false);

    bool serviceEnabled = await checkServiceIsEnabled();
    serviceEnabled = await getLocationServicePermission(context,0);

    if(!serviceEnabled){
       print("Service Location Not Enabled");
       return false;
    }
    
    // check it from local
    bool isPermanentDenied = await ref.getDeniedLocationForever();
    PermissionStatus permission = await location.hasPermission();
   
    if(isPermanentDenied && permission != PermissionStatus.granted){
       print("Already Permission For App is Denied Forever");

       // if we want user to reenable it we must go redirect to it to phone settings page as per policy
       await showOpenSettingsDialog(context,() async {
            await AppSettings.openAppSettings(type: AppSettingsType.settings);
            await checkNoti(getNoti);
            Navigator.pop(context);
       });
       PermissionStatus per = await location.hasPermission();
       permission = per;
       if(per != PermissionStatus.granted) return false;
    }
    
    print("Permmmmm ${permission}");

    if(permission == PermissionStatus.denied){
        permission = await location.requestPermission(); // 1st ask
        if(permission == PermissionStatus.denied){
            if(!context.mounted) return false;

          // if we want to request again service we will show explainatry dialog for this permission as per guidlines
           await showLocationDialog(context, () {
               Navigator.pop(context);
           });
           await Future.delayed(Durations.medium1,() async {
                  permission = await location.requestPermission(); // 2nd ask
           });

           if(permission == PermissionStatus.deniedForever){
              print("Permission For App is Denied Forever");
              await  ref.setDeniedLocationForever(true);
              return false;
           }
        }
    }

    if(permission == PermissionStatus.granted){
      await ref.setDeniedLocationForever(false);
      return true;
    }
    return false;
  }


  static Future<LatLng> getLocationLatLng() async {
    final res = await location.getLocation();
    return LatLng(res.latitude ?? 28.6304, res.longitude ?? 77.2177);
  }



}