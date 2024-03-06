import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/models/api_models/salon_item_model.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/post_auth/salon_details/salon_details_screen.dart';
import 'package:provider/provider.dart';

class SalonItemCard extends StatelessWidget {
  final SalonResponseData salon;
  const SalonItemCard({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    String salonName = salon.name ?? "";
    String salonAddress = salon.address ?? "";
    String closedOn = salon.closedOn ?? "";
    Timing timing = salon.timing ?? Timing(opening: "", closing: "");
    double distance = salon.distance ?? 0;
    double rating = salon.rating ?? 5;
    int discount = salon.discount ?? 5;
    List<ImageData> salonImages = salon.images ?? [];

    return Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 20.h),
          child: GestureDetector(
            onTap: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => SalonDetailsScreen(salonDetails: salon)));
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: (salonImages) // Use an empty list if images is null
                        .map((ImageData imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl.url as String, // Cast imageUrl to String
                                  height: 350.h,
                                  width: double.maxFinite,

                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 10.h,
                                right: 10.h,
                                child: SalonSaveIcon(salon: salon),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        salonName,
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        salonAddress,
                        style: TextStyle(
                          color: ColorsConstant.greySalonAddress,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.locationIconAlt,
                            text:"${distance.toStringAsFixed(2)} km",
                            color: ColorsConstant.purpleDistance,
                          ),
                          SizedBox(width: 10.w),
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.starIcon,
                            text: rating.toStringAsFixed(1),
                            color: ColorsConstant.greenRating,
                          ),
                          SizedBox(width: 10.w),
                           (discount == 0) ? const SizedBox() :
                           Container(
                            constraints: BoxConstraints(minWidth: 20.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 3.h,
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsConstant.appColor,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF000000).withOpacity(0.14),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$discount% off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.timings,
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "${timing.opening}-${timing.closing}",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5.w),
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.closed,
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: closedOn,
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        );
  }
}

class SalonSaveIcon extends StatefulWidget {
  final SalonResponseData salon;
  const SalonSaveIcon({super.key,required this.salon});

  @override
  State<SalonSaveIcon> createState() => _SalonSaveIconState();
}

class _SalonSaveIconState extends State<SalonSaveIcon> {
  bool isSaved = false;
  
  @override
  void initState() {
    super.initState();

    final refUser = context.read<AuthenticationProvider>();
    final String salonId = widget.salon.id ?? "";
    bool ans = refUser.userData.favourite?.salons?.contains(salonId) ?? false;
    if(ans) isSaved = true;

  }

  @override
  Widget build(BuildContext context) {
    final refAuth = Provider.of<AuthenticationProvider>(context,listen: false);
    final String salonId = widget.salon.id ?? "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
              onTap: () async {
                try {
                    Loading.showLoding(context);
                    
                    final String userId = await refAuth.getUserId();
                    final String token = await refAuth.getAccessToken();
                    final res = await UserServices.addUserFav(userId: userId, accessToken: token,salonId: salonId);

                    if(res.status == "success"){
                       setState(() {
                         isSaved = !isSaved;
                         refAuth.setUserFavroteSalonId(salonId);
                       });
                    }
                } catch (e) {
                  if(context.mounted){
                    showErrorSnackBar(context, "Something went wrong");
                  }
                }finally {
                    if(context.mounted){
                      Loading.closeLoading(context);
                    }
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon((!isSaved) ? CupertinoIcons.heart : CupertinoIcons.heart_fill,
                  size: 25.h,
                  color: ColorsConstant.appColor,
                ),
              ),
            ),
    );
  }
}

