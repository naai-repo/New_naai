// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookingDeleteResponseModel {
  final String? status;
  final String? message;
  final BookingDelItem? data;

  BookingDeleteResponseModel({
    this.status,
    this.message,
    this.data,
  });


  BookingDeleteResponseModel copyWith({
    String? status,
    String? message,
    BookingDelItem? data,
  }) {
    return BookingDeleteResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory BookingDeleteResponseModel.fromMap(Map<String, dynamic> map) {
    return BookingDeleteResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? BookingDelItem.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingDeleteResponseModel.fromJson(String source) => BookingDeleteResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookingDeleteResponseModel(status: $status, message: $message, data: $data)';

}


class BookingDelItem {
  final bool? acknowledged;
  final int? deletedCount;

  BookingDelItem({
    this.acknowledged,
    this.deletedCount,
  });

  BookingDelItem copyWith({
    bool? acknowledged,
    int? deletedCount,
  }) {
    return BookingDelItem(
      acknowledged: acknowledged ?? this.acknowledged,
      deletedCount: deletedCount ?? this.deletedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'acknowledged': acknowledged,
      'deletedCount': deletedCount,
    };
  }

  factory BookingDelItem.fromMap(Map<String, dynamic> map) {
    return BookingDelItem(
      acknowledged: map['acknowledged'] != null ? map['acknowledged'] as bool : null,
      deletedCount: map['deletedCount'] != null ? map['deletedCount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingDelItem.fromJson(String source) => BookingDelItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookingDelItem(acknowledged: $acknowledged, deletedCount: $deletedCount)';


}
