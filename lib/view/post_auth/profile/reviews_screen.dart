import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/review.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.h),
                        topRight: Radius.circular(3.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                                height: 2.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            StringConstant.ratingsAndReviews,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 2.h, right: 5.w, left: 5.w),
                      child: FutureBuilder<List<Review>>(
                        future: provider.getUserReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.requireData.isEmpty
                                ? Center(
                                    child: Text("No Reviews Yet!"),
                                  )
                                : Column(
                                    children:
                                        snapshot.requireData.map((reviewItem) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 1.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(1.h),
                                          border: Border.all(
                                            color: ColorsConstant
                                                .reviewBoxBorderColor,
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
                                                          CrossAxisAlignment
                                                              .start,
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
                                                        reviewItem.artistName !=
                                                                null
                                                            ? Text(
                                                                'For : ${reviewItem.artistName}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      9.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              )
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                  ListTile(
                                                    minLeadingWidth: 0,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    dense: true,
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/images/salon_dummy_image.png',
                                                      ),
                                                    ),
                                                    title: Text.rich(
                                                      TextSpan(
                                                        text: reviewItem
                                                                .userName ??
                                                            "",
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '\n${DateFormat("dd MMMM y").format(reviewItem.createdAt ?? DateTime.now())}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                          (i) =>
                                                              SvgPicture.asset(
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
                                                    trimCollapsedText:
                                                        "\nView more",
                                                    trimExpandedText:
                                                        "\nView less",
                                                    trimLines: 2,
                                                    trimMode: TrimMode.Line,
                                                    moreStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsConstant
                                                          .appColor,
                                                    ),
                                                    lessStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsConstant
                                                          .appColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
