// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ScheduleResponseModel {
  String salonId;
  List<TimeSlotResponseTimeSlot>? timeSlots;
  Map<String,List<int>>? artistsTimeSlots;
  List<List<String>>? timeSlotsVisible;

  ScheduleResponseModel({
    required this.salonId,
    this.timeSlots,
    this.artistsTimeSlots,
    this.timeSlotsVisible,
  });



  ScheduleResponseModel copyWith({
    String? salonId,
    List<TimeSlotResponseTimeSlot>? timeSlots,
    Map<String,List<int>>? artistsTimeSlots,
    List<List<String>>? timeSlotsVisible,
  }) {
    return ScheduleResponseModel(
      salonId: salonId ?? this.salonId,
      timeSlots: timeSlots ?? this.timeSlots,
      artistsTimeSlots: artistsTimeSlots ?? this.artistsTimeSlots,
      timeSlotsVisible: timeSlotsVisible ?? this.timeSlotsVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salonId': salonId,
      'timeSlots': timeSlots?.map((x) => x.toMap()).toList() ?? [],
      'artistsTimeSlots': artistsTimeSlots,
      'timeSlotsVisible': timeSlotsVisible,
    };
  }

  factory ScheduleResponseModel.fromMap(Map<String, dynamic> map) {
    Map<String,List<int>> artistTimeSlotsRes = {};
    if(map['artistsTimeSlots'] != null){
        final ats = map['artistsTimeSlots'] as Map<String,dynamic>;
        ats.forEach((key, value) {
          List<int> slots = [];
          for(var e in (value as List<dynamic>)){
              slots.add(e);
          }
          artistTimeSlotsRes[key] = slots;
        });
    }
   
    List<List<String>> timeSlotVisible = [];
    if(map['timeSlotsVisible'] != null){
        final tsv = map['timeSlotsVisible'] as List<dynamic>;
        for(var e in tsv){
             List<String> temp = [];
             temp.add(e[0]);
             temp.add(e[1]);
             timeSlotVisible.add(temp);
        }
    }

    return ScheduleResponseModel(
      salonId: map['salonId'] as String,
      timeSlots: map['timeSlots'] != null ? List<TimeSlotResponseTimeSlot>.from((map['timeSlots'] as List<dynamic>).map<TimeSlotResponseTimeSlot?>((x) => TimeSlotResponseTimeSlot.fromMap(x as Map<String,dynamic>),),) : null,
      artistsTimeSlots: artistTimeSlotsRes,
      timeSlotsVisible: timeSlotVisible,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleResponseModel.fromJson(String source) => ScheduleResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScheduleResponseModel(salonId: $salonId, timeSlots: $timeSlots, artistsTimeSlots: $artistsTimeSlots, timeSlotsVisible: $timeSlotsVisible)';
  }

}


class TimeSlotResponseTimeSlot {
  int key;
  bool possible;
  List<TimeSlotTimeSlot> timeSlot;
  List<Order> order;

  TimeSlotResponseTimeSlot({
    required this.key,
    required this.possible,
    required this.timeSlot,
    required this.order,
  });


  TimeSlotResponseTimeSlot copyWith({
    int? key,
    bool? possible,
    List<TimeSlotTimeSlot>? timeSlot,
    List<Order>? order,
  }) {
    return TimeSlotResponseTimeSlot(
      key: key ?? this.key,
      possible: possible ?? this.possible,
      timeSlot: timeSlot ?? this.timeSlot,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'possible': possible,
      'timeSlot': timeSlot.map((x) => x.toMap()).toList(),
      'order': order.map((x) => x.toMap()).toList(),
    };
  }

