// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReviewItem {
  final ReviewData review;
  final List<RepliesData> replies;

  ReviewItem({
    required this.review,
    required this.replies,
  });
  

  ReviewItem copyWith({
    ReviewData? review,
    List<RepliesData>? replies,
  }) {
    return ReviewItem(
      review: review ?? this.review,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'review': review.toMap(),
      'replies': replies.map((x) => x.toMap()).toList(),
    };
  }

  factory ReviewItem.fromMap(Map<String, dynamic> map) {
    return ReviewItem(
      review: ReviewData.fromMap(map['review']),
      replies: List<RepliesData>.from((map['replies'] as List<dynamic>).map<RepliesData>((x) => RepliesData.fromMap(x),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewItem.fromJson(String source) => ReviewItem.fromMap(json.decode(source));

  @override
  String toString() => 'ReviewItem(review: $review, replies: $replies)';
}

class ReviewData {
    final String ? title;
    final String ? description;
    final int ? rating;
    final String ? userId;
    final String ? salonId;
    final List<dynamic>? replies;
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
    int ? rating,
    String ? userId,
    String ? salonId,
    List<dynamic>? replies,
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
      replies: map['replies'] != null ? List<dynamic>.from((map['replies'] as List<dynamic>)) : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewData.fromJson(String source) => ReviewData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewData(title: $title, description: $description, rating: $rating, userId: $userId, salonId: $salonId, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class RepliesData {
    final String? title;
    final String? description;
    final String? userId;
    final List<dynamic>? replies;
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
    List<dynamic>? replies,
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
      replies: map['replies'] != null ? List<dynamic>.from((map['replies'] as List<dynamic>)) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RepliesData.fromJson(String source) => RepliesData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RepliesData(title: $title, description: $description, userId: $userId, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
