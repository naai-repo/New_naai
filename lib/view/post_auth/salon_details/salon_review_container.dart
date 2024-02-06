import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/add_review_component.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class SalonReviewContainer extends StatefulWidget {
  const SalonReviewContainer({super.key});

  @override
  State<SalonReviewContainer> createState() => _SalonReviewContainerState();
}

class _SalonReviewContainerState extends State<SalonReviewContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        final ref = Provider.of<ReviewsProvider>(context, listen: true);
        print(ref.reviews);
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent(),
                Padding(
                  padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (ref.salonReviews.isNotEmpty)
                    ? SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: ref.salonReviews.length,
                    itemBuilder: (context, index) {
                      final String storeName = provider.salonDetails?.data.data.name ?? '';
                      final String title = ref.salonReviews[index].userName ?? '';
                      String date = ref.salonReviews[index].createdAt ?? '';
                      final String discription = ref.salonReviews[index].description ?? '';
                      final String artistName = ref.salonReviews[index].artistName ?? '';
                      bool isExpanded = ref.salonReviews[index].isExpanded ?? false;
                      final int rating =  ref.salonReviews[index].rating ?? 0;
                      if (date != 'No Date') {
                        final DateTime dateTime = DateTime.parse(date);
                        final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                        print('Formatted Date: $formattedDate');
                        date = formattedDate;
                      } else {
                        print('Date is not available');
                      }

                      return Container(
                        padding: EdgeInsets.all(4.w),
                        margin: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstant.divider),
                            borderRadius: BorderRadius.circular(5.sp)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Store : $storeName",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            if(artistName.isNotEmpty && artistName !=null)
                            Text(
                              "For : $artistName",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
                                    radius: 6.w),
                                SizedBox(width: 1.5.h),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF373737),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF8C9AAC),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 1.h,
                                bottom: 1.h,
                              ),
                              child: Row(
                                children: <Widget>[
                                  ...List.generate(
                                    5,
                                        (i) => SvgPicture.asset(
                                      ImagePathConstant
                                          .starIcon,
                                      color: i <
                                          (int.parse(rating.toString()))
                                          ? ColorsConstant
                                          .appColor
                                          : ColorsConstant
                                          .greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              //height: 10.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discription,
                                    softWrap: true,
                                    overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                    maxLines: isExpanded ? null : 1,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  if (isExpanded)
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.salonReviews[index].isExpanded = false;
                                          });
                                        },
                                        child: Text(
                                          "View Less",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  if (!isExpanded)
                                    if (discription.length >= 35)
                                      Material(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              ref.salonReviews[index].isExpanded = true;
                                            });
                                          },
                                          child: Text(
                                            "View More",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: ColorsConstant.appColor,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h,),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 5.h,
          backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 10.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

class SalonReviewContainer2 extends StatefulWidget {
  const SalonReviewContainer2({super.key});

  @override
  State<SalonReviewContainer2> createState() => _SalonReviewContainer2State();
}

class _SalonReviewContainer2State extends State<SalonReviewContainer2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        final ref = Provider.of<ReviewsProvider>(context, listen: true);
        print(ref.reviews);
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddReviewComponent2(),
                Padding(
                  padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                (ref.salonReviews.isNotEmpty)
                    ? SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: ref.salonReviews.length,
                    itemBuilder: (context, index) {
                      final String storeName = provider.salonDetails?.data.data.name ?? '';
                      final String title = ref.salonReviews[index].userName ?? '';
                      String date = ref.salonReviews[index].createdAt ?? '';
                      final String discription = ref.salonReviews[index].description ?? '';
                      final String artistName = ref.salonReviews[index].artistName ?? '';
                      bool isExpanded = ref.salonReviews[index].isExpanded ?? false;
                      final int rating =  ref.salonReviews[index].rating ?? 0;
                      if (date != 'No Date') {
                        final DateTime dateTime = DateTime.parse(date);
                        final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                        print('Formatted Date: $formattedDate');
                        date = formattedDate;
                      } else {
                        print('Date is not available');
                      }

                      return Container(
                        padding: EdgeInsets.all(4.w),
                        margin: EdgeInsets.only(bottom: 5.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorsConstant.divider),
                            borderRadius: BorderRadius.circular(5.sp)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Store : $storeName",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: const Color(0xFF8C9AAC),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            if(artistName.isNotEmpty && artistName !=null)
                              Text(
                                "For : $artistName",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: const Color(0xFF8C9AAC),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
                                    radius: 6.w),
                                SizedBox(width: 1.5.h),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF373737),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF8C9AAC),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 1.h,
                                bottom: 1.h,
                              ),
                              child: Row(
                                children: <Widget>[
                                  ...List.generate(
                                    5,
                                        (i) => SvgPicture.asset(
                                      ImagePathConstant
                                          .starIcon,
                                      color: i <
                                          (int.parse(rating.toString()))
                                          ? ColorsConstant
                                          .appColor
                                          : ColorsConstant
                                          .greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              //height: 10.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discription,
                                    softWrap: true,
                                    overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                    maxLines: isExpanded ? null : 1,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  if (isExpanded)
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.salonReviews[index].isExpanded = false;
                                          });
                                        },
                                        child: Text(
                                          "View Less",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  if (!isExpanded)
                                    if (discription.length >= 35)
                                      Material(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              ref.salonReviews[index].isExpanded = true;
                                            });
                                          },
                                          child: Text(
                                            "View More",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: ColorsConstant.appColor,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h,),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 5.h,
          backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 10.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
      ],
    );
  }
}