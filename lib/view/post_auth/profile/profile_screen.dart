import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/Profile_model.dart';
import '../../../models/user.dart';
import '../../../utils/access_token.dart';
import '../../../utils/loading_indicator.dart';
import '../../../view_model/post_auth/home/home_provider.dart';
import '../../../view_model/pre_auth/loginResult.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    _getUserDetails();
//    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
 //     context.read<ProfileProvider>().getUserDataFromUserProvider(context);
 //   });
  //  super.initState();
  }

  Future<void> _getUserDetails() async {
    final box = await Hive.openBox('userBox');
    final userId = box.get('userId') ?? '';
    if (userId.isNotEmpty) {
      print('Retrieved userId from Hive: $userId');
      try {
        final response = await Dio().get(
          'http://13.235.49.214:8800/customer/user/$userId',
        );

        if (response.data != null && response.data is Map<String, dynamic>) {
          ProfileResponse apiResponse = ProfileResponse.fromJson(response.data);

          if (apiResponse != null && apiResponse.data != null) {
            // Save the user details in the provider
            context.read<ProfileProvider>().setUserData(apiResponse.data);
          } else {
            // Handle the case where the response or data is null
            print('Failed to fetch user details: Invalid response format');
          }
        } else {
          // Handle the case where the response is null or not of the expected type
          print('Failed to fetch user details: Invalid response format');
        }
      } catch (error) {
        Loader.hideLoader(context);
        // Handle the case where the API call was not successful
        // You can show an error message or take appropriate action
        print('Failed to fetch user details: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
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
                    title: Container(
                      padding: EdgeInsets.only(bottom: 2.h),
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
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 2.h, right: 5.w, left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipOval(
                                      child: CircleAvatar(
                                        radius: 7.h,
                                        backgroundImage: AssetImage('assets/images/dummy_user.jpg'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                     //   context.read<ProfileProvider>().uploadProfileImage(context);
                                      },
                                      child: Container(
                                        height: 7.h,
                                        width: 7.w,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white70,
                                          // border: Border.fromBorderSide(LinearBorder.top())
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 4.w),
                                userDetailsWithEditButton(),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Column(
                              children: <Widget>[
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.reviewsRoute,
                                  ),
                                  imagePath: ImagePathConstant.reviewsIcon,
                                  optionTitle: StringConstant.reviews,
                                ),
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.favouritesRoute,
                                  ),
                                  imagePath: ImagePathConstant.saveIcon,
                                  optionTitle: StringConstant.favourties,
                                ),
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.bookingHistoryRoute,
                                  ),
                                  imagePath:
                                      ImagePathConstant.bookingHistoryIcon,
                                  optionTitle: StringConstant.bookingHistory,
                                ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath: ImagePathConstant.referralIcon,
                                //   optionTitle: StringConstant.referral,
                                // ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath:
                                //       ImagePathConstant.salonRegistrationIcon,
                                //   optionTitle: StringConstant.salonRegistration,
                                // ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath: ImagePathConstant.settingsIcon,
                                //   optionTitle: StringConstant.settings,
                                // ),
                                profileOptions(
                                  onTap: () => launchUrl(
                                    Uri.parse(
                                        'https://www.instagram.com/naaiindia'),
                                  ),
                                  imagePath: ImagePathConstant.informationIcon,
                                  optionTitle: StringConstant.more,
                                ),
                                profileOptions(
                                  onTap: () {
                                    showDeleteDialog(context,provider);
                                    },
                                  imagePath: ImagePathConstant.deleteIcon,
                                  optionTitle: StringConstant.deleteAccount,
                                ),
                                profileOptions(
                                  onTap: () =>
                                      provider.handleLogoutClick(context),
                                  imagePath: ImagePathConstant.logoutIcon,
                                  optionTitle: StringConstant.logout,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteDialog(context, provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 80,
              width: 80,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete your Account?',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "If you select Delete, we will delete your account on our server. Your app data will also be deleted, and you won't be able to retrieve it.",

                ),
                SizedBox(height: 1.5.h),
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
                    SizedBox(width: 1.5.h),
                    ElevatedButton(
                      child: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        primary: ColorsConstant.appColor, // Change the button's background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                       deleteAccountAndUserData(context);
                      },
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

  Future<void> deleteUserAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');

    } catch (e) {
      print('General exception: $e');
      // Handle general exception
    }
  }


  Future<void> deleteAccount() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the user document from 'userData' collection using the UID
        await FirebaseFirestore.instance
            .collection('users') // Replace with your collection name
            .doc(user.uid) // Use the UID as the document ID
            .delete();

        // Delete the user account from Firebase Authentication
        await user.delete();

        print('Account deleted successfully!');
      }
    } catch (e) {
      print('Error deleting account: $e');
      // Handle any errors that might occur during the deletion process
    }
  }

  Future<void> deleteAccountAndUserData(BuildContext context) async {
    try {
      Loader.showLoader(context);
      Dio dio = Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: print));

      // Retrieve the access token from local storage
      String? authToken = await AccessTokenManager.getAccessToken();

      if (authToken != null) {
        dio.options.headers['Authorization'] = 'Bearer $authToken';
      } else {
        Loader.hideLoader(context); // Handle the case where the user is not authenticated
      }

      final response = await dio.get(
        'http://13.235.49.214:8800/customer/user/delete',
      );

      Loader.hideLoader(context);

      if (response.statusCode == 200) {
        await AccessTokenManager.removeAccessToken();
        print("Account and user data deleted successfully!");
        print(response.data);
        Navigator.pushReplacementNamed(
          context,
          NamedRoutes.splashRoute,
        );
      } else {
        // Failed to delete account and user data, handle the error
        print("Failed to delete account and user data");
        print(response.data);
      }
    } catch (error) {
      Loader.hideLoader(context);
      // Handle any exceptions that occurred during the request
      print("Error isss: $error");
    }
  }


  Widget profileOptions({
    required Function() onTap,
    required String imagePath,
    required String optionTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  imagePath,
                ),
                SizedBox(width: 3.w),
                Text(
                  optionTitle,
                  style: StyleConstant.userProfileOptionsStyle,
                ),
              ],
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.textDark,
              height: 1.5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget userDetailsWithEditButton() {

    return Consumer<ProfileProvider>(builder: (context, provider, child) {
      print("name is ${provider.userData?.name?? ''}");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text( provider.userData?.name?? '',
                      style: StyleConstant.textDark15sp600Style),
                  Text(
                        provider.userData?.phoneNumber.toString()?? '',
                    style: TextStyle(
                      color: ColorsConstant.textLight,
                      fontSize: 10.sp,
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

    });
  }
}

//Continue as guest
class ProfileScreen2 extends StatefulWidget {
  ProfileScreen2({Key? key}) : super(key: key);

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {


  @override
  void initState() {
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        AuthenticationProvider AuthProvider = context.read<AuthenticationProvider>();

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
                    title: Container(
                      padding: EdgeInsets.only(bottom: 2.h),
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
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: 2.h, right: 5.w, left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    "assets/images/app_logo.png",
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Please create your account to see your profile",
                                    style: TextStyle(
                                        fontSize: 16.0),
                                  ),
                                ),
                                SizedBox(height:20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        child: Text("SignIn", style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                              const StadiumBorder(),
                                            ),
                                          ),
                                        onPressed: () async{
                                          AuthProvider.resetMobielNumberController();
                                          await saveIsGuestStatus(false);
                                          Navigator.pushReplacementNamed(
                                            context,
                                              NamedRoutes.authenticationRoute
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> saveIsGuestStatus(bool isGuest) async {
    final box = await Hive.openBox('userBox');
    box.put('isGuest', isGuest);
  }

  Future<bool> getIsGuestStatus() async {
    final box = await Hive.openBox('userBox');
    return box.get('isGuest', defaultValue: true) ?? true;
  }
}