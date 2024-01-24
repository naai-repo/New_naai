import 'package:flutter/cupertino.dart';

class LoginResultProvider with ChangeNotifier {
  Map<String, dynamic>? _loginResult;

  Map<String, dynamic>? get loginResult => _loginResult;

  void setLoginResult(Map<String, dynamic> result) {
    _loginResult = result;
    notifyListeners();
  }
}
