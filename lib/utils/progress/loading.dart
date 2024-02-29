import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';

class Loading {

  static Future<void> showLoding(BuildContext context) {
    setbar();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            children: [
              Center(
                child: Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: CircularProgressIndicator(
                      color: ColorsConstant.appColor,
                      strokeWidth: 3.sp,
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  static setbar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
         // statusBarColor: Color.fromARGB(255, 50, 28, 87),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color.fromARGB(255, 127, 127, 129)),
    );
  }

  static removebar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white
      ),
    );
  }

  static void closeLoading(BuildContext context) {
    try {
      removebar();
      return Navigator.of(context).pop();
    } catch (e) {
      return;
    }
  }
}
