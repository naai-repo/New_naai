import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naai/models/auth/mobile_otp_model.dart';

class AuthData {
  final GetOTPModel? getOtpData;
  final OtpVerifyModel? verifyOtpData;
  final String? accessToken;
  final bool? isGuest;

  AuthData({
    this.getOtpData,
    this.verifyOtpData,
    this.accessToken,
    this.isGuest
  });

 
  AuthData copyWith({
    GetOTPModel? getOtpData,
    OtpVerifyModel? verifyOtpData,
    String? accessToken,
    bool? isGuest,
  }) {
    return AuthData(
      getOtpData: getOtpData ?? this.getOtpData,
      verifyOtpData: verifyOtpData ?? this.verifyOtpData,
      accessToken: accessToken ?? this.accessToken,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'getOtpData': getOtpData?.toMap(),
      'verifyOtpData': verifyOtpData?.toMap(),
      'accessToken': accessToken,
      'isGuest': isGuest,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      getOtpData: map['getOtpData'] != null ? GetOTPModel.fromMap(map['getOtpData'] as Map<String,dynamic>) : null,
      verifyOtpData: map['verifyOtpData'] != null ? OtpVerifyModel.fromMap(map['verifyOtpData'] as Map<String,dynamic>) : null,
      accessToken: map['accessToken'] != null ? map['accessToken'] as String : null,
      isGuest: map['isGuest'] != null ? map['isGuest'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) => AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthData(getOtpData: $getOtpData, verifyOtpData: $verifyOtpData, accessToken: $accessToken, isGuest: $isGuest)';
  }
}

class AuthenticationProvider with ChangeNotifier {
    AuthData _authData = AuthData();
    int? _mobileNumber = 0;
    
    AuthData get authData => _authData;
    int get mobileNumber => _mobileNumber ?? 0;
    
    void setMobileNumber(int value){
      _mobileNumber = value;
      notifyListeners();
    }

    void setGetOTP(GetOTPModel value){
      _authData = _authData.copyWith(getOtpData: value);
      notifyListeners();
    }

    void setVerifyOTP(OtpVerifyModel value){
      _authData = _authData.copyWith(verifyOtpData: value);
      notifyListeners();
    }

    Future<void> setAccessToken(String value) async {
        var box = Hive.box('userBox');
        box.put('accesstoken',value);
        _authData = _authData.copyWith(accessToken: value);
    }

    Future<void> setUserId(String value) async {
        var box = Hive.box('userBox');
        box.put('userId',value);
    }

    Future<void> setIsGuest(bool value) async {
        final box = await Hive.openBox('userBox');
        box.put('isGuest', value);
        _authData = _authData.copyWith(isGuest: value);
    }

    Future<bool> getIsGuest() async {
        bool res = _authData.isGuest ?? false;
        if(res) return res;

        final box = await Hive.openBox('userBox');
        res = box.get('isGuest', defaultValue: false) ?? false;
        if(res) setIsGuest(res);
        return res;
    }

    Future<String> getAccessToken() async {
        String token = _authData.accessToken ?? "";
        if(token.isNotEmpty) return token;

        final box = await Hive.openBox('userBox');
        token = box.get('accesstoken', defaultValue: "") ?? "";
        if(token.isNotEmpty) setAccessToken(token);

        return token;
    }

}