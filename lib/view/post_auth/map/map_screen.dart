import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:naai/view_model/post_auth/map/map_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../view_model/post_auth/home/home_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
   context.read<MapProvider>().initializeSymbol();
   // context.read<HomeProvider>().initializeSymbol();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              Positioned(
                top: 8.h,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3.h),
                    topRight: Radius.circular(3.h),
                  ),
                  child: Container(
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: TypeAheadField(
                                    debounceDuration:
                                        Duration(milliseconds: 300),
                                    hideSuggestionsOnKeyboardHide: false,
                                    suggestionsCallback: (pattern) async {
                                      return await provider
                                          .getPlaceSuggestions(context);
                                    },
                                    minCharsForSuggestions: 1,
                                    noItemsFoundBuilder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () async {
                                            provider.clearMapSearchController();
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
                                            Loader.showLoader(context);
                                            LatLng latLng = await provider
                                                .fetchCurrentLocation(context);
                                            await provider
                                                .animateToPosition(latLng);
                                            Loader.hideLoader(context);
                                          },
                                          tileColor: Colors.grey.shade200,
                                          title: Row(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                height: 2.5.h,
                                                ImagePathConstant
                                                    .currentLocationIcon,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text(
                                                StringConstant
                                                    .yourCurrentLocation,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      ColorsConstant.appColor,
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
                                            provider.clearMapSearchController();
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
                                            Loader.showLoader(context);
                                            LatLng latLng = await provider
                                                .fetchCurrentLocation(context);
                                            await provider
                                                .animateToPosition(latLng);
                                            Loader.hideLoader(context);
                                          },
                                          tileColor: Colors.grey.shade200,
                                          title: Row(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                height: 2.5.h,
                                                ImagePathConstant
                                                    .currentLocationIcon,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text(
                                                StringConstant
                                                    .yourCurrentLocation,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      ColorsConstant.appColor,
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
                                          suggestion, context);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      textInputAction: TextInputAction.done,
                                      cursorColor: ColorsConstant.appColor,
                                      style: StyleConstant.searchTextStyle,
                                      controller: provider.mapSearchController,
                                      decoration: StyleConstant
                                          .searchBoxInputDecoration(
                                        hintText: StringConstant
                                            .exploreSalonsSearchHint,
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: mapBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget mapBox() {
    return Consumer<MapProvider>(builder: (context, provider, child) {
      return Stack(
        children: <Widget>[
          MapboxMap(
           // compassEnabled: true,
            accessToken: Keys.mapbox_public_key,
            initialCameraPosition: const CameraPosition(
                target: LatLng(28.6304, 77.2177), zoom: 15.0),
            onMapCreated: (MapboxMapController mapController) async {
              await provider.onMapCreated(mapController, context);
            },
            // onMapClick: (Point<double> point, LatLng coordinates) {
            //   FocusManager.instance.primaryFocus?.unfocus();
            //   provider.onMapClick(coordinates: coordinates, context: context);
            // },
          ),
          ReusableWidgets.recenterWidget(context, provider: provider),
        ],
      );
    });
  }
}
