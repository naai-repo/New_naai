import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../routing/named_routes.dart';

class AddReviewComponent extends StatefulWidget {
  final bool reviewForSalon;

  const AddReviewComponent({
    super.key,
    this.reviewForSalon = true,
  });

  @override
  State<AddReviewComponent> createState() => _AddReviewComponentState();
}

class _AddReviewComponentState extends State<AddReviewComponent> {
  int selectedStarIndex = -1;
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 5.w,
      ),
      decoration: BoxDecoration(
        color: ColorsConstant.graphicFillDark,
        borderRadius: BorderRadius.circular(2.h),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 5.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 5.w),
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
              SizedBox(width: 5.w),
            ],
          ),
          SizedBox(height: 3.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 6.h,
              maxHeight: 19.h,
            ),
            child: TextFormField(
              controller: reviewTextController,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () async {
              if (widget.reviewForSalon) {
                await context.read<SalonDetailsProvider>().submitReview2(
                      context,
                      stars: selectedStarIndex + 1,
                      text: reviewTextController.text.trim(),
                    );
              } else {
                await context.read<BarberProvider>().submitReview2(
                      context,
                      stars: selectedStarIndex + 1,
                      text: reviewTextController.text.trim(),
                    );
              }
              setState(() {
                selectedStarIndex = -1;
                reviewTextController.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 1.5.h,
                horizontal: 10.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              child: Text(
                StringConstant.submitReview,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
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


class AddReviewComponent2 extends StatefulWidget {
  final bool reviewForSalon;

  const AddReviewComponent2({
    super.key,
    this.reviewForSalon = true,
  });

  @override
  State<AddReviewComponent2> createState() => _AddReviewComponent2State();
}

class _AddReviewComponent2State extends State<AddReviewComponent2> {
  int selectedStarIndex = -1;
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 5.w,
      ),
      decoration: BoxDecoration(
        color: ColorsConstant.graphicFillDark,
        borderRadius: BorderRadius.circular(2.h),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 5.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 5.w),
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
              SizedBox(width: 5.w),
            ],
          ),
          SizedBox(height: 3.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 6.h,
              maxHeight: 19.h,
            ),
            child: TextFormField(
              controller: reviewTextController,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () {
              showSignInDialog(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 1.5.h,
                horizontal: 10.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              child: Text(
                StringConstant.submitReview,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                  color: ColorsConstant.appColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 60,
                    width:60
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please Sign In",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "You need to sign in first to see our conditionals",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    child: Text("OK",style: TextStyle( color:Colors.black,)),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                          NamedRoutes.authenticationRoute
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}