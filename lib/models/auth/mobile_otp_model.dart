// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetOTPModel {
    String status;
    String message;
    OtpData data;

    GetOTPModel({
      required this.status,
      required this.message,
      required this.data,
    });

    GetOTPModel copyWith({
      String? status,
      String? message,
      OtpData? data,
    }) {
      return GetOTPModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
    }

    Map<String, dynamic> toMap() {
      return <String, dynamic>{
        'status': status,
        'message': message,
        'data': data.toMap(),
      };
    }

    factory GetOTPModel.fromMap(Map<String, dynamic> map) {
      return GetOTPModel(
        status: map['status'] as String,
        message: map['message'] as String,
        data: OtpData.fromMap(map['data'] as Map<String,dynamic>),
      );
    }

    String toJson() => json.encode(toMap());

    factory GetOTPModel.fromJson(String source) => GetOTPModel.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
    String toString() => 'GetOTPModel(status: $status, message: $message, data: $data)';
}

class OtpData {
   String userId;
   int phoneNumber;
   String otp;

    OtpData({
      required this.userId,
      required this.phoneNumber,
      required this.otp,
    });


    OtpData copyWith({
      String? userId,
      int? phoneNumber,
      String? otp,
    }) {
      return OtpData(
        userId: userId ?? this.userId,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        otp: otp ?? this.otp,
      );
    }

    Map<String, dynamic> toMap() {
      return <String, dynamic>{
        'userId': userId,
        'phoneNumber': phoneNumber,
        'otp': otp,
      };
    }

    factory OtpData.fromMap(Map<String, dynamic> map) {
      return OtpData(
        userId: map['userId'] as String,
        phoneNumber: map['phoneNumber'] as int,
        otp: map['otp'] as String,
      );
    }

    String toJson() => json.encode(toMap());

    factory OtpData.fromJson(String source) => OtpData.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
    String toString() => 'OtpData(userId: $userId, phoneNumber: $phoneNumber, otp: $otp)';
}

class OtpVerifyModel {
  String status;
  String message;
  VerifyOtpData data;

  OtpVerifyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  OtpVerifyModel copyWith({
    String? status,
    String? message,
    VerifyOtpData? data,
  }) {
    return OtpVerifyModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory OtpVerifyModel.fromMap(Map<String, dynamic> map) {
    return OtpVerifyModel(
      status: map['status'] as String,
      message: map['message'] as String,
      data: (map['data'].toString().isNotEmpty) ? VerifyOtpData.fromMap(map['data'] as Map<String,dynamic>) : VerifyOtpData(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpVerifyModel.fromJson(String source) => OtpVerifyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OtpVerifyModel(status: $status, message: $message, data: $data)';
}

class VerifyOtpData {
  final String? id;
  final String? name;
  final String? email;
  final int? phoneNumber;
  final bool? verified;
  final String? accessToken;
  final bool? newUser;

  VerifyOtpData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.verified,
    this.accessToken,
    this.newUser,
  });

  VerifyOtpData copyWith({
    String? id,
    String? name,
    String? email,
    int? phoneNumber,
    bool? verified,
    String? accessToken,
    bool? newUser,
  }) {
    return VerifyOtpData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verified: verified ?? this.verified,
      accessToken: accessToken ?? this.accessToken,
      newUser: newUser ?? this.newUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'verified': verified,
      'accessToken': accessToken,
      'newUser': newUser,
    };
  }

  factory VerifyOtpData.fromMap(Map<String, dynamic> map) {
    return VerifyOtpData(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as int : null,
      verified: map['verified'] != null ? map['verified'] as bool : null,
      accessToken: map['accessToken'] != null ? map['accessToken'] as String : null,
      newUser: map['newUser'] != null ? map['newUser'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyOtpData.fromJson(String source) => VerifyOtpData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerifyOtpData(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, verified: $verified, accessToken: $accessToken, newUser: $newUser)';
  }
}
