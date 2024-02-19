// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/reviews_item_model.dart';
import 'package:naai/models/api_models/user_model.dart';

class ReviewsModel {
  final UserResponseModel? user;
  final ReviewItem? reviews;
  
  ReviewsModel({
    this.user,
    this.reviews,
  });
 

  ReviewsModel copyWith({
    UserResponseModel? user,
    ReviewItem? reviews,
  }) {
    return ReviewsModel(
      user: user ?? this.user,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'reviews': reviews?.toMap(),
    };
  }

  factory ReviewsModel.fromMap(Map<String, dynamic> map) {
    return ReviewsModel(
      user: map['user'] != null ? UserResponseModel.fromMap(map['user'] as Map<String,dynamic>) : null,
      reviews: map['reviews'] != null ? ReviewItem.fromMap(map['reviews'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewsModel.fromJson(String source) => ReviewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReviewsModel(user: $user, reviews: $reviews)';

}
