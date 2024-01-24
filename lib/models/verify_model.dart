class OtpVerificationRequest {
  final String userId;
  final String otp;

  OtpVerificationRequest({required this.userId, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "otp": otp,
    };
  }
}

class OtpVerificationResponse {
  final String status;
  final String message;
  final dynamic data;

  OtpVerificationResponse({required this.status, required this.message, required this.data});

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
class UserData {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool verified;
  final String accessToken;
  final bool newUser;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.verified,
    required this.accessToken,
    required this.newUser,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      verified: json['verified'] ?? false,
      accessToken: json['accessToken'] ?? '',
      newUser: json['newUser'] ?? false,
    );
  }
}
