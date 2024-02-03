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
                (ref.reviews.isNotEmpty)
                    ? SizedBox(
                        height: 500,
                        child: ListView.builder(
                            itemCount: ref.reviews.length,
                            itemBuilder: (context, index) {
                              final String storeName =
                                  provider.salonDetails?.data.data.name ??
                                      'No Title';
                              final String title =
                                  ref.reviews[index].review.title ?? 'No Title';
                              final String date =
                                  ref.reviews[index].review.createdAt ??
                                      'No Date';
                              final String discription =
                                  ref.reviews[index].review.description ??
                                      'No Discription';

                              return Container(
                                padding: EdgeInsets.all(4.w),
                                margin: EdgeInsets.only(bottom: 5.w),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsConstant.divider),
                                    borderRadius: BorderRadius.circular(5.sp)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "For : $storeName",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: const Color(0xFF8C9AAC),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 6.w),
                                        SizedBox(width: 1.5.h),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color:
                                                      const Color(0xFF373737),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              date,
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color:
                                                      const Color(0xFF8C9AAC),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    SizedBox(
                                      //height: 10.h,
                                      child: Text(
                                        discription,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: const Color(0xFF8C9AAC),
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Material(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "View More",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: ColorsConstant.appColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
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
                context
                        .read<HomeProvider>()
                        .reviewList
                        .where((review) =>
                            review.salonId == provider.selectedSalonData.id)
                        .isNotEmpty
                    ? ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: context
                            .read<HomeProvider>()
                            .reviewList
                            .where((review) =>
                                review.salonId == provider.selectedSalonData.id)
                            .map((reviewItem) => Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.h),
                                    border: Border.all(
                                      color:
                                          ColorsConstant.reviewBoxBorderColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(
                                          255,
                                          229,
                                          229,
                                          229,
                                        ),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 0.5.h,
                                                bottom: 0.2.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Store : ${reviewItem.salonName}',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  reviewItem.artistName != null
                                                      ? Text(
                                                          'For : ${reviewItem.artistName}',
                                                          style: TextStyle(
                                                            fontSize: 9.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              dense: true,
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  'assets/images/salon_dummy_image.png',
                                                ),
                                              ),
                                              title: Text.rich(
                                                TextSpan(
                                                  text:
                                                      reviewItem.userName ?? "",
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '\n${DateFormat("dd MMMM y").format(reviewItem.createdAt ?? DateTime.now())}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                              (int.parse(reviewItem
                                                                      .rating
                                                                      ?.round()
                                                                      .toString() ??
                                                                  "0"))
                                                          ? ColorsConstant
                                                              .appColor
                                                          : ColorsConstant
                                                              .greyStar,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ReadMoreText(
                                              reviewItem.comment ?? "",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                              ),
                                              trimCollapsedText: "\nView more",
                                              trimExpandedText: "\nView less",
                                              trimLines: 2,
                                              trimMode: TrimMode.Line,
                                              moreStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConstant.appColor,
                                              ),
                                              lessStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsConstant.appColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    : SizedBox(),
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
