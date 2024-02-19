import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/providers/bottom_change_index_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/views/post_auth/explore/explore_screen.dart';
import 'package:naai/views/post_auth/home/home_screen.dart';
import 'package:naai/views/post_auth/map/map_screen.dart';
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

    return PopScope(
          canPop: false,
          child: SafeArea(
            child: Scaffold(
              extendBody: true,
              body: _screens[screenIndex],
              bottomNavigationBar: Container(
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
                    margin: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    currentIndex: screenIndex,
                    onTap: (i){
                        ref.setScreenIndex(i);
                    },
                    items: <SalomonBottomBarItem>[
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
        style: TextStyle(
          color: ColorsConstant.appColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }

}
