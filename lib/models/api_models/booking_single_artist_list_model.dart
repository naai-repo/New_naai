import 'dart:convert';
import 'package:naai/models/api_models/artist_item_model.dart';

class BookingSingleArtistListResponseModel {
  List<ArtistService>? artistsProvidingServices;
  List<String>? services;
  ArtistService? selectedArtist; // Add this property
  Map<String, ArtistService?>? selectedArtistMap;

  BookingSingleArtistListResponseModel({
    this.artistsProvidingServices,
    this.services,
    this.selectedArtist,
    this.selectedArtistMap,
  });
  

  BookingSingleArtistListResponseModel copyWith({
    List<ArtistService>? artistsProvidingServices,
    List<String>? services,
    ArtistService? selectedArtist,
    Map<String, ArtistService?>? selectedArtistMap,
  }) {
    return BookingSingleArtistListResponseModel(
      artistsProvidingServices: artistsProvidingServices ?? this.artistsProvidingServices,
      services: services ?? this.services,
      selectedArtist: selectedArtist ?? this.selectedArtist,
      selectedArtistMap: selectedArtistMap ?? this.selectedArtistMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistsProvidingServices': artistsProvidingServices?.map((x) => x.toMap()).toList() ?? [],
      'services': services,
      'selectedArtist': selectedArtist?.toMap(),
      'selectedArtistMap': selectedArtistMap,
    };
  }

  factory BookingSingleArtistListResponseModel.fromMap(Map<String, dynamic> map) {
    return BookingSingleArtistListResponseModel(
      artistsProvidingServices: map['artistsProvidingServices'] != null ? List<ArtistService>.from((map['artistsProvidingServices'] as List<dynamic>).map<ArtistService?>((x) => ArtistService.fromMap(x as Map<String,dynamic>))) : null,
      services: map['services'] != null ? List<String>.from((map['services'] as List<String>)) : null,
      selectedArtist: map['selectedArtist'] != null ? ArtistService.fromMap(map['selectedArtist'] as Map<String,dynamic>) : null,
      selectedArtistMap: map['selectedArtistMap'] != null ? Map<String, ArtistService?>.from((map['selectedArtistMap'] as Map<String, ArtistService?>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingSingleArtistListResponseModel.fromJson(String source) => BookingSingleArtistListResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookingSingleArtistListResponseModel(artistsProvidingServices: $artistsProvidingServices, services: $services, selectedArtist: $selectedArtist, selectedArtistMap: $selectedArtistMap)';
  }

}


class ArtistService {
  String? artistId;
  String? artist;
  List<Service>? serviceList;
  double? rating;

  ArtistService({
    this.artistId,
    this.artist,
    this.serviceList,
    this.rating,
  });



  ArtistService copyWith({
    String? artistId,
    String? artist,
    List<Service>? serviceList,
    double? rating,
  }) {
    return ArtistService(
      artistId: artistId ?? this.artistId,
      artist: artist ?? this.artist,
      serviceList: serviceList ?? this.serviceList,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'artistId': artistId,
      'artist': artist,
      'serviceList': serviceList?.map((x) => x.toMap()).toList() ?? [],
      'rating': rating,
    };
  }

  factory ArtistService.fromMap(Map<String, dynamic> map) {
    return ArtistService(
      artistId: map['artistId'] != null ? map['artistId'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      serviceList: map['serviceList'] != null ? List<Service>.from((map['serviceList'] as List<dynamic>).map<Service?>((x) => Service.fromMap(x as Map<String,dynamic>),),) : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistService.fromJson(String source) => ArtistService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistService(artistId: $artistId, artist: $artist, serviceList: $serviceList, rating: $rating)';
  }
}


