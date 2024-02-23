// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeleteUserResponseModel {
  final String? stauts;
  final String? message;
  final dynamic? data;
  
  DeleteUserResponseModel({
    this.stauts,
    this.message,
    this.data,
  });

  DeleteUserResponseModel copyWith({
    String? stauts,
    String? message,
    dynamic? data,
  }) {
    return DeleteUserResponseModel(
      stauts: stauts ?? this.stauts,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stauts': stauts,
      'message': message,
      'data': data,
    };
  }

  factory DeleteUserResponseModel.fromMap(Map<String, dynamic> map) {
    return DeleteUserResponseModel(
      stauts: map['stauts'] != null ? map['stauts'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteUserResponseModel.fromJson(String source) => DeleteUserResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DeleteUserResponseModel(stauts: $stauts, message: $message, data: $data)';

  
}
