import 'package:dio/dio.dart';
import 'package:naai/models/location/location_model.dart';
import 'package:naai/utils/constants/api_constant.dart';
import 'package:naai/utils/utility_functions.dart';

class LocationServices {
  static Dio dio = Dio();
  static  Future<List<Feature>> getPlaceSuggestions(String text) async {
    try {
      Uri uri = Uri.parse("${UrlConstants.mapboxPlace}$text.json").replace(queryParameters: UtilityFunctions.mapSearchQueryParameters());

      var response = await dio.getUri(uri);
      UserLocationModel responseData = UserLocationModel.fromJson(response.data);
      List<Feature> res = responseData.features ?? [];
      return res;
    } catch (e,stacktarce) {
       print(stacktarce);
       print("Error : ${e.toString()}");
       return [];
    }
  }

}