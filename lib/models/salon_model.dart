class SalonApiResponse {
  final String status;
  final String message;
  final List<SalonData2> data;

  SalonApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SalonApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawDataList = json['data'] ?? [];
    final List<SalonData2> salonList =
    rawDataList.map((data) => SalonData2.fromJson(data)).toList();

    return SalonApiResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: salonList,
    );
  }
}
class SalonData2 {
  final String id;
  final String address;
  final String name;
  final String salonType;
  final Timing timing;
  final double rating;
  final String closedOn;
  final int phoneNumber;
  final Location location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool live;
  final bool paid;
  final int bookings;
  final int discount;
  final String owner;
  final String gst;
  final String pan;
  final Map<String, String> links;
  final List<ImageData> images;
  final double distance;
  final double score;

  SalonData2({
    required this.id,
    required this.address,
    required this.name,
    required this.salonType,
    required this.location,
    required this.timing,
    required this.rating,
    required this.closedOn,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.live,
    required this.paid,
    required this.bookings,
    required this.discount,
    required this.owner,
    required this.gst,
    required this.pan,
    required this.links,
    required this.images,
    required this.distance,
    required this.score,
  });

  factory SalonData2.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawImages = json['images'] ?? [];
    final List<ImageData> salonImages =
    rawImages.map((image) => ImageData.fromJson(image)).toList();

    return SalonData2(
      id: json['_id'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      salonType: json['salonType'] ?? '',
      timing: Timing.fromJson(json['timing'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      rating: (json['rating'] as num).toDouble(),
      closedOn: json['closedOn'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      live: json['live'] ?? false,
      paid: json['paid'] ?? false,
      bookings: json['bookings'] ?? 0,
      discount: json['discount'] ?? 0,
      owner: json['owner'] ?? '',
      gst: json['gst'] ?? '',
      pan: json['pan'] ?? '',
      links: Map<String, String>.from(json['links'] ?? {}),
      images: salonImages,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
class ImageData {
  final String key;
  final String url;
  final String id;

  ImageData({
    required this.key,
    required this.url,
    required this.id,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      key: json['key'] ?? '',
      url: json['url'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  static List<ImageData> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      // If the input is null, return an empty list
      return [];
    }

    return jsonList.map((json) => ImageData.fromJson(json)).toList();
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


class Timing {
  final String opening;
  final String closing;

  Timing({
    required this.opening,
    required this.closing,
  });

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      opening: json['opening'] ?? '',
      closing: json['closing'] ?? '',
    );
  }
}