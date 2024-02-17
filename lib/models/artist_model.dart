import 'dart:convert';

ArtistApiResponse artistApiResponseFromJson(String str) => ArtistApiResponse.fromJson(json.decode(str));

String artistApiResponseToJson(ArtistApiResponse data) => json.encode(data.toJson());

class ArtistApiResponse {
  final String status;
  final String message;
  final List<ArtistData> data;

  ArtistApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistApiResponse.fromJson(Map<String, dynamic> json) => ArtistApiResponse(
    status: json["status"],
    message: json["message"],
    data: List<ArtistData>.from(json["data"].map((x) => ArtistData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ArtistData {
  String id;
  String name;
  double rating;
  String salonId;
  List<Service> services;
  String targetGender;
  Location location;
  int phoneNumber;
  Timing timing;
  List<String> offDay;
  bool availability;
  bool live;
  bool paid;
  int bookings;
  Links links;
  String imageKey;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  double distance;
  double score;
  String salonName;

  ArtistData({
    required this.id,
    required this.name,
    required this.rating,
    required this.salonId,
    required this.services,
    required this.targetGender,
    required this.location,
    required this.phoneNumber,
    required this.timing,
    required this.offDay,
    required this.availability,
    required this.live,
    required this.paid,
    required this.bookings,
    required this.links,
    required this.imageKey,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.distance,
    required this.score,
    required this.salonName
  });

  factory ArtistData.fromJson(Map<String, dynamic> json) => ArtistData(
    id: json["_id"]?? '',
    name: json["name"]?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    salonId: json["salonId"]?? '',
    salonName: json['salonName'] ?? '',
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    targetGender: json["targetGender"] ?? '',
    location: Location.fromJson(json["location"]?? ''),
    phoneNumber: json["phoneNumber"]??'',
    timing: Timing.fromJson(json["timing"]?? ''),
    offDay: List<String>.from(json["offDay"].map((x) => x)),
    availability: json["availability"]?? '',
    live: json["live"]?? '',
    paid: json["paid"]?? '',
    bookings: json["bookings"],
    links: Links.fromJson(json["links"]),
    imageKey: json["imageKey"],
    imageUrl: json["imageUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    distance: json["distance"]?.toDouble(),
    score: json["score"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "rating": rating,
    "salonId": salonId,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "targetGender": targetGender,
    "location": location.toJson(),
    "phoneNumber": phoneNumber,
    "timing": timing.toJson(),
    "offDay": List<dynamic>.from(offDay.map((x) => x)),
    "availability": availability,
    "live": live,
    "paid": paid,
    "bookings": bookings,
    "links": links.toJson(),
    "imageKey": imageKey,
    "imageUrl": imageUrl,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "distance": distance,
    "score": score,
  };
  @override
  String toString() {
    return 'ArtistData{id: $id, name: $name, rating: $rating, salonId: $salonId, services: $services, location: $location, phoneNumber: $phoneNumber, availability: $availability, live: $live, createdAt: $createdAt, updatedAt: $updatedAt, bookings: $bookings, distance: $distance, score: $score, imageKey: $imageKey, imageUrl: $imageUrl , salonName: $salonName}';
  }

  void setSalonName(String name) {
    this.salonName = name;
  }
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
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
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
class Service {
  String serviceId;
  int price;
  String id;
  List<Variable>? variables;

  Service({
    required this.serviceId,
    required this.price,
    required this.id,
    this.variables,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceId: json["serviceId"],
    price: json["price"],
    id: json["_id"],
    variables: json["variables"] == null ? [] : List<Variable>.from(json["variables"]!.map((x) => Variable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "price": price,
    "_id": id,
    "variables": variables == null ? [] : List<dynamic>.from(variables!.map((x) => x.toJson())),
  };
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




/*
for(var username in reviewItem.data) {
          var userId = username.userId;
          print('userId:- $userId');
          var userResponse = await Dio().get(
              'http://13.235.49.214:8800/customer/user/$userId');
          if (userResponse.data != null && userResponse.data is Map<String, dynamic>) {
            dynamic userprofile = ProfileResponse.fromJson(userResponse.data);
            username.setUserName(userprofile);
            print('Username is :- ${userprofile}');
          }
        }
 */