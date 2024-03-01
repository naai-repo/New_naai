import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/controllers/auth/auth_controller.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/users/user_services.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/views/pre_auth/signin_container/signin_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<AuthenticationProvider>(context,listen: false);

    return SafeArea(
      child: Scaffold(
            body: Stack(
              children: [
                CommonWidget.appScreenCommonBackground(),
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CommonWidget.transparentFlexibleSpace(),
                    SliverAppBar(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.h),
                          topRight: Radius.circular(30.h),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      surfaceTintColor: Colors.white,
                      title: Container(
                        padding: EdgeInsets.only(bottom: 20.h,top: 20.h),
                        child: Text(
                          StringConstant.yourProfile,
                          style: StyleConstant.headingTextStyle,
                        ),
                      ),
                      centerTitle: false,
                    ),
                    SliverFillRemaining(
                      child: Container(
                        color: Colors.white,
                        child: (!(ref.authData.isGuest ?? false)) ? Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                       //   context.read<ProfileProvider>().uploadProfileImage(context);
                                        },
                                        child: Container(
                                          height: 70.h,
                                          width: 70.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorsConstant.lightAppColor,
                                            // border: Border.fromBorderSide(LinearBorder.top())
                                          ),
                                          child:  (ref.userData.imageUrl?.isEmpty ?? true) ? const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ) : CircleAvatar(
                                             radius: 10.r,
                                             backgroundImage: NetworkImage(ref.userData.imageUrl ?? ""),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.w),
                                  userDetailsWithEditButton(),
                                ],
                              ),
                              SizedBox(height: 30.h),
                              Column(
                                children: [
                                  // profileOptions(
                                  //   onTap: () => Navigator.pushNamed(
                                  //     context,
                                  //     NamedRoutes.reviewsRoute,
                                  //   ),
                                  //   imagePath: ImagePathConstant.reviewsIcon,
                                  //   optionTitle: StringConstant.reviews,
                                  // ),
                                  // profileOptions(
                                  //   onTap: () => Navigator.pushNamed(
                                  //     context,
                                  //     NamedRoutes.favouritesRoute,
                                  //   ),
                                  //   imagePath: ImagePathConstant.saveIcon,
                                  //   optionTitle: StringConstant.favourties,
                                  // ),
                                  // profileOptions(
                                  //   onTap: () => Navigator.pushNamed(
                                  //     context,
                                  //     NamedRoutes.bookingHistoryRoute,
                                  //   ),
                                  //   imagePath: ImagePathConstant.bookingHistoryIcon,
                                  //   optionTitle: StringConstant.bookingHistory,
                                  // ),
                                  profileOptions(
                                    onTap: () {
                                      launchUrl(
                                        Uri.parse(
                                            'https://www.instagram.com/naaiindia'),
                                      );
                                    },
                                    imagePath: ImagePathConstant.informationIcon,
                                    optionTitle: StringConstant.more,
                                  ),
                                  profileOptions(
                                    onTap: () {
                                        showDeleteDialog(context);
                                      },
                                    imagePath: ImagePathConstant.deleteIcon,
                                    optionTitle: StringConstant.deleteAccount,
                                  ),
                                  profileOptions(
                                    onTap: () {
                                       showLogoutDialog(context);
                                    },
                                    imagePath: ImagePathConstant.logoutIcon,
                                    optionTitle: StringConstant.logout,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ) : const SignInContainer(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
      
  }

  Widget userDetailsWithEditButton() {
    final ref = context.read<AuthenticationProvider>();
    String userName = ref.userData.name ?? "name_here";
    String phoneNumer = ref.userData.phoneNumber.toString();
    String userEmail = ref.userData.email ?? "";
    String userContact = (phoneNumer.isNotEmpty) ? phoneNumer : userEmail;
  
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: StyleConstant.textDark15sp600Style),
                  Text(userContact,
                    style: TextStyle(
                      color: ColorsConstant.textLight,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 3.w),
              // GestureDetector(
              //   onTap: () async {
              //     context.read<ProfileProvider>().uploadProfileImage(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(1.1.h),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           offset: Offset(2, 2),
              //           color: Colors.grey.shade300,
              //           spreadRadius: 0.5,
              //           blurRadius: 15,
              //         ),
              //       ],
              //     ),
              //     child: SvgPicture.asset(
              //       ImagePathConstant.pencilIcon,
              //     ),
              //   ),
              // ),
            ],
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
          //   margin: EdgeInsets.only(top: 1.5.h),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: ColorsConstant.incompleteProfileBoxBorderColor,
          //     ),
          //     borderRadius: BorderRadius.circular(1.h),
          //     color: ColorsConstant.incompleteProfileBoxColor,
          //   ),
          //   child: Text(
          //     StringConstant.incompleteProfile,
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 10.sp,
          //       color: ColorsConstant.textDark,
          //     ),
          //   ),
          // ),
        ],

      );

  }

  Widget profileOptions({required Function() onTap,required String imagePath,required String optionTitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: optionTitle == StringConstant.logout
                  ? Colors.white
                  : ColorsConstant.graphicFillDark,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  imagePath,
                  height: 20.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  optionTitle,
                  style: TextStyle(
                      color: ColorsConstant.textDark,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                ),
              ],
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.textDark,
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 80.h,
              width: 80.h,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Delete your Account?',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20.sp
                  ),
                ),
                SizedBox(height: 8.h),
                const Text(
                  "If you select Delete, we will delete your account on our server. Your app data will also be deleted, and you won't be able to retrieve it.",
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
               //   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the pop-up.
                      },
                    ),
                    SizedBox(width: 15.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.appColor, // Change the button's background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          Loading.showLoding(context);
                          final ref = context.read<AuthenticationProvider>();
                          String token = await ref.getAccessToken();
                          await ref.logout();
                          await UserServices.deleteUser(accessToken: token);
                          if(context.mounted) await context.read<LocationProvider>().resetAll();
                          if(context.mounted) context.read<BottomChangeScreenIndexProvider>().setScreenIndex(0);
                          Future.delayed(Durations.medium1,(){
                            Navigator.pushNamedAndRemoveUntil(context, NamedRoutes.splashRoute, (route) => false);
                          });
                        } catch (e) {
                          if(context.mounted){
                            showErrorSnackBar(context, "Something Went Wrong");
                          }
                        }finally{
                          if(context.mounted){
                              Loading.closeLoading(context);
                          }
      }
                      },
                      child: const Text('Delete',
                       style: TextStyle(
                        color: Colors.white
                       ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  void showLogoutDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 80.h,
              width: 80.h,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Are You Sure You Want to Logout?',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16.sp
                  ),
                ),
                // SizedBox(height: 8.h),
                // const Text(
                //   "If you select Delete, we will delete your account on our server. Your app data will also be deleted, and you won't be able to retrieve it.",
                // ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
               //   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the pop-up.
                      },
                    ),
                    SizedBox(width: 15.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.appColor, // Change the button's background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () async {
                         await AuthenticationConroller.logout(context);
                      },
                      child: const Text('Logout',
                       style: TextStyle(
                        color: Colors.white
                       ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}