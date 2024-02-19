import 'dart:convert';

import 'package:naai/models/api_models/location_item_model.dart';

class SalonResponseData {
  final String? id;
  final String? address;
  final String? name;
  final String? salonType;
  final Timing? timing;
  final double? rating;
  final String? closedOn;
  final int? phoneNumber;
  final Location? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? live;
  final bool? paid;
  final int? bookings;
  final int? discount;
  final String? owner;
  final String? gst;
  final String? pan;
  final Map<String, String>? links;
  final List<ImageData>? images;
  final double? distance;
  final double? score;

  SalonResponseData({
    this.id,
    this.address,
    this.name,
    this.salonType,
    this.timing,
    this.rating,
    this.closedOn,
    this.phoneNumber,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.live,
    this.paid,
    this.bookings,
    this.discount,
    this.owner,
    this.gst,
    this.pan,
    this.links,
    this.images,
    this.distance,
    this.score,
  });

  

  SalonResponseData copyWith({
    String? id,
    String? address,
    String? name,
    String? salonType,
    Timing? timing,
    double? rating,
    String? closedOn,
    int? phoneNumber,
    Location? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? live,
    bool? paid,
    int? bookings,
    int? discount,
    String? owner,
    String? gst,
    String? pan,
    Map<String, String>? links,
    List<ImageData>? images,
    double? distance,
    double? score,
  }) {
    return SalonResponseData(
      id: id ?? this.id,
      address: address ?? this.address,
      name: name ?? this.name,
      salonType: salonType ?? this.salonType,
      timing: timing ?? this.timing,
      rating: rating ?? this.rating,
      closedOn: closedOn ?? this.closedOn,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      live: live ?? this.live,
      paid: paid ?? this.paid,
      bookings: bookings ?? this.bookings,
      discount: discount ?? this.discount,
      owner: owner ?? this.owner,
      gst: gst ?? this.gst,
      pan: pan ?? this.pan,
      links: links ?? this.links,
      images: images ?? this.images,
      distance: distance ?? this.distance,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'name': name,
      'salonType': salonType,
      'timing': timing?.toMap(),
      'rating': rating,
      'closedOn': closedOn,
      'phoneNumber': phoneNumber,
      'location': location?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'live': live,
      'paid': paid,
      'bookings': bookings,
      'discount': discount,
      'owner': owner,
      'gst': gst,
      'pan': pan,
      'links': links,
      'images': images?.map((x) => x.toMap()).toList() ?? [],
      'distance': distance,
      'score': score,
    };
  }

  factory SalonResponseData.fromMap(Map<String, dynamic> map) {
    return SalonResponseData(
      id: map['id'] != null ? map['id'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      salonType: map['salonType'] != null ? map['salonType'] as String : null,
      timing: map['timing'] != null ? Timing.fromMap(map['timing'] as Map<String,dynamic>) : null,
      rating: map['rating'] != null ? double.tryParse(map['rating'].toString())  : null,
      closedOn: map['closedOn'] != null ? map['closedOn'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as int : null,
      location: map['location'] != null ? Location.fromMap(map['location'] as Map<String,dynamic>) : null,
      createdAt: map['createdAt'] != null ? DateTime(0) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(0) : null,
      live: map['live'] != null ? map['live'] as bool : null,
      paid: map['paid'] != null ? map['paid'] as bool : null,
      bookings: map['bookings'] != null ? map['bookings'] as int : null,
      discount: map['discount'] != null ? map['discount'] as int : null,
      owner: map['owner'] != null ? map['owner'] as String : null,
      gst: map['gst'] != null ? map['gst'] as String : null,
      pan: map['pan'] != null ? map['pan'] as String : null,
      links: map['links'] != null ? Map<String, String>.from((map['links'] as Map<String, dynamic>)) : null,
      images: map['images'] != null ? List<ImageData>.from((map['images'] as List<dynamic>).map<ImageData?>((x) => ImageData.fromMap(x as Map<String,dynamic>),),) : null,
      distance: map['distance'] != null ? map['distance'] as double : null,
      score: map['score'] != null ? map['score'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonResponseData.fromJson(String source) => SalonResponseData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalonResponseData(id: $id, address: $address, name: $name, salonType: $salonType, timing: $timing, rating: $rating, closedOn: $closedOn, phoneNumber: $phoneNumber, location: $location, createdAt: $createdAt, updatedAt: $updatedAt, live: $live, paid: $paid, bookings: $bookings, discount: $discount, owner: $owner, gst: $gst, pan: $pan, links: $links, images: $images, distance: $distance, score: $score)';
  }
}

class ImageData {
  final String? key;
  final String? url;
  final String? id;

  ImageData({
    required this.key,
    required this.url,
    required this.id,
  });
  

  ImageData copyWith({
    String? key,
    String? url,
    String? id,
  }) {
    return ImageData(
      key: key ?? this.key,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'url': url,
      'id': id,
    };
  }

  factory ImageData.fromMap(Map<String, dynamic> map) {
    return ImageData(
      key: map['key'] != null ? map['key'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageData.fromJson(String source) => ImageData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ImageData(key: $key, url: $url, id: $id)';
}

class Timing {
  final String? opening;
  final String? closing;

  Timing({
    required this.opening,
    required this.closing,
  });


  Timing copyWith({
    String? opening,
    String? closing,
  }) {
    return Timing(
      opening: opening ?? this.opening,
      closing: closing ?? this.closing,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'opening': opening,
      'closing': closing,
    };
  }

  factory Timing.fromMap(Map<String, dynamic> map) {
    return Timing(
      opening: map['opening'] != null ? map['opening'] as String : null,
      closing: map['closing'] != null ? map['closing'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Timing.fromJson(String source) => Timing.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Timing(opening: $opening, closing: $closing)';
}
