import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/views/post_auth/artist_details/artist_details_screen.dart';


class ArtistCard extends StatelessWidget {
  final TopArtistResponseModel artist;
  final int index;
  final bool isAlternate;
  const ArtistCard({super.key,required this.artist,required this.index,required this.isAlternate});

  @override
  Widget build(BuildContext context) {
      String artistName = artist.artistDetails?.name ?? "";
      String salonName = artist.salonDetails?.data?.data?.name ?? "";
      String imgUrl = artist.artistDetails?.imageUrl ?? "";
      double distance = artist.artistDetails?.distance ?? 0;
      double rating = artist.artistDetails?.rating ?? 5;

      

      return Padding(
        padding: EdgeInsets.only(right: 10.w),
          child: CurvedBorderedCard(
            borderColor: const Color(0xFFDBDBDB),
            fillColor: (isAlternate) ? index.isEven ? const Color(0xFF212121) : Colors.white : Colors.white,
            child: Container(
              padding: EdgeInsets.all(10.w),
              constraints: BoxConstraints(maxWidth: 190.w),
              width: 190.w,
              child: GestureDetector(
                onTap: () async {
                     Navigator.push(context, MaterialPageRoute(builder: (_) =>  ArtistDetailScreen(artistId: artist.artistDetails?.id ?? "",)));
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.h),
                                child: (imgUrl.isNotEmpty) ? CircleAvatar(
                                  radius: 50.h,
                                  backgroundImage: NetworkImage(
                                    imgUrl
                                  ),
                                ) : CircleAvatar(
                                  radius: 50.h,
                                  backgroundColor: ColorsConstant.lightAppColor,
                                ),
                              ),
                              Text(
                                artistName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: (isAlternate) ? index.isOdd ? ColorsConstant.textDark : Colors.white : ColorsConstant.textDark,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                salonName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorsConstant.textLight,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.locationIconAlt,
                                          color: ColorsConstant.purpleDistance,
                                          height: 20.h,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 5.w),
                                      ),
                                      TextSpan(
                                      text: "${distance.toStringAsFixed(2)} km",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp,
                                          color: ColorsConstant.purpleDistance,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.starIcon,
                                          color: ColorsConstant.greenRating,
                                          height: 18.h,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 5.w),
                                      ),
                                      TextSpan(
                                        text: rating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp,
                                          color: ColorsConstant.greenRating,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
      
                        },
                        child: SvgPicture.asset(ImagePathConstant.saveIcon,
                          color: ColorsConstant.appColor,
                          height: 25.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      );
  }
}