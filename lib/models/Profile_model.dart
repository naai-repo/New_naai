// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  String status;
  String message;
  Data data;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    status: json["status"]?? '',
    message: json["message"]?? '',
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Location location;
  String id;
  String name;
  String email;
  String gender;
  int phoneNumber;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String status;

  Data({
    required this.location,
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.phoneNumber,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: Location.fromJson(json["location"]),
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    phoneNumber: json["phoneNumber"],
    verified: json["verified"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "location": location,
    "_id": id,
    "name": name,
    "email": email,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "verified": verified,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "status": status,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }
}
