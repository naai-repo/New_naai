// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserFavItemModel {
   final List<String>? salons;
   final List<String>? artists;

  UserFavItemModel({
    this.salons,
    this.artists,
  });

  UserFavItemModel copyWith({
    List<String>? salons,
    List<String>? artists,
  }) {
    return UserFavItemModel(
      salons: salons ?? this.salons,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salons': salons,
      'artists': artists,
    };
  }

  factory UserFavItemModel.fromMap(Map<String, dynamic> map) {
    return UserFavItemModel(
      salons: map['salons'] != null ? List<String>.from((map['salons'] as List<String>)) : null,
      artists: map['artists'] != null ? List<String>.from((map['artists'] as List<String>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFavItemModel.fromJson(String source) => UserFavItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
