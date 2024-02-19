import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';

class SingleArtistModel {
  final String? status;
  final String? message;
  final ArtistDataModel? data;

  SingleArtistModel({
    this.status,
    this.message,
    this.data,
  });
  

  SingleArtistModel copyWith({
    String? status,
    String? message,
    ArtistDataModel? data,
  }) {
    return SingleArtistModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data?.toMap() ?? {},
    };
  }

  factory SingleArtistModel.fromMap(Map<String, dynamic> map) {
    return SingleArtistModel(
      status: map['status'] != null ? map['status'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: ArtistDataModel.fromMap(map['data'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleArtistModel.fromJson(String source) => SingleArtistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SingleArtistModel(status: $status, message: $message, data: $data)';
}
