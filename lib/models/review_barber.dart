// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


ReviewBarber reviewBarberFromJson(String str) => ReviewBarber.fromJson(json.decode(str));

String reviewBarberToJson(ReviewBarber data) => json.encode(data.toJson());

class ReviewBarber {
  String status;
  String message;
  List<Datum> data;

  ReviewBarber({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReviewBarber.fromJson(Map<String, dynamic> json) => ReviewBarber(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from((json["data"] ?? []).map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Review review;
 // List<dynamic> replies;

  Datum({
    required this.review,
 //   required this.replies,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    review: Review.fromJson(json["review"]),
 //   replies: List<dynamic>.from(json["replies"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "review": review.toJson(),
  //  "replies": List<dynamic>.from(replies.map((x) => x)),
  };
}

class Review {
  String id;
  String title;
  String description;
  int rating;
  String userId;
  String salonId;
  String artistId;
 // List<dynamic> replies;
  String createdAt;
  String updatedAt;
  String userName;
  bool ? isExpanded;
  int v;

  Review({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.userId,
    required this.salonId,
    required this.artistId,
 //   required this.replies,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    this.isExpanded,
    required this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["_id"] ?? '',
    title: json["title"],
    description: json["description"] ?? '',
    rating: json["rating"] ?? '',
    userId: json["userId"] ?? '',
    salonId: json["salonId"] ?? '',
    artistId: json["artistId"] ?? '',
   // replies: List<dynamic>.from(json["replies"].map((x) => x)),
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
    userName: json["userName"] ?? '',
    isExpanded: json['isExpanded'] ?? false,
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "rating": rating,
    "userId": userId,
    "salonId": salonId,
    "artistId": artistId,
  //  "replies": List<dynamic>.from(replies.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "userName" : userName,
    'isExpanded': isExpanded,
    "__v": v,
  };
  void setArtistName(String name){
    this.userName = name;
  }
}



SalonReviewBarber SalonReviewBarberFromJson(String str) => SalonReviewBarber.fromJson(json.decode(str));

String SalonReviewBarberToJson(SalonReviewBarber data) => json.encode(data.toJson());

class SalonReviewBarber {
  String status;
  String message;
  List<SalonDatum> data;

  SalonReviewBarber({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SalonReviewBarber.fromJson(Map<String, dynamic> json) => SalonReviewBarber(
    status: json["status"],
    message: json["message"],
    data: List<SalonDatum>.from((json["data"] ?? []).map((x) => SalonDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SalonDatum {
  SalonReview salonreview;
 // List<dynamic> replies;

  SalonDatum({
    required this.salonreview,
//    required this.replies,
  });

  factory SalonDatum.fromJson(Map<String, dynamic> json) => SalonDatum(
    salonreview: SalonReview.fromJson(json["review"]),
  //  replies: List<dynamic>.from(json["replies"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "review": salonreview.toJson(),
  //  "replies": List<dynamic>.from(replies.map((x) => x)),
  };
}

class SalonReview {
  String id;
  String title;
  String description;
  int rating;
  String userId;
  String salonId;
  String artistId;
 // List<dynamic> replies;
  String createdAt;
  String updatedAt;
  String userName;
  bool ? isExpanded;
  String artistName;
  int v;

  SalonReview({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.userId,
    required this.salonId,
    required this.artistId,
    //required this.replies,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    this.isExpanded,
    required this.v,
    required this.artistName
  });

  factory SalonReview.fromJson(Map<String, dynamic> json) => SalonReview(
    id: json["_id"] ?? '',
    title: json["title"],
    description: json["description"] ?? '',
    rating: json["rating"] ?? '',
    userId: json["userId"] ?? '',
    salonId: json["salonId"] ?? '',
    artistId: json["artistId"] ?? '',
   // replies: List<dynamic>.from(json["replies"].map((x) => x)),
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
    userName: json["userName"] ?? '',
    isExpanded: json['isExpanded'] ?? false,
    artistName: json['artistName']?? '',
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "rating": rating,
    "userId": userId,
    "salonId": salonId,
    "artistId": artistId,
  //  "replies": List<dynamic>.from(replies.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "userName" : userName,
    'isExpanded': isExpanded,
    'artistName': artistName,
    "__v": v,
  };
  void setUserName(String name){
    this.userName = name;
  }
  void setArtistName(String name){
    this.artistName = name;
  }
}

