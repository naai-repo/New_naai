// To parse this JSON data, do
//
//     final artistResponse = artistResponseFromJson(jsonString);

import 'dart:convert';

ArtistResponse artistResponseFromJson(String str) => ArtistResponse.fromJson(json.decode(str));

String artistResponseToJson(ArtistResponse data) => json.encode(data.toJson());

class ArtistResponse {
  String status;
  String message;
  Data data;

  ArtistResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistResponse.fromJson(Map<String, dynamic> json) => ArtistResponse(
    status: json["status"],
    message: json["message"],
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
  Timing timing;
  Links links;
  String id;
  String name;
  double rating;
  String salonId;
  List<Service2> services;
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
  String imageKey;
  String imageUrl;
  double distance;
  double score;
  Data({
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
    required this.imageKey,
    required this.imageUrl,
    required this.distance,
    required this.score,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: Location.fromJson(json["location"] ?? {}),
    timing: Timing.fromJson(json["timing"]?? {}),
    links: Links.fromJson(json["links"]?? ''),
    id: json["_id"]?? '',
    name: json["name"]?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    salonId: json["salonId"]?? '',
    services: List<Service2>.from(json["services"].map((x) => Service2.fromJson(x))),
    phoneNumber: json["phoneNumber"]?? '',
    availability: json["availability"]?? '',
    live: json["live"]?? '',
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    offDay: List<String>.from(json["offDay"].map((x) => x)),
    paid: json["paid"],
    bookings: json["bookings"]?? '',
    targetGender: json["targetGender"]?? '',
    imageKey: json["imageKey"]?? '',
    imageUrl: json["imageUrl"]??'',
    distance: json["distance"]?.toDouble()?? 0.0,
    score: json["score"]?.toDouble()?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "timing": timing.toJson(),
    "links": links.toJson(),
    "_id": id,
    "name": name,
    "rating": rating,
    "salonId": salonId,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
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
    "distance": distance,
    "score": score,
  };
}

class Links {
  String instagram;

  Links({
    required this.instagram,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    instagram: json["instagram"],
  );

  Map<String, dynamic> toJson() => {
    "instagram": instagram,
  };
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class Service2 {
  String serviceId;
  int price;
  String id;
  List<Variable>? variables;

  Service2({
    required this.serviceId,
    required this.price,
    required this.id,
    this.variables,
  });

  factory Service2.fromJson(Map<String, dynamic> json) {
    return Service2(
      serviceId: json["serviceId"],
      price: json["price"],
      id: json["_id"],
      variables: json.containsKey("variables")
          ? List<Variable>.from(json["variables"].map((x) => Variable.fromJson(x)))
          : null, // Check if "variables" key exists
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "serviceId": serviceId,
      "price": price,
      "_id": id,
    };
    if (variables != null) {
      data["variables"] = List<dynamic>.from(variables!.map((x) => x.toJson()));
    }
    return data;
  }
}

class Variable {
  String variableId;
  int price;
  String id;

  Variable({
    required this.variableId,
    required this.price,
    required this.id,
  });

  factory Variable.fromJson(Map<String, dynamic> json) => Variable(
    variableId: json["variableId"],
    price: json["price"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "variableId": variableId,
    "price": price,
    "_id": id,
  };
}

class Timing {
  String start;
  String end;

  Timing({
    required this.start,
    required this.end,
  });

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}
