import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/controllers/location/location_controller.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/views/post_auth/explore/explore_screen.dart';
import 'package:naai/views/post_auth/home/home_screen.dart';
import 'package:naai/views/post_auth/map/map_screen.dart';
import 'package:naai/views/post_auth/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>  with WidgetsBindingObserver {
  int screenIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const MapScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );
    screenIndex = context.read<BottomChangeScreenIndexProvider>().screenIndex;

    Future.delayed(const Duration(seconds: 1),(){
      locationPopUp(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<BottomChangeScreenIndexProvider>(context,listen: true);
    screenIndex = ref.screenIndex;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white),
    );

    return PopScope(
          canPop: false,
          child: SafeArea(
            child: Scaffold(
              extendBody: true,
              body: _screens[screenIndex],
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.h),
                    topRight: Radius.circular(30.h),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.h),
                    topRight: Radius.circular(35.h),
                  ),
                  child: SalomonBottomBar(
                    currentIndex: screenIndex,
                    onTap: (i){
                        ref.setScreenIndex(i);
                    },
                    items: [
                      _bottomWidget(
                        tabName: StringConstant.home,
                        image: ImagePathConstant.homeIcon,
                        index: 0,
                      ),
                      _bottomWidget(
                        tabName: StringConstant.explore,
                        image: ImagePathConstant.exploreIcon,
                        index: 1,
                      ),
                      _bottomWidget(
                        tabName: StringConstant.map,
                        image: ImagePathConstant.mapIcon,
                        index: 2,
                      ),
                      _bottomWidget(
                        tabName: StringConstant.profile,
                        image: ImagePathConstant.profileIcon,
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }

  SalomonBottomBarItem _bottomWidget({
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: screenIndex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 25.h,
      ),
      title: Text(
        tabName,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorsConstant.appColor,
          textBaseline: TextBaseline.ideographic,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }


  Future<void> locationPopUp(BuildContext context) async {
    final ref = Provider.of<LocationProvider>(context,listen: false);
    bool isGoingtoBeShown = await ref.getIsPopUpShown();


    if(!isGoingtoBeShown && context.mounted){
      await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.white,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r),
                topRight: Radius.circular(35.r),
              ),
              child: Container(
                padding: EdgeInsets.all(15.w),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/app_logo.png",
                        height: 80.h,
                        width: 80.w,
                      ),
                    ),
                    SizedBox(height: 8.h),
                     Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          "Set your location to Start \n exploring\n salons near you",
                          style: TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Image.asset('assets/images/loc_image.png'),
                    SizedBox(height: 20.h),
                    const LocationButtonsContainer()
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

class LocationButtonsContainer extends StatefulWidget {
  const LocationButtonsContainer({super.key});

  @override
  State<LocationButtonsContainer> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButtonsContainer>{
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LocationProvider>(context,listen: false);
    return Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (isLoading) ?  ColorsConstant.appColor.withOpacity(0.5) : ColorsConstant.appColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () async {
                            if(isLoading) return;

                            try {
                              await ref.setIsPopUpShown(true);
                              setState(() {
                                 isLoading = true;
                              });
                              
                              if(!context.mounted) return;
                               final res = await LocationController.handelLocationPermissionUI(context);

                              if(res){
                                final latng = await LocationController.getLocationLatLng();
                                await ref.setLatLng(latng);
                               // if(context.mounted) Navigator.pop(context);
                                return;
                              }

                              throw ErrorDescription("Not Enabled");
                              
                            } catch (e) {
                              print("Error Location : ${e.toString()}");

                              setState(() {
                                 isLoading = false;
                              });

                            }finally{
                              if(context.mounted) Navigator.pop(context);
                              setState(() {
                                  isLoading = false;
                              });
                            }

                          },
                          child: (isLoading) ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2.w),
                          ) : const Text(
                            "Enable Device Location",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ),
                  
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () async {
                          if(isLoading) return;

                          await ref.setIsPopUpShown(true);
                          if(context.mounted) await Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute);
                          if(context.mounted) Navigator.pop(context);
                        },
                        child:  Text(
                          "Enter your Location Manually",
                          style: TextStyle(
                            color: (isLoading) ?  ColorsConstant.appColor.withOpacity(0.5) : ColorsConstant.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
          );
  }
}

