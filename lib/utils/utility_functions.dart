import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';

class UtilityFunctions {
  /// Method to generate the complete image path from [imageTitle]
  static String getImagePath({required String imageTitle}) {
    return StringConstant.imageBaseDirectory + imageTitle;
  }

  /// Query parameters for address suggestions from search text
  static Map<String, dynamic> mapSearchQueryParameters() {
    return {
      'proximity': 'ip',
      'limit': '10',
      'language': 'en-gb',
      'autocomplete': 'true',
      'fuzzyMatch': 'true',
      'access_token': "pk.eyJ1IjoibXlwZXJybyIsImEiOiJjbDRmZGVwNmwwMjlmM3BvZm02czd5ZWhlIn0.vjixPEoZnR1G6QmKxMva2w",
    };
  }

   static changeSystemBarToRed(){
      SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: ColorsConstant.appColor,
          statusBarColor: ColorsConstant.appColor
      )
     );
   }

   static changeSystemBarReset(){
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.black
        )
     );
   }
}


void showErrorSnackBar(BuildContext context,String message){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: ColorsConstant.appColor,
    content: Text(message,style: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15.sp,
      color: Colors.white
    ))
   ));
}