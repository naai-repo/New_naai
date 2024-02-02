// To parse this JSON data, do
//
//     final artistRequest = artistRequestFromJson(jsonString);

import 'dart:convert';

ArtistRequest artistRequestFromJson(String str) => ArtistRequest.fromJson(json.decode(str));

String artistRequestToJson(ArtistRequest data) => json.encode(data.toJson());

class ArtistRequest {
  List<Request> requests;

  ArtistRequest({
    required this.requests,
  });

  factory ArtistRequest.fromJson(Map<String, dynamic> json) => ArtistRequest(
    requests: List<Request>.from(json["requests"].map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class Request {
  String service;
  String artist;

  Request({
    required this.service,
    required this.artist,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    service: json["service"],
    artist: json["artist"],
  );

  Map<String, dynamic> toJson() => {
    "service": service,
    "artist": artist,
  };
}
