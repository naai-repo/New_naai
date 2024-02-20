// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookingAppointmentResponseModel {
  final String? userId;
  final String? bookingType;
  final String? salonId;
  final int? amount;
  final int? paymentAmount;
  final String? paymentId;
  final String? paymentStatus;
  final TimeSlot? timeSlot;
  final String? bookingDate;
  final List<ArtistServiceMap>? artistServiceMap;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  
  BookingAppointmentResponseModel({
    this.userId,
    this.bookingType,
    this.salonId,
    this.amount,
    this.paymentAmount,
    this.paymentId,
    this.paymentStatus,
    this.timeSlot,
    this.bookingDate,
    this.artistServiceMap,
    this.id,
    this.createdAt,
    this.updatedAt,
  });


  BookingAppointmentResponseModel copyWith({
    String? userId,
    String? bookingType,
    String? salonId,
    int? amount,
    int? paymentAmount,
    String? paymentId,
    String? paymentStatus,
    TimeSlot? timeSlot,
    String? bookingDate,
    List<ArtistServiceMap>? artistServiceMap,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return BookingAppointmentResponseModel(
      userId: userId ?? this.userId,
      bookingType: bookingType ?? this.bookingType,
      salonId: salonId ?? this.salonId,
      amount: amount ?? this.amount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      timeSlot: timeSlot ?? this.timeSlot,
      bookingDate: bookingDate ?? this.bookingDate,
      artistServiceMap: artistServiceMap ?? this.artistServiceMap,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'bookingType': bookingType,
      'salonId': salonId,
      'amount': amount,
      'paymentAmount': paymentAmount,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'timeSlot': timeSlot?.toMap(),
      'bookingDate': bookingDate,
      'artistServiceMap': artistServiceMap?.map((x) => x.toMap()).toList() ?? [],
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BookingAppointmentResponseModel.fromMap(Map<String, dynamic> map) {
    return BookingAppointmentResponseModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      bookingType: map['bookingType'] != null ? map['bookingType'] as String : null,
      salonId: map['salonId'] != null ? map['salonId'] as String : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
      paymentAmount: map['paymentAmount'] != null ? map['paymentAmount'] as int : null,
      paymentId: map['paymentId'] != null ? map['paymentId'] as String : null,
      paymentStatus: map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      timeSlot: map['timeSlot'] != null ? TimeSlot.fromMap(map['timeSlot'] as Map<String,dynamic>) : null,
      bookingDate: map['bookingDate'] != null ? map['bookingDate'] as String : null,
      artistServiceMap: map['artistServiceMap'] != null ? List<ArtistServiceMap>.from((map['artistServiceMap'] as List<int>).map<ArtistServiceMap?>((x) => ArtistServiceMap.fromMap(x as Map<String,dynamic>),),) : null,
      id: map['id'] != null ? map['id'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingAppointmentResponseModel.fromJson(String source) => BookingAppointmentResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookingAppointmentResponseModel(userId: $userId, bookingType: $bookingType, salonId: $salonId, amount: $amount, paymentAmount: $paymentAmount, paymentId: $paymentId, paymentStatus: $paymentStatus, timeSlot: $timeSlot, bookingDate: $bookingDate, artistServiceMap: $artistServiceMap, id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class ArtistServiceMap {
  final String? artistId;
  final String? serviceId;
  final int? servicePrice;
  final Variable? variable;
  final TimeSlot? timeSlot;
  final String? chosenBy;
  final String? id;
 
  ArtistServiceMap({
    this.artistId,
    this.serviceId,
    this.servicePrice,
    this.variable,
    this.timeSlot,
    this.chosenBy,
    this.id,
  });


  ArtistServiceMap copyWith({
    String? artistId,
    String? serviceId,
    int? servicePrice,
    Variable? variable,
    TimeSlot? timeSlot,
    String? chosenBy,
    String? id,
  }) {
    return ArtistServiceMap(
      artistId: artistId ?? this.artistId,
      serviceId: serviceId ?? this.serviceId,
      servicePrice: servicePrice ?? this.servicePrice,
      variable: variable ?? this.variable,
      timeSlot: timeSlot ?? this.timeSlot,
      chosenBy: chosenBy ?? this.chosenBy,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistId': artistId,
      'serviceId': serviceId,
      'servicePrice': servicePrice,
      'variable': variable?.toMap(),
      'timeSlot': timeSlot?.toMap(),
      'chosenBy': chosenBy,
      'id': id,
    };
  }

  factory ArtistServiceMap.fromMap(Map<String, dynamic> map) {
    return ArtistServiceMap(
      artistId: map['artistId'] != null ? map['artistId'] as String : null,
      serviceId: map['serviceId'] != null ? map['serviceId'] as String : null,
      servicePrice: map['servicePrice'] != null ? map['servicePrice'] as int : null,
      variable: map['variable'] != null ? Variable.fromMap(map['variable'] as Map<String,dynamic>) : null,
      timeSlot: map['timeSlot'] != null ? TimeSlot.fromMap(map['timeSlot'] as Map<String,dynamic>) : null,
      chosenBy: map['chosenBy'] != null ? map['chosenBy'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistServiceMap.fromJson(String source) => ArtistServiceMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistServiceMap(artistId: $artistId, serviceId: $serviceId, servicePrice: $servicePrice, variable: $variable, timeSlot: $timeSlot, chosenBy: $chosenBy, id: $id)';
  }
}

class Variable {
  final String? variableId;
  final String? variableType;
  final String? variableName;
  
  Variable({
    this.variableId,
    this.variableType,
    this.variableName,
  });

  Variable copyWith({
    String? variableId,
    String? variableType,
    String? variableName,
  }) {
    return Variable(
      variableId: variableId ?? this.variableId,
      variableType: variableType ?? this.variableType,
      variableName: variableName ?? this.variableName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'variableId': variableId,
      'variableType': variableType,
      'variableName': variableName,
    };
  }

  factory Variable.fromMap(Map<String, dynamic> map) {
    return Variable(
      variableId: map['variableId'] != null ? map['variableId'] as String : null,
      variableType: map['variableType'] != null ? map['variableType'] as String : null,
      variableName: map['variableName'] != null ? map['variableName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Variable.fromJson(String source) => Variable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Variable(variableId: $variableId, variableType: $variableType, variableName: $variableName)';

}

class TimeSlot {
   final String? start;
   final String? end;

  TimeSlot({
    this.start,
    this.end,
  });

  TimeSlot copyWith({
    String? start,
    String? end,
  }) {
    return TimeSlot(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'end': end,
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      start: map['start'] != null ? map['start'] as String : null,
      end: map['end'] != null ? map['end'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlot.fromJson(String source) => TimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimeSlot(start: $start, end: $end)';
}


