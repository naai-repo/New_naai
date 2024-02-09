

class Review {
  String? salonName;
  String? artistName;
  String? artistId;
  String? comment;
  String? id;
  String? salonId;
  String? userId;
  DateTime? createdAt;
  String? imagePath;
  String? userName;
  num? rating;

  Review({
    this.artistId,
    this.comment,
    this.id,
    this.createdAt,
    this.salonId,
    this.userId,
    this.imagePath,
    this.userName,
    this.rating,
    this.salonName,
    this.artistName,
  });

  factory Review.fromDocumentSnapshot( docData) {
    Map<String, dynamic> json = docData.data() as Map<String, dynamic>;

    return Review(
      artistId: json['artistId'],
      comment: json['comment'],
      id: json['id'],
      createdAt: (json['createdAt']).toDate(),
      salonId: json['salonId'],
      userId: json['userId'],
      imagePath: json['imagePath'] ?? 'assets/images/salon_dummy_image.png',
      userName: json['userName'],
      rating: json['rating'],
      salonName: json['salonName'],
      artistName: json['artistName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'comment': comment,
      'id': id,
      'createdAt': createdAt ?? DateTime.now(),
      'salonId': salonId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'salonName': salonName,
      'artistName': artistName,
    };
  }
}
