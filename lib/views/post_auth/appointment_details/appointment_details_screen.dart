import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/cards/custom_cards.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';

class AppointMentDetailsScreen extends StatelessWidget {
  const AppointMentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back,
                  color: ColorsConstant.textDark,
                ),
              ),
              Text(
                StringConstant.appointmentDetails,
                style: StyleConstant.textDark15sp600Style,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                  color: (1 == 1)
                      ? const Color(0xFFF6DE86)
                      : const Color(0xFF52D185).withOpacity(0.08),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((1 == 1)
                          ? StringConstant.upcoming.toUpperCase()
                          : StringConstant.completed.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: (1 == 1)
                            ? ColorsConstant.textDark
                            : const Color(0xFF52D185),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: '${StringConstant.booked}: ',
                              style: StyleConstant.textLight11sp400Style),
                          TextSpan(
                            text: "Booked",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appointmentOverview(),
                    SizedBox(height: 7.h),
                    textInRow(
                      textOne: StringConstant.customerName,
                      textTwo: 'Customer Name',
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: (1 == 1),
                          replacement: Text(
                            StringConstant.email,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                          child: Text(
                            StringConstant.mobileNumber,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                        ),
                        Visibility(
                          visible: true,
                          replacement: Text('Gmail Id',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                          child: Text('Phone Number',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 16.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.callCustomer,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: SvgPicture.asset(ImagePathConstant.phoneIcon),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 16.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.addToFavourites,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: const Icon(Icons.star_border),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstant.invoice,
                          style: StyleConstant.textDark11sp600Style,
                        ),
                      //  IconButton(onPressed: generateInvoice, icon: Icon(Icons.save_alt_outlined))
                      ],
                    ),
                    SizedBox(height: 40.h),
                    textInRow(
                      textOne: StringConstant.subtotal,
                      textTwo:'Rs ${499}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Visibility(
            visible: true,
            replacement: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: RedButtonWithText(
                buttonText: StringConstant.askForReview,
                onTap: () {},
                fillColor: Colors.white,
                textColor: ColorsConstant.textDark,
                border: Border.all(),
                shouldShowBoxShadow: false,
                padding: EdgeInsets.symmetric(vertical: 15.h),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RedButtonWithText(
                  buttonText: StringConstant.startAppointment,
                  onTap: () {},
                  fillColor: ColorsConstant.textDark,
                  shouldShowBoxShadow: false,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  border: Border.all(color: ColorsConstant.textDark),
                ),

                SizedBox(height: 10.h),

                RedButtonWithText(
                  buttonText: StringConstant.cancel,
                  onTap: () {},
                  fillColor: Colors.white,
                  textColor: ColorsConstant.textDark,
                  border: Border.all(),
                  shouldShowBoxShadow: false,
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
  }

  Widget textInRow({required String textOne,required String textTwo}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textOne,
          style: StyleConstant.textLight11sp400Style,
        ),
        Text(
          textTwo,
          style: StyleConstant.textDark12sp500Style,
        ),
      ],
    );
  }

  Widget appointmentOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurvedBorderedCard(
          fillColor: const Color(0xFFE9EDF7),
          removeBottomPadding: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringConstant.barber,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 50.h),
                Text('Artist Name',
                  style: StyleConstant.textDark12sp600Style,
                ),
                SizedBox(height: 15.h),
                Text(
                  StringConstant.appointmentDateAndTime,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 50.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Date Here",
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      TextSpan(
                        text: ' | ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsConstant.textLight,
                        ),
                      ),
                      TextSpan(
                        text: "Date Here",
                        style: StyleConstant.textDark12sp600Style,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 15.h),
                Text(
                  StringConstant.services,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 5.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index2) => Text(
                      "Service Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    separatorBuilder: (context, index) => const Text(', '),
                    itemCount: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}