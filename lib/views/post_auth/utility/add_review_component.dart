import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/reviews_item_model.dart';
import 'package:naai/models/api_models/user_model.dart';
import 'package:naai/models/utility/reviews_username_model.dart';
import 'package:naai/providers/post_auth/reviews_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/reviews/reviews_services.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/pre_auth/signin_container/signin_container.dart';
import 'package:provider/provider.dart';

class AddReviewComponent extends StatefulWidget {
  final bool reviewForSalon;
  final String salonId;
  final String artistId;

  const AddReviewComponent({
    super.key,
    this.reviewForSalon = true,
    this.salonId = "",
    this.artistId = ""
  });

  @override
  State<AddReviewComponent> createState() => _AddReviewComponentState();
}

class _AddReviewComponentState extends State<AddReviewComponent> {
  int selectedStarIndex = -1;
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<AuthenticationProvider>(context,listen: false);
    bool isGuest = ref.authData.isGuest ?? false;

    if(isGuest){
       return const SignInContainer(text: "Please create your account to add your Review.",);
    }


    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: ColorsConstant.graphicFillDark,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 10.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 10.w),
              ...List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () => setState(() {
                    selectedStarIndex = index;
                  }),
                  child: SvgPicture.asset(
                    ImagePathConstant.reviewStarIcon,
                    color: selectedStarIndex >= index
                        ? ColorsConstant.yellowStar
                        : ColorsConstant.reviewStarGreyColor,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 30.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 60.h,
              maxHeight: 190.h,
            ),
            child: TextFormField(
              controller: reviewTextController,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () async {
              try {
                Loading.showLoding(context);
                if(selectedStarIndex == -1) throw ErrorDescription("Please Select Rating");
                if(reviewTextController.text.isEmpty) throw ErrorDescription("Please Type Review");
                final authRef = context.read<AuthenticationProvider>();
                String token = authRef.authData.accessToken ?? "";
                ReviewData res;
                if(widget.reviewForSalon){
                  res = await ReviewsServices.addReviewToSalon(accessToken: token,discription: reviewTextController.text,rating: selectedStarIndex + 1,salonId:  widget.salonId);
                }else{
                  res = await ReviewsServices.addReviewToArtist(accessToken: token,discription: reviewTextController.text,rating: selectedStarIndex + 1,artistId: widget.artistId);
                }
                
                if(!context.mounted) return;

                context.read<ReviewsProvider>().addReview(ReviewsModel(
                  reviews: ReviewItem(review: res, replies: []),
                  user: UserResponseModel(
                    data: authRef.userData
                  )
                ));

                setState(() {
                  selectedStarIndex = -1;
                  reviewTextController.clear();
                });
              } catch (e) {
                  if(context.mounted){
                    showErrorSnackBar(context, e.toString());
                  }
              }finally{
                if(context.mounted){
                  Loading.closeLoading(context);
                  FocusManager.instance.primaryFocus!.unfocus();
                }
              }
              
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 30.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.h),
              ),
              child: Text(
                StringConstant.submitReview,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: ColorsConstant.appColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
