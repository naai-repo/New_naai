import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';

class TopArtistResponseModel {
  final ArtistDataModel? artistDetails;
  final SingleSalonResponseModel? salonDetails;
  
  TopArtistResponseModel({
    this.artistDetails,
    this.salonDetails,
  });
 
 

  TopArtistResponseModel copyWith({
    ArtistDataModel? artistDetails,
    SingleSalonResponseModel? salonDetails,
  }) {
    return TopArtistResponseModel(
      artistDetails: artistDetails ?? this.artistDetails,
      salonDetails: salonDetails ?? this.salonDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistDetails': artistDetails?.toMap(),
      'salonDetails': salonDetails?.toMap(),
    };
  }

  factory TopArtistResponseModel.fromMap(Map<String, dynamic> map) {
    return TopArtistResponseModel(
      artistDetails: map['artistDetails'] != null ? ArtistDataModel.fromMap(map['artistDetails'] as Map<String,dynamic>) : null,
      salonDetails: map['salonDetails'] != null ? SingleSalonResponseModel.fromMap(map['salonDetails'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopArtistResponseModel.fromJson(String source) => TopArtistResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TopArtistResponseModel(artistDetails: $artistDetails, salonDetails: $salonDetails)';
}
