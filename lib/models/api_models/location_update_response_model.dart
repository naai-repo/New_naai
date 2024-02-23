import 'dart:convert';

class LocationUpdateResponseModel {
  final String? status;
  final String? message;
  final String? data;

  LocationUpdateResponseModel({
    this.status,
    this.message,
    this.data,
  });

  LocationUpdateResponseModel copyWith({
    String? status,
    String? message,
    String? data,
  }) {
    return LocationUpdateResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data,
    };
  }

  factory LocationUpdateResponseModel.fromMap(Map<String, dynamic> map) {
    return LocationUpdateResponseModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null ? map['data'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationUpdateResponseModel.fromJson(String source) => LocationUpdateResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocationUpdateResponseModel(status: $status, message: $message, data: $data)';

}
