import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/location/location_model.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/services/location/location_services.dart';
import 'package:naai/utils/common_widgets/common_widgets.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _mapTextController = TextEditingController();
  late MapboxMapController _mapBoxController;
  late Symbol _symbol;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
              CommonWidget.appScreenCommonBackground(),
              Positioned(
                    top: 80.h,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.h),
                        topRight: Radius.circular(30.h),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                                        //ref.setLatLng(selectedLatLng);          
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
                                      })
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: _mapBox(),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                  ),
              
              
            ],
          );
    
  }

 Widget _mapBox(){
  final ref = context.read<LocationProvider>();
   return Stack(
        children: [
          MapboxMap(
            accessToken: "pk.eyJ1IjoibXlwZXJybyIsImEiOiJjbDRmZGVwNmwwMjlmM3BvZm02czd5ZWhlIn0.vjixPEoZnR1G6QmKxMva2w",
            initialCameraPosition: CameraPosition(target: ref.latLng, zoom: 15.0),
            onMapCreated: (MapboxMapController mapController) async {
             // await provider.onMapCreated(mapController, context);
              _mapBoxController = mapController;
              LatLng dummyLocation = ref.latLng; // Set your desired dummy location
              print(dummyLocation);
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
