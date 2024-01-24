class UpdateUserRequest {
  final String userId;
  final Map<String, dynamic> data;

  UpdateUserRequest({required this.userId, required this.data});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "data": data,
    };
  }
}

class UpdateUserResponse {
  final String status;
  final String message;
  final UpdateUserData data;

  UpdateUserResponse({required this.status, required this.message, required this.data});

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: UpdateUserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UpdateUserData {
  final bool acknowledged;
  final int modifiedCount;
  final dynamic upsertedId;
  final int upsertedCount;
  final int matchedCount;

  UpdateUserData({
    required this.acknowledged,
    required this.modifiedCount,
    required this.upsertedId,
    required this.upsertedCount,
    required this.matchedCount,
  });

  factory UpdateUserData.fromJson(Map<String, dynamic> json) {
    return UpdateUserData(
      acknowledged: json['acknowledged'] ?? false,
      modifiedCount: json['modifiedCount'] ?? 0,
      upsertedId: json['upsertedId'],
      upsertedCount: json['upsertedCount'] ?? 0,
      matchedCount: json['matchedCount'] ?? 0,
    );
  }
}
