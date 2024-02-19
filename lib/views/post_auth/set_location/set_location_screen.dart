import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/location/location_model.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/services/location/location_services.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:provider/provider.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({Key? key}) : super(key: key);

  @override
  State<SetLocationScreen> createState() => _SetHomeLocationScreenState();
}

class _SetHomeLocationScreenState extends State<SetLocationScreen> {
  final TextEditingController _mapTextController = TextEditingController();
  late MapboxMapController _mapBoxController;
  late Symbol _symbol;

  @override
  void initState() {
    super.initState();
   // context.read<HomeProvider>().initializeSymbol();
  }
  @override
  void dispose() {
    _mapTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
         return PopScope(
        onPopInvoked: (_){
        //     if (provider.userData.homeLocation?.geoLocation == null) {
        //     ReusableWidgets.showFlutterToast(
        //       context,
        //       'Please set your home location before moving forward! to find nearby salons😊',
        //     );
        //     return false;
        // }else {
        //     provider.clearMapSearchText();
        //     // Allow popping the screen
        //     return Future.value(true);
        //   }
        },
        child: SafeArea(
          child: Scaffold(
          //  backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              leadingWidth: 0,
              titleSpacing: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                        //provider.clearMapSearchText();
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
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      screenSubtitle(),
                      Consumer<LocationProvider>(builder: (context,ref,child){
                         return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: SingleChildScrollView(
                                child: TypeAheadField(
                                  debounceDuration: const Duration(milliseconds: 300),
                                  hideSuggestionsOnKeyboardHide: false,
                                  suggestionsCallback: (pattern) async {
                                    final res = await LocationServices.getPlaceSuggestions(_mapTextController.text);
                                    return res;
                                  },
                                  minCharsForSuggestions: 1,
                                  noItemsFoundBuilder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
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
                                    return ListTile(
                                      tileColor: Colors.white,
                                      title: Text(
                                        suggestion.placeName ?? "",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (Feature suggestion) async {
                                    // DO NOT REMOVE THIS PRINT STATEMENT OTHERWISE THE FUNCTION
                                    // WILL NOT BE TRIGGERED
                                    print("\t\tNOTE: Do not remove this print statement.");

                                    _mapTextController.text = suggestion.placeName ?? "";

                                    LatLng selectedLatLng = LatLng(suggestion.center?[1] ?? 0.0, suggestion.center?[0] ?? 0.0);
                                    await _mapBoxController.removeSymbol(_symbol);
                                    
                                    await _mapBoxController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(target: selectedLatLng, zoom: 16),
                                      ),
                                    );
                                    await _mapBoxController.addSymbol(SymbolOptions(
                                      geometry: selectedLatLng,
                                      iconImage: ImagePathConstant.currentLocationPointer,
                                      iconSize: 0.2,
                                    ));

                                    ref.setLatLng(selectedLatLng);

                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  textFieldConfiguration: TextFieldConfiguration(
                                    textInputAction: TextInputAction.done,
                                    cursorColor: ColorsConstant.appColor,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    controller: _mapTextController,
                                    decoration: StyleConstant.searchBoxInputDecoration(
                                      context,
                                      hintText: StringConstant.search,
                                      address: ref.address
                                    ),
                                  ),
                                ),
                              
                              ),
                            );
                      }),
                      
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
        ),
      );
  }

  Widget screenSubtitle() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: const Text(
        StringConstant.setLocationSubtext,
        style: TextStyle(
        color: ColorsConstant.greySalonAddress,
        fontWeight: FontWeight.w500,
      ),
      ),
    );
  }

  Widget _mapBox(){
   return Stack(
        children: [
          MapboxMap(
            accessToken: "pk.eyJ1IjoibXlwZXJybyIsImEiOiJjbDRmZGVwNmwwMjlmM3BvZm02czd5ZWhlIn0.vjixPEoZnR1G6QmKxMva2w",
            initialCameraPosition: const CameraPosition(target: LatLng(28.6304, 77.2177), zoom: 15.0),
            onMapCreated: (MapboxMapController mapController) async {
             // await provider.onMapCreated(mapController, context);
              _mapBoxController = mapController;
              LatLng dummyLocation = const LatLng(28.7383,77.0822); // Set your desired dummy location
              await mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: dummyLocation,
                    zoom: 10,
                  ),
                ),
              );
              _symbol = await _mapBoxController.addSymbol(
                SymbolOptions(
                geometry: dummyLocation,
                iconImage: ImagePathConstant.currentLocationPointer,
                iconSize: 0.2,
              ));
            },
            onMapClick: (Point<double> point, LatLng coordinates) {
              FocusManager.instance.primaryFocus?.unfocus();
              //provider.onMapClick(coordinates: coordinates, context: context);
              _mapTextController.clear();
              print("Coordinates ===> $coordinates");

               _mapBoxController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: coordinates, zoom: 16),
                ),
              );
            },
          ),
         // ReusableWidgets.recenterWidget(context, provider: provider),
        ],
      );
  }

}

