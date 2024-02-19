import 'dart:convert';
import 'package:naai/models/api_models/location_item_model.dart';

class UserResponseModel {
  final String? status;
  final String? message;
  final UserItemModel? data;
  
  UserResponseModel({
    this.status,
    this.message,
    this.data,
  });

  UserResponseModel copyWith({
    String? status,
    String? message,
    UserItemModel? data,
  }) {
    return UserResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap() ?? [],
    };
  }

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: UserItemModel.fromMap(map['data'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponseModel.fromJson(String source) => UserResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserResponseModel(status: $status, message: $message, data: $data)';
}

class UserItemModel {
  final Location? location;
  final FavouriteModel? favourite;
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

  UserItemModel({
    this.location,
    this.favourite,
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
  });

  UserItemModel copyWith({
    Location? location,
    FavouriteModel? favourite,
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
  }) {
    return UserItemModel(
      location: location ?? this.location,
      favourite: favourite ?? this.favourite,
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location?.toMap(),
      'favourite': favourite?.toMap(),
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
    };
  }

  factory UserItemModel.fromMap(Map<String, dynamic> map) {
    return UserItemModel(
      location: map['location'] != null ? Location.fromMap(map['location'] as Map<String,dynamic>) : null,
      favourite: map['favourite'] != null ? FavouriteModel.fromMap(map['favourite'] as Map<String,dynamic>) : null,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserItemModel.fromJson(String source) => UserItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserItemModel(location: $location, favourite: $favourite, id: $id, name: $name, email: $email, gender: $gender, phoneNumber: $phoneNumber, verified: $verified, status: $status, imageKey: $imageKey, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class FavouriteModel {
  final List<dynamic>? salons;
  final List<dynamic>? artists;

  FavouriteModel({
    this.salons,
    this.artists,
  });

  FavouriteModel copyWith({
    List<dynamic>? salons,
    List<dynamic>? artists,
  }) {
    return FavouriteModel(
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

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      salons: map['salons'] != null ? List<dynamic>.from((map['salons'] as List<dynamic>)) : null,
      artists: map['artists'] != null ? List<dynamic>.from((map['artists'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteModel.fromJson(String source) => FavouriteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FavouriteModel(salons: $salons, artists: $artists)';
}