  factory TimeSlotResponseTimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlotResponseTimeSlot(
      key: map['key'] as int,
      possible: map['possible'] as bool,
      timeSlot: List<TimeSlotTimeSlot>.from((map['timeSlot'] as List<dynamic>).map<TimeSlotTimeSlot>((x) => TimeSlotTimeSlot.fromMap(x as Map<String,dynamic>),),),
      order: List<Order>.from((map['order'] as List<dynamic>).map<Order>((x) => Order.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlotResponseTimeSlot.fromJson(String source) => TimeSlotResponseTimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TimeSlotResponseTimeSlot(key: $key, possible: $possible, timeSlot: $timeSlot, order: $order)';
  }
}

class Order {
  TimeService? service;
  String? artist;
  int? time;
  VariableSchedule? variable;

  Order({
    this.service,
    this.artist,
    this.time,
    this.variable
  });


  Order copyWith({
    TimeService? service,
    String? artist,
    int? time,
    VariableSchedule? variable,
  }) {
    return Order(
      service: service ?? this.service,
      artist: artist ?? this.artist,
      time: time ?? this.time,
      variable: variable ?? this.variable,
    );
  }

  Map<String, dynamic> toMap() {
    if(variable == null){
      return <String, dynamic>{
        'service': service?.toMap(),
        'artist': artist,
        'time': time,
      };
    }
    return <String, dynamic>{
      'service': service?.toMap(),
      'artist': artist,
      'time': time,
      'variable': variable?.toMap(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      service: map['service'] != null ? TimeService.fromMap(map['service'] as Map<String,dynamic>) : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      time: map['time'] != null ? map['time'] as int : null,
      variable: map['variable'] != null ? VariableSchedule.fromMap(map['variable'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(service: $service, artist: $artist, time: $time, variable: $variable)';
  }

}

class TimeService {

  final String? id;
  final String? salonId;
  final String? category;
  final String? serviceTitle;
  final String? description;
  final String? targetGender;
  final int? avgTime;
  final List<VariableSchedule>? variables;
  final double? basePrice;
  final double? cutPrice;
  final String? createdAt;
  final String? updatedAt;

  TimeService({
    this.id,
    this.salonId,
    this.category,
    this.serviceTitle,
    this.description,
    this.targetGender,
    this.avgTime,
    this.variables,
    this.basePrice,
    this.cutPrice,
    this.createdAt,
    this.updatedAt,
  });


  TimeService copyWith({
    String? id,
    String? salonId,
    String? category,
    String? serviceTitle,
    String? description,
    String? targetGender,
    int? avgTime,
    List<VariableSchedule>? variables,
    double? basePrice,
    double? cutPrice,
    String? createdAt,
    String? updatedAt,
  }) {
    return TimeService(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      category: category ?? this.category,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      description: description ?? this.description,
      targetGender: targetGender ?? this.targetGender,
      avgTime: avgTime ?? this.avgTime,
      variables: variables ?? this.variables,
      basePrice: basePrice ?? this.basePrice,
      cutPrice: cutPrice ?? this.cutPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'salonId': salonId,
      'category': category,
      'serviceTitle': serviceTitle,
      'description': description,
      'targetGender': targetGender,
      'avgTime': avgTime,
      'variables': variables?.map((x) => x.toMap()).toList() ?? [],
      'basePrice': basePrice,
      'cutPrice': cutPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TimeService.fromMap(Map<String, dynamic> map) {
    return TimeService(
      id: map['id'] != null ? map['id'] as String : null,
      salonId: map['salonId'] != null ? map['salonId'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      serviceTitle: map['serviceTitle'] != null ? map['serviceTitle'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      targetGender: map['targetGender'] != null ? map['targetGender'] as String : null,
      avgTime: map['avgTime'] != null ? map['avgTime'] as int : null,
      variables: map['variables'] != null ? List<VariableSchedule>.from((map['variables'] as List<dynamic>).map<VariableSchedule?>((x) => VariableSchedule.fromMap(x as Map<String,dynamic>),),) : null,
      basePrice: map['basePrice'] != null ? double.tryParse(map['basePrice'].toString()) : null,
      cutPrice: map['cutPrice'] != null ? double.tryParse(map['cutPrice'].toString()) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeService.fromJson(String source) => TimeService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TimeService(id: $id, salonId: $salonId, category: $category, serviceTitle: $serviceTitle, description: $description, targetGender: $targetGender, avgTime: $avgTime, variables: $variables, basePrice: $basePrice, cutPrice: $cutPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

}

class TimeSlotTimeSlot {
  List<String>? slot;
  int? key;
   
  TimeSlotTimeSlot({
    this.slot,
    this.key,
  });

  TimeSlotTimeSlot copyWith({
    List<String>? slot,
    int? key,
  }) {
    return TimeSlotTimeSlot(
      slot: slot ?? this.slot,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'slot': slot,
      'key': key,
    };
  }

  factory TimeSlotTimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlotTimeSlot(
      slot: map['slot'] != null ? List<String>.from((map['slot'] as List<dynamic>)) : null,
      key: map['key'] != null ? map['key'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlotTimeSlot.fromJson(String source) => TimeSlotTimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimeSlotTimeSlot(slot: $slot, key: $key)';
}

class VariableSchedule {
  final String? variableType;
  final String? variableName;
  final double? variablePrice;
  final double? variableCutPrice;
  final double? variableTime;
  final String? id;
  
  VariableSchedule({
    this.variableType,
    this.variableName,
    this.variablePrice,
    this.variableCutPrice,
    this.variableTime,
    this.id,
  });



  VariableSchedule copyWith({
    String? variableType,
    String? variableName,
    double? variablePrice,
    double? variableCutPrice,
    double? variableTime,
    String? id,
  }) {
    return VariableSchedule(
      variableType: variableType ?? this.variableType,
      variableName: variableName ?? this.variableName,
      variablePrice: variablePrice ?? this.variablePrice,
      variableCutPrice: variableCutPrice ?? this.variableCutPrice,
      variableTime: variableTime ?? this.variableTime,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'variableType': variableType,
      'variableName': variableName,
      'variablePrice': variablePrice,
      'variableCutPrice': variableCutPrice,
      'variableTime': variableTime,
      '_id': id,
    };
  }

  factory VariableSchedule.fromMap(Map<String, dynamic> map) {
    return VariableSchedule(
      variableType: map['variableType'] != null ? map['variableType'] as String : null,
      variableName: map['variableName'] != null ? map['variableName'] as String : null,
      variablePrice: map['variablePrice'] != null ? double.tryParse(map['variablePrice'].toString()): null,
      variableCutPrice: map['variableCutPrice'] != null ? double.tryParse(map['variableCutPrice'].toString())  : null,
      variableTime: map['variableTime'] != null ? double.tryParse(map['variableTime'].toString()): null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VariableSchedule.fromJson(String source) => VariableSchedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VariableSchedule(variableType: $variableType, variableName: $variableName, variablePrice: $variablePrice, variableCutPrice: $variableCutPrice, variableTime: $variableTime, id: $id)';
  }


}
