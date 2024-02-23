// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:naai/models/api_models/location_item_model.dart';
import 'package:naai/models/api_models/user_fav_item_model.dart';

class AddUserFavResponseModel {
 final String? status;
 final String? message;
 final FavDataModel? data;

  AddUserFavResponseModel({
    this.status,
    this.message,
    this.data,
  });


  AddUserFavResponseModel copyWith({
    String? status,
    String? message,
    FavDataModel? data,
  }) {
    return AddUserFavResponseModel(
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

  factory AddUserFavResponseModel.fromMap(Map<String, dynamic> map) {
    return AddUserFavResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? FavDataModel.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddUserFavResponseModel.fromJson(String source) => AddUserFavResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddUserFavResponseModel(status: $status, message: $message, data: $data)';

}

class FavDataModel {
  final String? id;
  final String? name;
  final String? email;
  final String? gender;
  final int? phoneNumber;
  final bool? verified;
  final String? status;
  final String? imageKey;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;
  final Location? location;
  final UserFavItemModel favourite;

  FavDataModel({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.phoneNumber,
    this.verified,
    this.status,
    this.imageKey,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.location,
    required this.favourite,
  });

  FavDataModel copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    int? phoneNumber,
    bool? verified,
    String? status,
    String? imageKey,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    Location? location,
    UserFavItemModel? favourite,
  }) {
    return FavDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verified: verified ?? this.verified,
      status: status ?? this.status,
      imageKey: imageKey ?? this.imageKey,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      favourite: favourite ?? this.favourite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'verified': verified,
      'status': status,
      'imageKey': imageKey,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'location': location?.toMap(),
      'favourite': favourite.toMap(),
    };
  }

  factory FavDataModel.fromMap(Map<String, dynamic> map) {
    return FavDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as int : null,
      verified: map['verified'] != null ? map['verified'] as bool : null,
      status: map['status'] != null ? map['status'] as String : null,
      imageKey: map['imageKey'] != null ? map['imageKey'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      location: map['location'] != null ? Location.fromMap(map['location'] as Map<String,dynamic>) : null,
      favourite: UserFavItemModel.fromMap(map['favourite'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavDataModel.fromJson(String source) => FavDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FavDataModel(id: $id, name: $name, email: $email, gender: $gender, phoneNumber: $phoneNumber, verified: $verified, status: $status, imageKey: $imageKey, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, location: $location, favourite: $favourite)';
  }

}
