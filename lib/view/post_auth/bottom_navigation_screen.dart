import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/post_auth/explore/explore_screen.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/view/post_auth/map/map_screen.dart';
import 'package:naai/view/post_auth/profile/profile_screen.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  late List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            extendBody: true,
            body: _screens[provider.currentScreenIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                 //   blurRadius: 10,
                 //   spreadRadius: 0.1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.5.h),
                  topRight: Radius.circular(3.5.h),
                ),
                child: SalomonBottomBar(
                  margin: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 1.5.h,
                  ),
                  currentIndex: provider.currentScreenIndex,
                  onTap: (i) => provider.setCurrentScreenIndex(
                    context: context,
                    indexValue: i,
                  ),
                  items: <SalomonBottomBarItem>[
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.home,
                      image: ImagePathConstant.homeIcon,
                      index: 0,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.explore,
                      image: ImagePathConstant.exploreIcon,
                      index: 1,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.map,
                      image: ImagePathConstant.mapIcon,
                      index: 2,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.profile,
                      image: ImagePathConstant.profileIcon,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _bottomWidget({
    required BottomNavigationProvider provider,
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: provider.currentScreenIndex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 2.5.h,
      ),
      title: Text(
        tabName,
        style: StyleConstant.appColorBoldTextStyle,
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }
}


class BottomNavigationScreen2 extends StatefulWidget {
  BottomNavigationScreen2({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen2> createState() => _BottomNavigationScreen2State();
}

class _BottomNavigationScreen2State extends State<BottomNavigationScreen2>
    with WidgetsBindingObserver {
  late List<Widget> _screens = [
    HomeScreen2(),
    ExploreScreen2(),
    MapScreen(),
    ProfileScreen2(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            extendBody: true,
            body: _screens[provider.currentScreenIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    //   blurRadius: 10,
                    //   spreadRadius: 0.1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.5.h),
                  topRight: Radius.circular(3.5.h),
                ),
                child: SalomonBottomBar(
                  margin: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 1.5.h,
                  ),
                  currentIndex: provider.currentScreenIndex,
                  onTap: (i) => provider.setCurrentScreenIndex(
                    context: context,
                    indexValue: i,
                  ),
                  items: <SalomonBottomBarItem>[
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.home,
                      image: ImagePathConstant.homeIcon,
                      index: 0,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.explore,
                      image: ImagePathConstant.exploreIcon,
                      index: 1,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.map,
                      image: ImagePathConstant.mapIcon,
                      index: 2,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.profile,
                      image: ImagePathConstant.profileIcon,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _bottomWidget({
    required BottomNavigationProvider provider,
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: provider.currentScreenIndex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 2.5.h,
      ),
      title: Text(
        tabName,
        style: StyleConstant.appColorBoldTextStyle,
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }
}



class BottomNavigationScreen3 extends StatefulWidget {
  BottomNavigationScreen3({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen3> createState() => _BottomNavigationScreen3State();
}

class _BottomNavigationScreen3State extends State<BottomNavigationScreen3>
    with WidgetsBindingObserver {
  late List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            extendBody: true,
            body: _screens[provider.onetimeindex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    //   blurRadius: 10,
                    //   spreadRadius: 0.1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.5.h),
                  topRight: Radius.circular(3.5.h),
                ),
                child: SalomonBottomBar(
                  margin: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 1.5.h,
                  ),
                  currentIndex: provider.onetimeindex,
                  onTap: (i) => provider.setCurrentScreenIndex(
                    context: context,
                    indexValue: i,
                  ),
                  items: <SalomonBottomBarItem>[
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.home,
                      image: ImagePathConstant.homeIcon,
                      index: 0,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.explore,
                      image: ImagePathConstant.exploreIcon,
                      index: 1,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.map,
                      image: ImagePathConstant.mapIcon,
                      index: 2,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.profile,
                      image: ImagePathConstant.profileIcon,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _bottomWidget({
    required BottomNavigationProvider provider,
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: provider.onetimeindex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 2.5.h,
      ),
      title: Text(
        tabName,
        style: StyleConstant.appColorBoldTextStyle,
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }
}


class BottomNavigationScreen4 extends StatefulWidget {
  BottomNavigationScreen4({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen4> createState() => _BottomNavigationScreen4State();
}

class _BottomNavigationScreen4State extends State<BottomNavigationScreen4>
    with WidgetsBindingObserver {
  late List<Widget> _screens = [
    HomeScreen2(),
    ExploreScreen2(),
    MapScreen(),
    ProfileScreen2(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            extendBody: true,
            body: _screens[provider.extimeindex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    //   blurRadius: 10,
                    //   spreadRadius: 0.1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.5.h),
                  topRight: Radius.circular(3.5.h),
                ),
                child: SalomonBottomBar(
                  margin: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 1.5.h,
                  ),
                  currentIndex: provider.extimeindex,
                  onTap: (i) => provider.setCurrentScreenIndex(
                    context: context,
                    indexValue: i,
                  ),
                  items: <SalomonBottomBarItem>[
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.home,
                      image: ImagePathConstant.homeIcon,
                      index: 0,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.explore,
                      image: ImagePathConstant.exploreIcon,
                      index: 1,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.map,
                      image: ImagePathConstant.mapIcon,
                      index: 2,
                    ),
                    _bottomWidget(
                      provider: provider,
                      tabName: StringConstant.profile,
                      image: ImagePathConstant.profileIcon,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _bottomWidget({
    required BottomNavigationProvider provider,
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: provider.extimeindex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 2.5.h,
      ),
      title: Text(
        tabName,
        style: StyleConstant.appColorBoldTextStyle,
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }
}