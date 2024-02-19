import 'dart:convert';
import 'package:naai/models/api_models/reviews_item_model.dart';

class ReviewResponseModel {
  final String? status;
  final String? message;
  final List<ReviewItem>? data;
  
  ReviewResponseModel({
    this.status,
    this.message,
    this.data,
  });

  ReviewResponseModel copyWith({
    String? status,
    String? message,
    List<ReviewItem>? data,
  }) {
    return ReviewResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory ReviewResponseModel.fromMap(Map<String, dynamic> map) {
    return ReviewResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: List<ReviewItem>.from((map['data'] as List<dynamic>).map<ReviewItem>((x) => ReviewItem.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewResponseModel.fromJson(String source) => ReviewResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReviewResponseModel(status: $status, message: $message, data: $data)';
}
