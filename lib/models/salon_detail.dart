// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

import 'package:naai/models/artist_model.dart';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  String status;
  String message;
  ApiResponseData data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    status: json["status"],
    message: json["message"],
    data: ApiResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class ApiResponseData {
  DataData data;
  List<Artist2> artists;
  List<DataService> services;

  ApiResponseData({
    required this.data,
    required this.artists,
    required this.services,
  });

  factory ApiResponseData.fromJson(Map<String, dynamic> json) => ApiResponseData(
    data: DataData.fromJson(json["data"]),
    artists: List<Artist2>.from(json["artists"].map((x) => Artist2.fromJson(x))),
    services: List<DataService>.from(json["services"].map((x) => DataService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}


class Artist2 {
  Location location;
  ArtistTiming timing;
  Links links;
  String id;
  String name;
  double rating;
  String salonId;
  List<Service> services;
  int phoneNumber;
  bool availability;
  bool live;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<String> offDay;
  bool paid;
  int bookings;
  String targetGender;
  String? imageKey;
  String? imageUrl;

  Artist2({
    required this.location,
    required this.timing,
    required this.links,
    required this.id,
    required this.name,
    required this.rating,
    required this.salonId,
    required this.services,
    required this.phoneNumber,
    required this.availability,
    required this.live,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.offDay,
    required this.paid,
    required this.bookings,
    required this.targetGender,
    this.imageKey,
    this.imageUrl,
  });

  factory Artist2.fromJson(Map<String, dynamic> json) => Artist2(
    location: Location.fromJson(json["location"] ?? {}),
    timing: ArtistTiming.fromJson(json["timing"] ?? {}),
    links: Links.fromJson(json["links"] ?? {}),
    id: json["_id"] ?? '',
    name: json["name"] ?? '',
    rating: (json["rating"] ?? 0).toDouble(),
    salonId: json["salonId"] ?? '',
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    phoneNumber: json["phoneNumber"] ?? 0,
    availability: json["availability"] ?? false,
    live: json["live"] ?? false,
    createdAt: DateTime.parse(json["createdAt"]?.toString() ?? ''),
    updatedAt: DateTime.parse(json["updatedAt"]?.toString() ?? ''),
    v: json["__v"] ?? 0,
    offDay: List<String>.from(json["offDay"]?.map((x) => x?.toString()) ?? []),
    paid: json["paid"] ?? false,
    bookings: json["bookings"] ?? 0,
    targetGender: json["targetGender"] ?? '',
    imageKey: json["imageKey"]?? '',
    imageUrl: json["imageUrl"]??'',
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "timing": timing.toJson(),
    "links": links.toJson(),
    "_id": id,
    "name": name,
    "rating": rating,
    "salonId": salonId,
    "services": List<dynamic>.from(services.map((x) => x)),
    "phoneNumber": phoneNumber,
    "availability": availability,
    "live": live,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "offDay": List<dynamic>.from(offDay.map((x) => x)),
    "paid": paid,
    "bookings": bookings,
    "targetGender": targetGender,
    "imageKey": imageKey,
    "imageUrl": imageUrl,
  };
}



class Links {
  String instagram;

  Links({
    required this.instagram,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    instagram: json["instagram"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "instagram": instagram,
  };
}
class Location {
  String type;
  List<double> coordinates; // Change type to List<double>

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"]?? '',
    coordinates: List<double>.from(json["coordinates"]?.map((x) => x.toDouble()) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class ArtistTiming {
  String start;
  String end;

  ArtistTiming({
    required this.start,
    required this.end,
  });

  factory ArtistTiming.fromJson(Map<String, dynamic> json) => ArtistTiming(
    start: json["start"] ?? '',
    end: json["end"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}

class DataData {
  Location location;
  DataTiming timing;
  Links links;
  String id;
  String address;
  String name;
  String salonType;
  double rating;
  String closedOn;
  int phoneNumber;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  bool live;
  bool paid;
  int bookings;
  int discount;
  String owner;
  String gst;
  String pan;
  List<ImageData2> images;  // Added this field

  DataData({
    required this.location,
    required this.timing,
    required this.links,
    required this.id,
    required this.address,
    required this.name,
    required this.salonType,
    required this.rating,
    required this.closedOn,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.live,
    required this.paid,
    required this.bookings,
    required this.discount,
    required this.owner,
    required this.gst,
    required this.pan,
    required this.images,  // Added this field
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(

    location: Location.fromJson(json["location"] ?? {}),
    timing: DataTiming.fromJson(json["timing"] ?? {}),
    links: Links.fromJson(json["links"] ?? {}),
    id: json["_id"] ?? '',
    address: json["address"] ?? '',
    name: json["name"] ?? '',
    salonType: json["salonType"] ?? '',
    rating: (json["rating"] ?? 0).toDouble(),
    closedOn: json["closedOn"] ?? '',
    phoneNumber: json["phoneNumber"] ?? 0,
    createdAt: DateTime.parse(json["createdAt"] ?? ''),
    updatedAt: DateTime.parse(json["updatedAt"] ?? ''),
    v: json["__v"] ?? 0,
    live: json["live"] ?? false,
    paid: json["paid"] ?? false,
    bookings: json["bookings"] ?? 0,
    discount: json["discount"] ?? 0,
    owner: json["owner"] ?? '',
    gst: json["gst"] ?? '',
    pan: json["pan"] ?? '',
    images: json["images"] != null ? List<ImageData2>.from(json["images"].map((x) => ImageData2.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "timing": timing.toJson(),
    "links": links.toJson(),
    "_id": id,
    "address": address,
    "name": name,
    "salonType": salonType,
    "rating": rating,
    "closedOn": closedOn,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "live": live,
    "paid": paid,
    "bookings": bookings,
    "discount": discount,
    "owner": owner,
    "gst": gst,
    "pan": pan,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class ImageData2 {
  String key;
  String url;
  String id;

  ImageData2({
    required this.key,
    required this.url,
    required this.id,
  });

  factory ImageData2.fromJson(Map<String, dynamic> json) => ImageData2(
    key: json["key"] ?? '',
    url: json["url"] ?? '',
    id: json["_id"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "url": url,
    "_id": id,
  };
  static List<ImageData2> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      // If the input is null, return an empty list
      return [];
    }

    return jsonList.map((json) => ImageData2.fromJson(json)).toList();
  }
}

class DataTiming {
  String opening;
  String closing;

  DataTiming({
    required this.opening,
    required this.closing,
  });

  factory DataTiming.fromJson(Map<String, dynamic> json) => DataTiming(
    opening: json["opening"]?? '',
    closing: json["closing"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "opening": opening,
    "closing": closing,
  };
}

class barberServices {
  final String serviceId;
  final int price;
  final String id;
  List<PurpleVariable> variables;


  barberServices({
    required this.serviceId,
    required this.price,
    required this.id,
    required this.variables,
  });

  factory barberServices.fromJson(Map<String, dynamic> json) => barberServices(
    serviceId: json["serviceId"]??'',
    price: json["price"]?? '',
    id: json["_id"]?? '',
    variables: List<PurpleVariable>.from(json["variables"].map((x) => PurpleVariable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "price": price,
    "_id": id,
    "variables": List<dynamic>.from(variables.map((x) => x.toJson())),
  };
}
class PurpleVariable {
  String variableId;
  int price;
  String id;

  PurpleVariable({
    required this.variableId,
    required this.price,
    required this.id,
  });

  factory PurpleVariable.fromJson(Map<String, dynamic> json) => PurpleVariable(
    variableId: json["variableId"]?? '',
    price: json["price"]?? '',
    id: json["_id"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "variableId": variableId,
    "price": price,
    "_id": id,
  };
}
class DataService {
  String id;
  String salonId;
  String category;
  String serviceTitle;
  String description;
  String targetGender;
  int avgTime;
  int basePrice;
  int cutPrice;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<FluffyVariable> variables;

  DataService({
    required this.id,
    required this.salonId,
    required this.category,
    required this.serviceTitle,
    required this.description,
    required this.targetGender,
    required this.avgTime,
    required this.basePrice,
    required this.cutPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.variables,
  });

  factory DataService.fromJson(Map<String, dynamic> json) => DataService(
    id: json["_id"] ?? '',
    salonId: json["salonId"]?? '',
    category: json["category"]?? '',
    serviceTitle: json["serviceTitle"]?? '',
    description: json["description"]?? '',
    targetGender: json["targetGender"]?? '',
    avgTime: json["avgTime"]?? '',
    basePrice: json["basePrice"]?? '',
    cutPrice: json["cutPrice"]?? '',
    createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
    v: json["__v"]?? 0,
    variables: List<FluffyVariable>.from(json["variables"].map((x) => FluffyVariable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "salonId": salonId,
    "category": category,
    "serviceTitle": serviceTitle,
    "description": description,
    "targetGender": targetGender,
    "avgTime": avgTime,
    "basePrice": basePrice,
    "cutPrice": cutPrice,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "variables": List<dynamic>.from(variables.map((x) => x.toJson())),
  };
}

class FluffyVariable {
  String variableType;
  String variableName;
  int variablePrice;
  int variableCutPrice;
  int variableTime;
  String id;

  FluffyVariable({
    required this.variableType,
    required this.variableName,
    required this.variablePrice,
    required this.variableCutPrice,
    required this.variableTime,
    required this.id,
  });

  factory FluffyVariable.fromJson(Map<String, dynamic> json) => FluffyVariable(
    variableType: json["variableType"] ?? '',
    variableName: json["variableName"] ?? '',
    variablePrice: json["variablePrice"]?? '',
    variableCutPrice: json["variableCutPrice"]?? '',
    variableTime: json["variableTime"]?? '',
    id: json["_id"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "variableType": variableType,
    "variableName": variableName,
    "variablePrice": variablePrice,
    "variableCutPrice": variableCutPrice,
    "variableTime": variableTime,
    "_id": id,
  };
}
