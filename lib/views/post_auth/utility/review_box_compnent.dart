import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';
import 'package:naai/providers/post_auth/reviews_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/utility/add_review_component.dart';
import 'package:provider/provider.dart';

class ReviewContainer extends StatelessWidget {
  final SingleArtistScreenModel? artistDetails;
  final SingleSalonResponseModel? salonDetails;
  final bool isForSalon;
  const ReviewContainer({super.key,this.artistDetails,this.salonDetails,this.isForSalon = false});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<ReviewsProvider>(context,listen: true);
    late String salonId,artistId;

    if(isForSalon){
      salonId = salonDetails?.data?.data?.id ?? "";
      artistId = "";
    }else{
      salonId = artistDetails?.salonDetails?.data?.data?.id ?? "";
      artistId = artistDetails?.artistDetails?.data?.id ?? "";
    }
    
 
    return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddReviewComponent(reviewForSalon: isForSalon,salonId: (isForSalon) ? salonId : "",artistId: (!isForSalon) ? artistId : ""),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    StringConstant.userReviews,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorsConstant.blackAvailableStaff,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                (ref.reviews.isNotEmpty)
                    ? SizedBox(
                      child: ListView.builder(
                      itemCount: ref.reviews.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                       final String salonName,artistName;

                       if(isForSalon){
                          salonName = salonDetails?.data?.data?.name ?? 'No Title';
                          artistName = "";
                       }else{
                          salonName = artistDetails?.salonDetails?.data?.data?.name ?? 'No Title';
                          artistName = artistDetails?.artistDetails?.data?.name ?? 'No Title';
                       }
                       

                       final String title = ref.reviews[index].user?.data?.name ?? 'No Title';
                       final String date = ref.reviews[index].reviews?.review.createdAt ?? 'No Date';
                       final int rating = ref.reviews[index].reviews?.review.rating ?? 0;
                       final String discription = ref.reviews[index].reviews?.review.description ?? 'No Discription';
                      String userImageUrl = ref.reviews[index].user?.data?.imageUrl ?? "";
                       final DateTime dateTime = DateTime.parse(date.replaceAll("-", ""));
                       final String dateString = "${DateFormat.d().format(dateTime)} ${DateFormat.MMM().format(dateTime)} ${DateFormat.y().format(dateTime)}";
                       if(userImageUrl.isEmpty) userImageUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                        

                       return Container(
                          padding: EdgeInsets.all(12.w),
                          margin: EdgeInsets.only(bottom: 14.w),
                          decoration: BoxDecoration(
                          border: Border.all(color: ColorsConstant.divider),
                          borderRadius: BorderRadius.circular(10.sp)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                   if(salonName.isNotEmpty)
                                   Text(
                                       "Salon : $salonName",
                                       style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500
                                       ),
                                   ),
                                   SizedBox(height: 5.h),
                                   if(artistName.isNotEmpty)
                                   Text(
                                       "For : $artistName",
                                       style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF8C9AAC),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500
                                       ),
                                   ),
                                   SizedBox(height: 10.h),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      (userImageUrl.isNotEmpty) ? ClipRRect(
                                        borderRadius: BorderRadius.circular(25.r),
                                        child: Image.network(userImageUrl,height: 50.h,width: 50.w,fit: BoxFit.fill),
                                      ) : CircleAvatar(backgroundColor: Colors.grey,radius: 25.r),
                                      SizedBox(width: 15.h),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              title,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: const Color(0xFF373737),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600
                                              ),
                                          ),
                                          Text(
                                              dateString,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: const Color(0xFF8C9AAC),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400
                                              ),
                                          ),
                                        ],
                                      )
                                    ],
                                   ),
                                   SizedBox(height: 10.h),
                                   Row(
                                      children: [
                                        ...List.generate(5,
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
                                   SizedBox(height: 20.h),
                                   ReviewDiscription(discription: discription)
                              ],
                          ),
                       );
                    }),)
                    : const SizedBox(),
              ],
            ),
          ),
        );

  }
}


class ReviewDiscription extends StatefulWidget {
  final String discription;
  const ReviewDiscription({super.key,required this.discription});

  @override
  State<ReviewDiscription> createState() => _ReviewDiscriptionState();
}

class _ReviewDiscriptionState extends State<ReviewDiscription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool viewMoreWillBeShown = (widget.discription.length > 35);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(
                child: Text(
                          widget.discription,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: (isExpanded) ? 20 : 2,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: const Color(0xFF8C9AAC),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400
                          ),
                      ),
                ),
              if(viewMoreWillBeShown) SizedBox(height: 2.h,),
              if(viewMoreWillBeShown) Material(
                child: InkWell(
                  onTap: () async{
                    setState(() {
                       isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                          (!isExpanded) ? "View More" : "View Less",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: ColorsConstant.appColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500
                          ),
                      ),
                ),
              )

      ],
    );
  }
}
