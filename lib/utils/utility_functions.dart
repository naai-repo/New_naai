import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';

class UtilityFunctions {
  /// Method to generate the complete image path from [imageTitle]
  static String getImagePath({required String imageTitle}) {
    return StringConstant.imageBaseDirectory + imageTitle;
  }

  /// [SymbolOptions] for user's current location
  static SymbolOptions getCurrentLocationSymbolOptions({required LatLng latLng}) {
    return SymbolOptions(
      geometry: latLng,
      iconImage: ImagePathConstant.currentLocationPointer,
      iconSize: 0.2,
    );
  }

  /// [SymbolOptions] for nearby salon locations
  static SymbolOptions getNearbySalonLocationSymbolOptions(
      {required LatLng latLng}) {
    return SymbolOptions(
      geometry: latLng,
      iconImage: ImagePathConstant.salonLocationPointer,
      iconSize: 2,
    );
  }

  /// Handle current location API timeout, when the API runs for
  /// more than [BaseClient.TIME_OUT_DURATION] seconds
  static LocationData locationApiTimeout(
    BuildContext context, {
    required String message,
  }) {
    ReusableWidgets.showFlutterToast(
        context, StringConstant.locationApiTookTooLong);
    Loader.hideLoader(context);
    return LocationData.fromMap({});
  }

  /// Query parameters for address suggestions from search text
  static Map<String, dynamic> mapSearchQueryParameters() {
    return {
      'proximity': 'ip',
      'limit': '10',
      'language': 'en-gb',
      'autocomplete': 'true',
      'fuzzyMatch': 'true',
      'access_token': Keys.mapbox_public_key,
    };
  }

  /// Query parameters for reverse geo-coding api
  static Map<String, dynamic> reverseGeoLocationQueryParameters() {
    return {
      'types': 'locality,neighborhood,place,district,region',
      'access_token': Keys.mapbox_public_key,
    };
  }

  /// Fetches the complete address for the provided coordinates.
  static Future<UserLocationModel?> getAddressFromCoordinates(
    BuildContext context, {
    required LatLng coordinates,
  }) async {
    Uri uri = Uri.parse(
            "${ApiEndpointConstant.mapboxPlacesApi}${coordinates.longitude},${coordinates.latitude}.json")
        .replace(
            queryParameters:
                UtilityFunctions.reverseGeoLocationQueryParameters());

    try {
      var response = await BaseClient().get(
        baseUrl: '',
        api: uri.toString(),
      );
      return UserLocationModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger().d(e);
      ReusableWidgets.showFlutterToast(context, e.toString());
      return null;
    }
  }

  /// Formats the address text for the provided location.
  /// The address format is [x, y] where the precedence of x and y is
  /// Neighborhood, Locality, Place, District, Region
  static String formatAddressText(UserLocationModel locationModel) {
    String address = '';
    for (int i = 0; i < (locationModel.features?.length ?? 0); i++) {
      var element = locationModel.features?[i];

      switch (element?.placeType?[0]) {
        case 'neighborhood':
          address += '${element?.text}, ';
          break;
        case 'locality':
          address += '${element?.text}, ';
          break;
        case 'place':
          address += '${element?.text}, ';
          break;
        case 'district':
          address += '${element?.text}, ';
          break;
        case 'region':
          address += '${element?.text}';
          break;
      }
    }
    var addressArray = address.split(',');
    address = addressArray.first + ',' + addressArray.last;
    return address;
  }

  /// Fetch the address from given coordinates and return a formatted address text.
  static Future<String> getAddressCoordinateAndFormatAddress({
    required BuildContext context,
    required LatLng latLng,
  }) async {
    UserLocationModel? _userLocationResult =
        await UtilityFunctions.getAddressFromCoordinates(context,
            coordinates: latLng);

    return _userLocationResult == null
        ? StringConstant.unknown
        : UtilityFunctions.formatAddressText(_userLocationResult);
  }
}
