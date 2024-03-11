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
  
  static Future<bool> getLocationServicePermission() async {
    bool serviceEnabled = await location.requestService();
    return serviceEnabled;
  }
  
  static Future<void> showLocationDialog(BuildContext context,Function() callback)  async {
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
  }

  
  static Future<bool> handelLocationPermissionUI(BuildContext context) async {
    final ref = Provider.of<LocationProvider>(context,listen: false);

    bool serviceEnabled = await checkServiceIsEnabled();

    if (!serviceEnabled) {
       serviceEnabled = await getLocationServicePermission(); // 1st ask
      //  if(!serviceEnabled){
      //      if(!context.mounted) return false;
      //      // if we want to request again service we will show explainatry dialog for this permission as per policy

      //     await showLocationDialog(context, () {
      //          Navigator.pop(context);
      //      });
      //      print("Setting");
      //      await Future.delayed(Durations.medium1,()async {
      //           serviceEnabled = await getLocationServicePermission(); // 2nd ask
      //      });

      //      print("We are .....");
      //  }
    }

    if(!serviceEnabled){
       print("Service Location Not Enabledd");
       return false;
    }
    
    // check it from local
    bool isPermanentDenied = await ref.getDeniedLocationForever();
    if(isPermanentDenied){
       print("Already Permission For App is Denied Forever");
       // if we want user to reenable it we must go redirect to it to phone settings page as per policy
       return false;
    }
    

    PermissionStatus permission = await location.hasPermission();

    if(permission == PermissionStatus.denied){
        permission = await location.requestPermission(); // 1st ask
        if(permission == PermissionStatus.denied){
            if(!context.mounted) return false;

          // if we want to request again service we will show explainatry dialog for this permission as per guidlines
            await showLocationDialog(context, () {
               Navigator.pop(context);
           });
           await Future.delayed(Durations.medium1,()async {
                  permission = await location.requestPermission(); // 2nd ask
            });

           if(permission == PermissionStatus.deniedForever){
              print("Permission For App is Denied Forever");
              await  ref.setDeniedLocationForever(true);
              return false;
           }
        }

    }

    if(permission == PermissionStatus.granted) return true;
    return false;
  }


  static Future<LatLng> getLocationLatLng() async {
    final res = await location.getLocation();
    return LatLng(res.latitude ?? 28.6304, res.longitude ?? 77.2177);
  }



}