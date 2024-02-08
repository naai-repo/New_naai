class ArtistApiResponse {
  final String status;
  final String message;
  final List<ArtistData> data;

  ArtistApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArtistApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawDataList = json['data'] ?? [];
    final List<ArtistData> artistList =
    rawDataList.map((data) => ArtistData.fromJson(data)).toList();

    return ArtistApiResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: artistList,
    );
  }
}

class ArtistData {
  final String id;
  final String name;
  final double rating;
  final String salonId;
  final List<Service> services;
  final Location location;
  final int phoneNumber;
  final bool availability;
  final bool live;
  final String createdAt;
  final String updatedAt;
  final int bookings;
  final double distance;
  final double score;
  final String imageKey;
  final String imageUrl;
  String  salonName ;

  ArtistData({
    required this.id,
    required this.name,
    required this.rating,
    required this.salonId,
    required this.services,
    required this.location,
    required this.phoneNumber,
    required this.availability,
    required this.live,
    required this.createdAt,
    required this.updatedAt,
    required this.bookings,
    required this.distance,
    required this.score,
    required this.imageKey,
    required this.imageUrl,
    required this.salonName
  });

  factory ArtistData.fromJson(Map<String, dynamic> json) {
    return ArtistData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] as num?)?.toDouble()?? 0.0,
      salonName: json['salonName'] ?? '',
      salonId: json['salonId'] ?? '',
      services: (json['services'] as List<dynamic>)
          .map((service) => Service.fromJson(service))
          .toList(),
      location: Location.fromJson(json['location'] ?? {}),
      phoneNumber: (json['phoneNumber'] as num?)?.toInt() ?? 0, // Parse as int
      availability: json['availability'] ?? false,
      live: json['live'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bookings: (json['bookings'] as num?)?.toInt() ?? 0, // Parse as int if needed
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      imageKey: json["imageKey"]?? '',
      imageUrl: json["imageUrl"]?? '',
    );
  }
  @override
  String toString() {
    return 'ArtistData{id: $id, name: $name, rating: $rating, salonId: $salonId, services: $services, location: $location, phoneNumber: $phoneNumber, availability: $availability, live: $live, createdAt: $createdAt, updatedAt: $updatedAt, bookings: $bookings, distance: $distance, score: $score, imageKey: $imageKey, imageUrl: $imageUrl , salonName: $salonName}';
  }
  void setSalonName(String name){
    this.salonName = name;
  }
}

class Service {
  final String serviceId;
  final int price;
  final String id;

  Service({
    required this.serviceId,
    required this.price,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'] ?? '',
      price: json['price'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }
}
/*
for(var username in reviewItem.data) {
          var userId = username.userId;
          print('userId:- $userId');
          var userResponse = await Dio().get(
              'http://13.235.49.214:8800/customer/user/$userId');
          if (userResponse.data != null && userResponse.data is Map<String, dynamic>) {
            dynamic userprofile = ProfileResponse.fromJson(userResponse.data);
            username.setUserName(userprofile);
            print('Username is :- ${userprofile}');
          }
        }
 */