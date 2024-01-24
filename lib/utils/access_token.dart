import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenManager {
  static const String _accessTokenKey = 'access_token';

  // Store the access token locally
  static Future<void> saveAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, accessToken);
  }

  // Retrieve the access token from local storage
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Remove the access token from local storage (logout)
  static Future<void> removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_accessTokenKey);
  }
}
