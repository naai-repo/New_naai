import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/utils/constants/colors_constant.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: ColorsConstant.lightAppColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text("BOOKING FOR",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF868686)
                          ),
                         ),
                         SizedBox(height: 10.h),
                         Text("Name Here",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                         ),
                      ],
                    ),
                  )
                ),
                
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text("SERVICE DATE",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF868686)
                          ),
                         ),
                         SizedBox(height: 10.h),
                         Text("Name Here",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                         ),
                      ],
                    ),
                  )
                ),
                
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text("SERVICE TIME",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF868686)
                          ),
                         ),
                         SizedBox(height: 10.h),
                         Text("Name Here",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                         ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("SERVICES",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF868686)
                    ),
                  ),

                  SizedBox(height: 10.h),

                  ...List.generate(5, (index) {
                    return Container(
                       padding: EdgeInsets.all(5.w),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 Text("Service Name",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF373737)
                                    ),
                                ),

                                Text.rich(TextSpan(
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF373737)
                                    ),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(Icons.add,size: 15.sp,color: const Color(0xFFA7A7A7)),
                                    ),
                                    WidgetSpan(child: SizedBox(width: 5.w)),
                                    const TextSpan(text: "Rs. 299")
                                  ]
                                ))
                              ],
                            ),
                           ),

                           SizedBox(height: 10.h),
                           Text("Artist Name",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF373737)
                            ),
                          ),
                        ],
                       ),
                    );
                  }),

                  SizedBox(height: 10.h),
                  Divider(
                    color: ColorsConstant.divider,
                    thickness: 5.w,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                           Text("SUBTOTAL",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF373737)
                            ),
                          ),

                          Text.rich(TextSpan(
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF373737)
                                    ),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(Icons.add,size: 15.sp,color: const Color(0xFFA7A7A7)),
                                    ),
                                    WidgetSpan(child: SizedBox(width: 5.w)),
                                    const TextSpan(text: "Rs. 299")
                                  ]
                            ))
                      ],
                    ),
                  ),
                  
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                           Text.rich(TextSpan(
                            children: [
                              TextSpan(text: "DISCOUNT",
                               style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF373737)
                               )
                              ),
                              WidgetSpan(child: SizedBox(width: 10.w)),
                              TextSpan(text: "25%",
                               style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.lightGreen
                               )
                              ),
                            ]
                           )),
                          Text.rich(TextSpan(
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF373737)
                                    ),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(Icons.remove,size: 15.sp,color: const Color(0xFFA7A7A7)),
                                    ),
                                    WidgetSpan(child: SizedBox(width: 5.w)),
                                    const TextSpan(text: "Rs. 299")
                                  ]
                            ))
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("GRAND TOTAL",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF373737)
                  ),
                ),
                Text("Rs. 9999",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF373737)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}