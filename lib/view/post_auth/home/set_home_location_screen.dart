import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class SetHomeLocationScreen extends StatefulWidget {
  const SetHomeLocationScreen({Key? key}) : super(key: key);

  @override
  State<SetHomeLocationScreen> createState() => _SetHomeLocationScreenState();
}

class _SetHomeLocationScreenState extends State<SetHomeLocationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().initializeSymbol();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (provider.userData.homeLocation?.geoLocation == null) {
            ReusableWidgets.showFlutterToast(
              context,
              'Please set your home location before moving forward! to find nearby salons😊',
            );
            return false;
        }else {
            provider.clearMapSearchText();
            // Allow popping the screen
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            leadingWidth: 0,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                      provider.clearMapSearchText();
                      Navigator.pop(context);
                  },
                  splashRadius: 0.1,
                  splashColor: Colors.transparent,
                  icon: SvgPicture.asset(
                    ImagePathConstant.backArrowIos,
                  ),
                ),
                Text(
                  StringConstant.setLocation,
                  style: StyleConstant.headingTextStyle,
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    screenSubtitle(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: SingleChildScrollView(
                        child: TypeAheadField(
                          debounceDuration: const Duration(milliseconds: 300),
                          hideSuggestionsOnKeyboardHide: false,
                          suggestionsCallback: (pattern) async {
                            return await provider.getPlaceSuggestions(context);
                          },
                          minCharsForSuggestions: 1,
                          noItemsFoundBuilder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                onTap: () async {
                                  provider.clearMapSearchText();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Loader.showLoader(context);
                                  LatLng latLng = await provider
                                      .fetchCurrentLocation(context);
                                  await provider.animateToPosition(latLng);
                                  Loader.hideLoader(context);
                                },
                                tileColor: Colors.grey.shade200,
                                title: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      height: 2.5.h,
                                      ImagePathConstant.currentLocationIcon,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      StringConstant.yourCurrentLocation,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                  StringConstant.cantFindAnyLocation,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: ColorsConstant.appColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          itemBuilder: (context, Feature suggestion) {
                            if (suggestion.id ==
                                StringConstant.yourCurrentLocation) {
                              return ListTile(
                                onTap: () async {
                                  provider.clearMapSearchText();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Loader.showLoader(context);
                                  LatLng latLng = await provider.fetchCurrentLocation(context);
                                  await provider.animateToPosition(latLng);
                                  Loader.hideLoader(context);
                                },
                                tileColor: Colors.grey.shade200,
                                title: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      height: 2.5.h,
                                      ImagePathConstant.currentLocationIcon,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      StringConstant.yourCurrentLocation,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                suggestion.placeName ?? "",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.appColor,
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (Feature suggestion) {
                            // DO NOT REMOVE THIS PRINT STATEMENT OTHERWISE THE FUNCTION
                            // WILL NOT BE TRIGGERED
                            print("\t\tNOTE: Do not remove this print statement.");
                            provider.handlePlaceSelectionEvent(
                              suggestion,
                              context,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorsConstant.appColor,
                            style: StyleConstant.searchTextStyle,
                            controller: provider.mapSearchController,
                            decoration: StyleConstant.searchBoxInputDecoration(
                              context,
                              hintText: StringConstant.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
              Expanded(
                child: _mapBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget screenSubtitle() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Text(
        StringConstant.setLocationSubtext,
        style: StyleConstant.greySemiBoldTextStyle,
      ),
    );
  }

  Widget _mapBox() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Stack(
        children: <Widget>[
          MapboxMap(
            accessToken: Keys.mapbox_public_key,
            initialCameraPosition: const CameraPosition(
                target: LatLng(28.6304, 77.2177), zoom: 15.0),
            onMapCreated: (MapboxMapController mapController) async {
              await provider.onMapCreated(mapController, context);
            },
            onMapClick: (Point<double> point, LatLng coordinates) {
              FocusManager.instance.primaryFocus?.unfocus();
              provider.onMapClick(coordinates: coordinates, context: context);
            },
          ),
          ReusableWidgets.recenterWidget(context, provider: provider),
        ],
      );
    });
  }
}

class SetHomeLocationScreen2 extends StatefulWidget {
  const SetHomeLocationScreen2({Key? key}) : super(key: key);

  @override
  State<SetHomeLocationScreen2> createState() => _SetHomeLocationScreen2State();
}

class _SetHomeLocationScreen2State extends State<SetHomeLocationScreen2> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().initializeSymbol();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (provider.userData.homeLocation?.geoLocation == null) {
            ReusableWidgets.showFlutterToast(
              context,
              'Please set your home location before moving forward! to find nearby salons😊',
            );
            return false;
          }else {
            provider.clearMapSearchText();
            // Allow popping the screen
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            leadingWidth: 0,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: () {

                      provider.clearMapSearchText();
                      Navigator.pop(context);

                  },
                  splashRadius: 0.1,
                  splashColor: Colors.transparent,
                  icon: SvgPicture.asset(
                    ImagePathConstant.backArrowIos,
                  ),
                ),
                Text(
                  StringConstant.setLocation,
                  style: StyleConstant.headingTextStyle,
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    screenSubtitle(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: SingleChildScrollView(
                        child: TypeAheadField(
                          debounceDuration: Duration(milliseconds: 300),
                          hideSuggestionsOnKeyboardHide: false,
                          suggestionsCallback: (pattern) async {
                            return await provider.getPlaceSuggestions(context);
                          },
                          minCharsForSuggestions: 1,
                          noItemsFoundBuilder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                onTap: () async {
                                  provider.clearMapSearchText();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Loader.showLoader(context);
                                  LatLng latLng = await provider
                                      .fetchCurrentLocation(context);
                                  await provider.animateToPosition(latLng);
                                  Loader.hideLoader(context);
                                },
                                tileColor: Colors.grey.shade200,
                                title: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      height: 2.5.h,
                                      ImagePathConstant.currentLocationIcon,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      StringConstant.yourCurrentLocation,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                  StringConstant.cantFindAnyLocation,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: ColorsConstant.appColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          itemBuilder: (context, Feature suggestion) {
                            if (suggestion.id ==
                                StringConstant.yourCurrentLocation) {
                              return ListTile(
                                onTap: () async {
                                  provider.clearMapSearchText();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  Loader.showLoader(context);
                                  LatLng latLng = await provider
                                      .fetchCurrentLocation(context);
                                  await provider.animateToPosition(latLng);
                                  Loader.hideLoader(context);
                                },
                                tileColor: Colors.grey.shade200,
                                title: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      height: 2.5.h,
                                      ImagePathConstant.currentLocationIcon,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      StringConstant.yourCurrentLocation,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.appColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                suggestion.placeName ?? "",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.appColor,
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (Feature suggestion) {
                            // DO NOT REMOVE THIS PRINT STATEMENT OTHERWISE THE FUNCTION
                            // WILL NOT BE TRIGGERED
                            print(
                                "\t\tNOTE: Do not remove this print statement.");
                            provider.handlePlaceSelectionEvent(
                              suggestion,
                              context,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorsConstant.appColor,
                            style: StyleConstant.searchTextStyle,
                            controller: provider.mapSearchController,
                            decoration: StyleConstant.searchBoxInputDecoration(
                              context,
                              hintText: StringConstant.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
              Expanded(
                child: _mapBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget screenSubtitle() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Text(
        StringConstant.setLocationSubtext,
        style: StyleConstant.greySemiBoldTextStyle,
      ),
    );
  }

  Widget _mapBox() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Stack(
        children: <Widget>[
          MapboxMap(
            accessToken: Keys.mapbox_public_key,
            initialCameraPosition: const CameraPosition(
                target: LatLng(28.6304, 77.2177), zoom: 15.0),
            onMapCreated: (MapboxMapController mapController) async {
              await provider.onMapCreated2(mapController, context);
            },
            onMapClick: (Point<double> point, LatLng coordinates) {
              FocusManager.instance.primaryFocus?.unfocus();
              provider.onMapClick2(coordinates: coordinates, context: context);
            },
          ),
          ReusableWidgets.recenterWidget(context, provider: provider),
        ],
      );
    });
  }
}