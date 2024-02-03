// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReviewsBarberSalons {
  final List<ReviewItem> reviews;
  ReviewsBarberSalons({
    required this.reviews,
  });
}

class ReviewItem {
  final ReviewData reviewData;
  final List<RepliesData> repliesData;

  ReviewItem({
    required this.reviewData,
    required this.repliesData,
  });
  

  ReviewItem copyWith({
    ReviewData? reviewData,
    List<RepliesData>? repliesData,
  }) {
    return ReviewItem(
      reviewData: reviewData ?? this.reviewData,
      repliesData: repliesData ?? this.repliesData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reviewData': reviewData.toMap(),
      'repliesData': repliesData.map((x) => x.toMap()).toList(),
    };
  }

  factory ReviewItem.fromMap(Map<String, dynamic> map){
    return ReviewItem(
      reviewData: ReviewData.fromMap(map['reviewData'] as Map<String,dynamic>),
      repliesData: List<RepliesData>.from((map['repliesData'] as List<int>).map<RepliesData>((x) => RepliesData.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewItem.fromJson(String source) => ReviewItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReviewItem(reviewData: $reviewData, repliesData: $repliesData)';

  @override
  bool operator ==(covariant ReviewItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.reviewData == reviewData &&
      listEquals(other.repliesData, repliesData);
  }

  @override
  int get hashCode => reviewData.hashCode ^ repliesData.hashCode;
}

class ReviewData {
    final String ? title;
    final String ? description;
    final String ? rating;
    final String ? userId;
    final String ? salonId;
    final List<RepliesData>? replies;
    final String ? createdAt;
    final String ? updatedAt;

    ReviewData({
      this.title,
      this.description,
      this.rating,
      this.userId,
      this.salonId,
      this.replies,
      this.createdAt,
      this.updatedAt,
    });
    

  ReviewData copyWith({
    String ? title,
    String ? description,
    String ? rating,
    String ? userId,
    String ? salonId,
    List<RepliesData>? replies,
    String ? createdAt,
    String ? updatedAt,
  }) {
    return ReviewData(
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      userId: userId ?? this.userId,
      salonId: salonId ?? this.salonId,
      replies: replies ?? this.replies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'rating': rating,
      'userId': userId,
      'salonId': salonId,
      'replies': replies?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ReviewData.fromMap(Map<String, dynamic> map) {
    return ReviewData(
      title: map['title'],
      description: map['description'],
      rating: map['rating'],
      userId: map['userId'],
      salonId: map['salonId'],
      replies: map['replies'] != null ? List<RepliesData>.from((map['replies'] as List<String>).map<RepliesData?>((x) => RepliesData.fromMap(x as Map<String,dynamic>),),) : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewData.fromJson(String source) => ReviewData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewData(title: $title, description: $description, rating: $rating, userId: $userId, salonId: $salonId, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class RepliesData {
    final String? title;
    final String? description;
    final String? userId;
    final List<String>? replies;
    final String? createdAt;
    final String? updatedAt;

  RepliesData({
    this.title,
    this.description,
    this.userId,
    this.replies,
    this.createdAt,
    this.updatedAt,
  });


  RepliesData copyWith({
    String? title,
    String? description,
    String? userId,
    List<String>? replies,
    String? createdAt,
    String? updatedAt,
  }) {
    return RepliesData(
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      replies: replies ?? this.replies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'userId': userId,
      'replies': replies,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RepliesData.fromMap(Map<String, dynamic> map) {
    return RepliesData(
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      replies: map['replies'] != null ? List<String>.from((map['replies'] as List<String>)) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RepliesData.fromJson(String source) => RepliesData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RepliesData(title: $title, description: $description, userId: $userId, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
