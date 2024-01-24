class ArtistService {
  String artistId;
  String artist;
  List<Service>serviceList;
  double rating;

  ArtistService({
    required this.artistId,
    required this.artist,
    required this.serviceList,
    required this.rating,
  });

  factory ArtistService.fromJson(Map<String, dynamic> json) {
    return ArtistService(
      artistId: json['artistId'],
      artist: json['artist'],
      rating: json["rating"]?.toDouble(),
      serviceList: (json['serviceList'] as List<dynamic>)
          .map((service) => Service.fromJson(service))
          .toList(),

    );
  }
  Iterator<Service> get iterator => serviceList.iterator;

}

class Service {
  String serviceId;
  int price;
  String id;

  Service({
    required this.serviceId,
    required this.price,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

class ArtistServiceList {
  List<ArtistService> artistsProvidingServices;
  List<String> services;
  ArtistService? selectedArtist; // Add this property


  ArtistServiceList({
    required this.artistsProvidingServices,
    required this.services,
  });

  factory ArtistServiceList.fromJson(Map<String, dynamic> json) {
    return ArtistServiceList(
      artistsProvidingServices: (json['artistsProvidingServices'] as List<dynamic>)
          .map((artist) => ArtistService.fromJson(artist))
          .toList(),
      services: (json['services'] as List<dynamic>).map((service) => service.toString()).toList(),
    );
  }


}
