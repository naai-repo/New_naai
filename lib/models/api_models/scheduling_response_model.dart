import 'dart:convert';

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
    return ScheduleResponseModel(
      salonId: map['salonId'] as String,
      timeSlots: map['timeSlots'] != null ? List<TimeSlotResponseTimeSlot>.from((map['timeSlots'] as List<dynamic>).map<TimeSlotResponseTimeSlot?>((x) => TimeSlotResponseTimeSlot.fromMap(x as Map<String,dynamic>),),) : null,
      artistsTimeSlots: map['artistsTimeSlots'] != null ? Map<String,List<int>>.from((map['artistsTimeSlots'] as Map<String,List<int>>)) : null,
      timeSlotsVisible: map['timeSlotsVisible'] != null ? List<List<String>>.from((map['timeSlotsVisible'] as List<dynamic>).map<List<String>?>((x) => x,),) : null,
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
      timeSlot: List<TimeSlotTimeSlot>.from((map['timeSlot'] as List<int>).map<TimeSlotTimeSlot>((x) => TimeSlotTimeSlot.fromMap(x as Map<String,dynamic>),),),
      order: List<Order>.from((map['order'] as List<int>).map<Order>((x) => Order.fromMap(x as Map<String,dynamic>),),),
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

  Order({
    this.service,
    this.artist,
  });


  Order copyWith({
    TimeService? service,
    String? artist,
  }) {
    return Order(
      service: service ?? this.service,
      artist: artist ?? this.artist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': service?.toMap(),
      'artist': artist,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      service: map['service'] != null ? TimeService.fromMap(map['service'] as Map<String,dynamic>) : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Order(service: $service, artist: $artist)';
}

class TimeService {
  String? id;
  String? category;
  String? serviceTitle;
  String? description;
  String? targetGender;
  List<String>? salonIds;
  int? avgTime;
  int? basePrice;
  DateTime? createdAt;
  DateTime? updatedAt;

  TimeService({
    this.id,
    this.category,
    this.serviceTitle,
    this.description,
    this.targetGender,
    this.salonIds,
    this.avgTime,
    this.basePrice,
    this.createdAt,
    this.updatedAt,
  });

  TimeService copyWith({
    String? id,
    String? category,
    String? serviceTitle,
    String? description,
    String? targetGender,
    List<String>? salonIds,
    int? avgTime,
    int? basePrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeService(
      id: id ?? this.id,
      category: category ?? this.category,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      description: description ?? this.description,
      targetGender: targetGender ?? this.targetGender,
      salonIds: salonIds ?? this.salonIds,
      avgTime: avgTime ?? this.avgTime,
      basePrice: basePrice ?? this.basePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'serviceTitle': serviceTitle,
      'description': description,
      'targetGender': targetGender,
      'salonIds': salonIds,
      'avgTime': avgTime,
      'basePrice': basePrice,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory TimeService.fromMap(Map<String, dynamic> map) {
    return TimeService(
      id: map['id'] != null ? map['id'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      serviceTitle: map['serviceTitle'] != null ? map['serviceTitle'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      targetGender: map['targetGender'] != null ? map['targetGender'] as String : null,
      salonIds: map['salonIds'] != null ? List<String>.from((map['salonIds'] as List<String>)) : null,
      avgTime: map['avgTime'] != null ? map['avgTime'] as int : null,
      basePrice: map['basePrice'] != null ? map['basePrice'] as int : null,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeService.fromJson(String source) => TimeService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TimeService(id: $id, category: $category, serviceTitle: $serviceTitle, description: $description, targetGender: $targetGender, salonIds: $salonIds, avgTime: $avgTime, basePrice: $basePrice, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      slot: map['slot'] != null ? List<String>.from((map['slot'] as List<String>)) : null,
      key: map['key'] != null ? map['key'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlotTimeSlot.fromJson(String source) => TimeSlotTimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimeSlotTimeSlot(slot: $slot, key: $key)';
}

