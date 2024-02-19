import 'dart:convert';
import 'package:naai/models/api_models/location_item_model.dart';


class ArtistDataModel {
  final String? id;
  final String? name;
  final double? rating;
  final String? salonId;
  final List<Service>? services;
  final Location? location;
  final int? phoneNumber;
  final bool? availability;
  final bool? live;
  final String? createdAt;
  final String? updatedAt;
  final int? bookings;
  final double? distance;
  final double? score;
  final String? imageKey;
  final String? imageUrl;
  final String? salonName;

  ArtistDataModel({
    this.id,
    this.name,
    this.rating,
    this.salonId,
    this.services,
    this.location,
    this.phoneNumber,
    this.availability,
    this.live,
    this.createdAt,
    this.updatedAt,
    this.bookings,
    this.distance,
    this.score,
    this.imageKey,
    this.imageUrl,
    this.salonName,
  });

  ArtistDataModel copyWith({
    String? id,
    String? name,
    double? rating,
    String? salonId,
    List<Service>? services,
    Location? location,
    int? phoneNumber,
    bool? availability,
    bool? live,
    String? createdAt,
    String? updatedAt,
    int? bookings,
    double? distance,
    double? score,
    String? imageKey,
    String? imageUrl,
    String? salonName,
  }) {
    return ArtistDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      salonId: salonId ?? this.salonId,
      services: services ?? this.services,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      availability: availability ?? this.availability,
      live: live ?? this.live,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookings: bookings ?? this.bookings,
      distance: distance ?? this.distance,
      score: score ?? this.score,
      imageKey: imageKey ?? this.imageKey,
      imageUrl: imageUrl ?? this.imageUrl,
      salonName: salonName ?? this.salonName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'rating': rating,
      'salonId': salonId,
      'services': services?.map((x) => x.toMap()).toList() ?? [],
      'location': location?.toMap(),
      'phoneNumber': phoneNumber,
      'availability': availability,
      'live': live,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bookings': bookings,
      'distance': distance,
      'score': score,
      'imageKey': imageKey,
      'imageUrl': imageUrl,
      'salonName': salonName,
    };
  }

  factory ArtistDataModel.fromMap(Map<String, dynamic> map) {
    return ArtistDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      rating: map['rating'] != null ? double.tryParse(map['rating'].toString()) : null,
      salonId: map['salonId'] != null ? map['salonId'] as String : null,
      services: map['services'] != null ? List<Service>.from((map['services'] as List<dynamic>).map<Service?>((x) => Service.fromMap(x as Map<String,dynamic>),),) : null,
      location: map['location'] != null ? Location.fromMap(map['location'] as Map<String,dynamic>) : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as int : null,
      availability: map['availability'] != null ? map['availability'] as bool : null,
      live: map['live'] != null ? map['live'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      bookings: map['bookings'] != null ? map['bookings'] as int : null,
      distance: map['distance'] != null ? map['distance'] as double : null,
      score: map['score'] != null ? map['score'] as double : null,
      imageKey: map['imageKey'] != null ? map['imageKey'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      salonName: map['salonName'] != null ? map['salonName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistDataModel.fromJson(String source) => ArtistDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistDataModel(id: $id, name: $name, rating: $rating, salonId: $salonId, services: $services, location: $location, phoneNumber: $phoneNumber, availability: $availability, live: $live, createdAt: $createdAt, updatedAt: $updatedAt, bookings: $bookings, distance: $distance, score: $score, imageKey: $imageKey, imageUrl: $imageUrl, salonName: $salonName)';
  }
}

class Service {
  final String? serviceId;
  final int? price;
  final String? id;
  final List<Variables>? variables;

  Service({
    this.serviceId,
    this.price,
    this.id,
    required this.variables,
  });

  Service copyWith({
    String? serviceId,
    int? price,
    String? id,
    List<Variables>? variables,
  }) {
    return Service(
      serviceId: serviceId ?? this.serviceId,
      price: price ?? this.price,
      id: id ?? this.id,
      variables: variables ?? this.variables,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serviceId': serviceId,
      'price': price,
      'id': id,
      'variables': variables?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceId: map['serviceId'] != null ? map['serviceId'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      id: map['id'] != null ? map['id'] as String : null,
      variables: map['variables'] != null ? List<Variables>.from((map['variables'] as List<dynamic>).map<Variables?>((x) => Variables.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) => Service.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Service(serviceId: $serviceId, price: $price, id: $id, variables: $variables)';
  }
}

class Variables {
  final String? id;
  final String? variableId;
  final int? price;

  Variables({
    this.id,
    this.variableId,
    this.price,
  });

  Variables copyWith({
    String? id,
    String? variableId,
    int? price,
  }) {
    return Variables(
      id: id ?? this.id,
      variableId: variableId ?? this.variableId,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'variableId': variableId,
      'price': price,
    };
  }

  factory Variables.fromMap(Map<String, dynamic> map) {
    return Variables(
      id: map['id'] != null ? map['id'] as String : null,
      variableId: map['variableId'] != null ? map['variableId'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Variables.fromJson(String source) => Variables.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Variables(id: $id, variableId: $variableId, price: $price)';

}