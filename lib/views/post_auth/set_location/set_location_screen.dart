import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/controllers/location/location_controller.dart';
import 'package:naai/models/location/location_model.dart';
import 'package:naai/providers/post_auth/location_provider.dart';
import 'package:naai/services/location/location_services.dart';
import 'package:naai/utils/buttons/buttons.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:naai/utils/constants/string_constant.dart';
import 'package:naai/utils/constants/style_constant.dart';
import 'package:naai/utils/progress/loading.dart';
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
                children: [
                  IconButton(
                    onPressed: () {
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
              children: [
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
                                    
                                    if(context.mounted) await setLocationModal(context, selectedLatLng);

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
              LatLng dummyLocation = await context.read<LocationProvider>().getLatLng(); // Set your desired dummy location
              
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
            onMapClick: (Point<double> point, LatLng coordinates) async {
              FocusManager.instance.primaryFocus?.unfocus();
              //provider.onMapClick(coordinates: coordinates, context: context);
              _mapTextController.clear();
              print("Coordinates ===> $coordinates");

               await _mapBoxController.removeSymbol(_symbol);

              await _mapBoxController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: coordinates, zoom: 16),
                ),
              );
              await _mapBoxController.addSymbol(SymbolOptions(
                geometry: coordinates,
                iconImage: ImagePathConstant.currentLocationPointer,
                iconSize: 0.2,
              ));
              if(context.mounted) await setLocationModal(context, coordinates);
            },
          ),
          Positioned(
              top: 20.h,
              right: 20.h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                     try {
                      Loading.showLoding(context);
                      final res = await LocationController.handelLocationPermissionUI(context);
                      
                      
                      if(res){
                        final latng = await LocationController.getLocationLatLng();
                         await _mapBoxController.removeSymbol(_symbol);
                                    
                        await _mapBoxController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: latng, zoom: 16),
                          ),
                        );

                        await _mapBoxController.addSymbol(SymbolOptions(
                          geometry: latng,
                          iconImage: ImagePathConstant.currentLocationPointer,
                          iconSize: 0.2,
                        ));

                        
                        if(context.mounted){
                          Loading.closeLoading(context);
                          await setLocationModal(context, latng);
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        return;
                      }

                      throw ErrorDescription("Not Enabled");
                      
                    } catch (e) {
                      print("Error Recenter Location : ${e.toString()}");
                      if(context.mounted){
                        Loading.closeLoading(context);
                      }
                    }finally{
                      // if(context.mounted){
                      //   Loading.closeLoading(context);
                      // }
                    }
                },
                child: Container(
                  height: 50.h,
                  width: 50.h,
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(ImagePathConstant.currentLocationPointer),
                ),
              ),
            )
  
        ],
      );
  }

  Future<void> setLocationModal(BuildContext context,LatLng latLng)async {
    final ref = context.read<LocationProvider>();
    final place = await ref.getAddress(latLng.latitude,latLng.longitude);
    String address = "${place.subLocality}, ${place.locality}";
    if(!context.mounted) return;

    showModalBottomSheet(
      context: context, 
      constraints: BoxConstraints(maxHeight: 150.h),
      backgroundColor: Colors.white,
      builder: (context){
         return Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Text(address,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500
                )),
                SizedBox(height: 20.h),
                CustomButtons.redFullWidthButton(
                  buttonText: "Set Location",
                  fillColor: ColorsConstant.appColor, 
                  onTap: () async{
                     ref.setLatLng(latLng);
                     Navigator.pop(context);
                     Navigator.pop(context);
                  }, 
                  isActive: true
                )
            ],
          ),
         );
      }
    );
  }
}

