// To parse this JSON data, do
//
//     final allBooking = allBookingFromJson(jsonString);

import 'dart:convert';

AllBooking allBookingFromJson(String str) => AllBooking.fromJson(json.decode(str));

String allBookingToJson(AllBooking data) => json.encode(data.toJson());

class AllBooking {
  String userId;
  List<CurrentBooking> currentBookings;
  List<PrevBooking> prevBooking;
  List<CurrentBooking> comingBookings;

  AllBooking({
    required this.userId,
    required this.currentBookings,
    required this.prevBooking,
    required this.comingBookings,
  });

  factory AllBooking.fromJson(Map<String, dynamic> json) => AllBooking(
    userId: json["userId"],
    currentBookings: List<CurrentBooking>.from(json["current_bookings"].map((x) =>CurrentBooking.fromJson(x))),
    prevBooking: List<PrevBooking>.from(json["prev_booking"].map((x) => PrevBooking.fromJson(x))),
    comingBookings: List<CurrentBooking>.from(json["coming_bookings"].map((x) => CurrentBooking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "current_bookings": List<dynamic>.from(currentBookings.map((x) => x.toJson())),
    "prev_booking": List<dynamic>.from(prevBooking.map((x) => x.toJson())),
    "coming_bookings": List<dynamic>.from(comingBookings.map((x) => x.toJson())),
  };
}

class CurrentBooking {
  TimeSlot timeSlot;
  String id;
  String userId;
  String salonId;
  String paymentId;
  String paymentStatus;
  DateTime bookingDate;
  List<ArtistServiceMap> artistServiceMap;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? bookingType;
  String?  salonName ;

  CurrentBooking({
    required this.timeSlot,
    required this.id,
    required this.userId,
    required this.salonId,
    required this.paymentId,
    required this.paymentStatus,
    required this.bookingDate,
    required this.artistServiceMap,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.salonName,
    this.bookingType,
  });

  factory CurrentBooking.fromJson(Map<String, dynamic> json) =>CurrentBooking(
    timeSlot: TimeSlot.fromJson(json["timeSlot"]),
    id: json["_id"],
    userId: json["userId"],
    salonId: json["salonId"],
    paymentId: json["paymentId"],
    paymentStatus: json["paymentStatus"],
    bookingDate: DateTime.parse(json["bookingDate"]),
    artistServiceMap: List<ArtistServiceMap>.from(json["artistServiceMap"].map((x) => ArtistServiceMap.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    salonName: json['salonName'],
    bookingType: json["bookingType"],
  );

  Map<String, dynamic> toJson() => {
    "timeSlot": timeSlot.toJson(),
    "_id": id,
    "userId": userId,
    "salonId": salonId,
    "paymentId": paymentId,
    "paymentStatus": paymentStatus,
    "bookingDate": bookingDate.toIso8601String(),
    "artistServiceMap": List<dynamic>.from(artistServiceMap.map((x) => x.toJson())),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "bookingType": bookingType,
    "salonName": salonName ?? '',
  };
  void setSalonName(String name){
    this.salonName = name;
  }
}

class ArtistServiceMap {
  TimeSlot timeSlot;
  String artistId;
  String serviceId;
  String id;
  String? chosenBy;

  ArtistServiceMap({
    required this.timeSlot,
    required this.artistId,
    required this.serviceId,
    required this.id,
    this.chosenBy,
  });

  factory ArtistServiceMap.fromJson(Map<String, dynamic> json) => ArtistServiceMap(
    timeSlot: TimeSlot.fromJson(json["timeSlot"]),
    artistId: json["artistId"],
    serviceId: json["serviceId"],
    id: json["_id"],
    chosenBy: json["chosenBy"],
  );

  Map<String, dynamic> toJson() => {
    "timeSlot": timeSlot.toJson(),
    "artistId": artistId,
    "serviceId": serviceId,
    "_id": id,
    "chosenBy": chosenBy,
  };
}
class TimeSlot {
  String start;
  String end;

  TimeSlot({
    required this.start,
    required this.end,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    if (json["timeSlot"] == null) {
      // Handle the case where 'timeSlot' is null (add appropriate handling logic)
      return TimeSlot(start: "10:30", end: "11:30");
    }

    return TimeSlot(
      start: (json["start"] as String) ?? "",
      end: (json["end"] as String) ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}




class PrevBooking {
  TimeSlot timeSlot;
  String id;
  String userId;
  String salonId;
  String paymentId;
  String paymentStatus;
  DateTime bookingDate;
  List<ArtistServiceMap> artistServiceMap;
  DateTime createdAt;
  DateTime updatedAt;
  String? salonName;
  int v;

  PrevBooking({
    required this.timeSlot,
    required this.id,
    required this.userId,
    required this.salonId,
    required this.paymentId,
    required this.paymentStatus,
    required this.bookingDate,
    required this.artistServiceMap,
    required this.createdAt,
    required this.updatedAt,
    required this.salonName,
    required this.v,
  });

  factory PrevBooking.fromJson(Map<String, dynamic> json) => PrevBooking(
    timeSlot: TimeSlot.fromJson(json["timeSlot"]),
    id: json["_id"],
    userId: json["userId"],
    salonId: json["salonId"],
    paymentId: json["paymentId"],
    paymentStatus: json["paymentStatus"],
    bookingDate: DateTime.parse(json["bookingDate"]),
    artistServiceMap: List<ArtistServiceMap>.from(json["artistServiceMap"].map((x) => ArtistServiceMap.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    salonName: json['salonName'],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "timeSlot": timeSlot.toJson(),
    "_id": id,
    "userId": userId,
    "salonId": salonId,
    "paymentId": paymentId,
    "paymentStatus": paymentStatus,
    "bookingDate": bookingDate.toIso8601String(),
    "artistServiceMap": List<dynamic>.from(artistServiceMap.map((x) => x.toJson())),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "salonName": salonName ?? '',
    "__v": v,
  };
  void setSalonName(String name){
    this.salonName = name;
  }
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
