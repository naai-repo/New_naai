// To parse this JSON data, do
//
//     final timeSlotResponse = timeSlotResponseFromJson(jsonString);

import 'dart:convert';

import 'package:naai/models/salon_detail.dart';

TimeSlotResponse timeSlotResponseFromJson(String str) => TimeSlotResponse.fromJson(json.decode(str));

String timeSlotResponseToJson(TimeSlotResponse data) => json.encode(data.toJson());

class TimeSlotResponse {
  String salonId;
  List<TimeSlotResponseTimeSlot> timeSlots;
  List<List<String>> timeSlotsVisible;

  TimeSlotResponse({
    required this.salonId,
    required this.timeSlots,
    required this.timeSlotsVisible,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) => TimeSlotResponse(
    salonId: json["salonId"],
    timeSlots: List<TimeSlotResponseTimeSlot>.from(json["timeSlots"].map((x) => TimeSlotResponseTimeSlot.fromJson(x))),
  //  artistsTimeSlots: ArtistsTimeSlots.fromJson(json["artistsTimeSlots"]),
    timeSlotsVisible: List<List<String>>.from(json["timeSlotsVisible"].map((x) => List<String>.from(x))),
  );

  Map<String, dynamic> toJson() => {
    "salonId": salonId,
    "timeSlots": List<dynamic>.from(timeSlots.map((x) => x.toJson())),
  //  "artistsTimeSlots": artistsTimeSlots.toJson(),
    "timeSlotsVisible": List<dynamic>.from(timeSlotsVisible.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };

  @override
  String toString() {
    return 'TimeSlotResponse(salonId: $salonId, timeSlots: $timeSlots, timeSlotsVisible: $timeSlotsVisible)';
  }
}


class TimeSlotResponseTimeSlot {
  int key;
  bool possible;
  List<TimeSlotTimeSlot> timeSlot;
  List<Order>? order;

  TimeSlotResponseTimeSlot({
    required this.key,
    required this.possible,
    required this.timeSlot,
          this.order,
  });

  factory TimeSlotResponseTimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponseTimeSlot(
      key: json["key"],
      possible: json["possible"],
      timeSlot: List<TimeSlotTimeSlot>.from(
        json["timeSlot"].map(
              (x) => TimeSlotTimeSlot.fromJson(x),
        ),
      ),
      order: json["order"] != null
          ? List<Order>.from(
        json["order"].map(
              (x) => Order.fromJson(x),
        ),
      )
          : null, // Check for null before mapping
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "possible": possible,
    "timeSlot": List<dynamic>.from(timeSlot.map((x) => x.toJson())),
    "order": order != null ? List<dynamic>.from(order!.map((x) => x.toJson())) : null,
  };
}

class Order {
  TimeService service;
  FluffyVariable? variable;
  String artist;
  int? time;

  Order({
    required this.service,
    required this.artist,
    this.variable,
    this.time,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<FluffyVariable>? variables;
    if (json['service']['variables'] != null && json['service']['variables'].isNotEmpty) {
      variables = List<FluffyVariable>.from(json['service']['variables'].map((x) => FluffyVariable.fromJson(x)));
    }

    return Order(
      service: TimeService.fromJson(json["service"]),
      variable: variables != null ? variables[0] : null,
      artist: json["artist"],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "service": service.toJson(),
      "artist": artist,
      "time": time,
    };

    if (variable != null) {
      json["variable"] = variable!.toJson();
    }

    return json;
  }
}



class TimeService {
  String id;
  String category;
  String serviceTitle;
  String description;
  String targetGender;
  String salonId;
  int avgTime;
  int basePrice;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  TimeService({
    required this.id,
    required this.category,
    required this.serviceTitle,
    required this.description,
    required this.targetGender,
    required this.salonId,
    required this.avgTime,
    required this.basePrice,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TimeService.fromJson(Map<String, dynamic> json) => TimeService(
    id: json["_id"],
    category: json["category"],
    serviceTitle: json["serviceTitle"],
    description: json["description"],
    targetGender: json["targetGender"],
    salonId: json["salonId"],
    avgTime: json["avgTime"],
    basePrice: json["basePrice"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "category": category,
    "serviceTitle": serviceTitle,
    "description": description,
    "targetGender": targetGender,
    "salonId": salonId,
    "avgTime": avgTime,
    "basePrice": basePrice,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class TimeSlotTimeSlot {
  List<String> slot;
  int key;

  TimeSlotTimeSlot({
    required this.slot,
    required this.key,
  });

  factory TimeSlotTimeSlot.fromJson(Map<String, dynamic> json) => TimeSlotTimeSlot(
    slot: List<String>.from(json["slot"].map((x) => x)),
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "slot": List<dynamic>.from(slot.map((x) => x)),
    "key": key,
  };
}
