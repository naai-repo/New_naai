// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateUserResponseModel {
  final String? status;
  final String? message;
  final UpdateUserData? data;
  
  UpdateUserResponseModel({
    this.status,
    this.message,
    this.data,
  });
  

  UpdateUserResponseModel copyWith({
    String? status,
    String? message,
    UpdateUserData? data,
  }) {
    return UpdateUserResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory UpdateUserResponseModel.fromMap(Map<String, dynamic> map) {
    return UpdateUserResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? UpdateUserData.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserResponseModel.fromJson(String source) => UpdateUserResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UpdateUserResponseModel(status: $status, message: $message, data: $data)';
}

class UpdateUserData {
  final bool? acknowledged;
  final int? modifiedCount;
  final dynamic? upsertedId;
  final int? upsertedCount;
  final int? matchedCount;

  UpdateUserData({
    this.acknowledged,
    this.modifiedCount,
    this.upsertedId,
    this.upsertedCount,
    this.matchedCount,
  });

  UpdateUserData copyWith({
    bool? acknowledged,
    int? modifiedCount,
    dynamic? upsertedId,
    int? upsertedCount,
    int? matchedCount,
  }) {
    return UpdateUserData(
      acknowledged: acknowledged ?? this.acknowledged,
      modifiedCount: modifiedCount ?? this.modifiedCount,
      upsertedId: upsertedId ?? this.upsertedId,
      upsertedCount: upsertedCount ?? this.upsertedCount,
      matchedCount: matchedCount ?? this.matchedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'acknowledged': acknowledged,
      'modifiedCount': modifiedCount,
      'upsertedId': upsertedId,
      'upsertedCount': upsertedCount,
      'matchedCount': matchedCount,
    };
  }

  factory UpdateUserData.fromMap(Map<String, dynamic> map) {
    return UpdateUserData(
      acknowledged: map['acknowledged'] != null ? map['acknowledged'] as bool : null,
      modifiedCount: map['modifiedCount'] != null ? map['modifiedCount'] as int : null,
      upsertedId: map['upsertedId'] != null ? map['upsertedId'] as dynamic : null,
      upsertedCount: map['upsertedCount'] != null ? map['upsertedCount'] as int : null,
      matchedCount: map['matchedCount'] != null ? map['matchedCount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserData.fromJson(String source) => UpdateUserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UpdateUserData(acknowledged: $acknowledged, modifiedCount: $modifiedCount, upsertedId: $upsertedId, upsertedCount: $upsertedCount, matchedCount: $matchedCount)';
  }

}
