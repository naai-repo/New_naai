// To parse this JSON data, do
//
//     final allBooking = allBookingFromJson(jsonString);

import 'dart:convert';

AllBooking allBookingFromJson(String str) => AllBooking.fromJson(json.decode(str));

String allBookingToJson(AllBooking data) => json.encode(data.toJson());

class AllBooking {
  String userId;
  List<Bookings> currentBookings;
  List<Bookings> prevBooking;
  List<Bookings> comingBookings;

  AllBooking({
    required this.userId,
    required this.currentBookings,
    required this.prevBooking,
    required this.comingBookings,
  });

  factory AllBooking.fromJson(Map<String, dynamic> json) => AllBooking(
    userId: json["userId"],
    currentBookings: List<Bookings>.from(json["current_bookings"].map((x) => Bookings.fromJson(x))),
    prevBooking: List<Bookings>.from(json["prev_booking"].map((x) => Bookings.fromJson(x))),
    comingBookings: List<Bookings>.from(json["coming_bookings"].map((x) => Bookings.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "current_bookings": List<dynamic>.from(currentBookings.map((x) => x.toJson())),
    "prev_booking": List<dynamic>.from(prevBooking.map((x) => x.toJson())),
    "coming_bookings": List<dynamic>.from(comingBookings.map((x) => x.toJson())),
  };
}

class Bookings {
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

  Bookings({
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
  });

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
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
  };
}

class ArtistServiceMap {
  TimeSlot timeSlot;
  String artistId;
  String serviceId;
  String id;

  ArtistServiceMap({
    required this.timeSlot,
    required this.artistId,
    required this.serviceId,
    required this.id,
  });

  factory ArtistServiceMap.fromJson(Map<String, dynamic> json) => ArtistServiceMap(
    timeSlot: TimeSlot.fromJson(json["timeSlot"]),
    artistId: json["artistId"],
    serviceId: json["serviceId"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "timeSlot": timeSlot.toJson(),
    "artistId": artistId,
    "serviceId": serviceId,
    "_id": id,
  };
}

class TimeSlot {
  String start;
  String end;

  TimeSlot({
    required this.start,
    required this.end,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}
