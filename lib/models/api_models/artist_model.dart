import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';

class ArtistResponseModel {
  final String status;
  final String message;
  final List<ArtistDataModel> data;

  ArtistResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  ArtistResponseModel copyWith({
    String? status,
    String? message,
    List<ArtistDataModel>? data,
  }) {
    return ArtistResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory ArtistResponseModel.fromMap(Map<String, dynamic> map) {
    return ArtistResponseModel(
      status: map['status'] as String,
      message: map['message'] as String,
      data: List<ArtistDataModel>.from((map['data'] as List<dynamic>).map<ArtistDataModel>((x) => ArtistDataModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistResponseModel.fromJson(String source) => ArtistResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ArtistResponseModel(status: $status, message: $message, data: $data)';
}