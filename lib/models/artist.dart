
// Not in used
class Artist {
  String? id;
  String? name;
  double? rating, originalRating;
  String? imagePath;
  String? salonId;
  String? salonName;
  Availability? availability;
  double? distanceFromUser;
  String? instagramLink;

  Artist({
    this.id,
    this.name,
    this.rating,
    this.originalRating,
    this.imagePath,
    this.salonId,
    this.salonName,
    this.availability,
    this.instagramLink,
  });

  factory Artist.fromDocumentSnapsh( docData) {
    Map<String, dynamic> json = docData.data() as Map<String, dynamic>;
    return Artist(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      originalRating: json['rating'],
      imagePath: json['imagePath'] ??
          'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR1S0Z2cZz7c6seds8lDlfjhTJN-0DguBaHZ7TM2wmw2h9kw8xR',
      salonId: json['salonId'],
      salonName: json['salonName'],
      availability: Availability.fromFirestore(json['availability'] ?? {}),
      instagramLink: json['instagramLink'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    data['salonName'] = this.salonName;
    data['salonId'] = this.salonId;

    if (this.availability != null) {
      data['availability'] = this.availability!.toJson();
    }

    return data;
  }
}

class Availability {
  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;
  Day? sunday;

  Availability({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  Map<String, dynamic> toJson() {
    return {
      'monday': this.monday!.toJson(),
      'tuesday': this.tuesday!.toJson(),
      'wednesday': this.wednesday!.toJson(),
      'thursday': this.thursday!.toJson(),
      'friday': this.friday!.toJson(),
      'saturday': this.saturday!.toJson(),
      'sunday': this.sunday!.toJson(),
    };
  }

  factory Availability.fromFirestore(Map<String, dynamic> data) {
    return Availability(
      monday: Day.fromFirestore(data['monday'] ?? {}),
      tuesday: Day.fromFirestore(data['tuesday'] ?? {}),
      wednesday: Day.fromFirestore(data['wednesday'] ?? {}),
      thursday: Day.fromFirestore(data['thursday'] ?? {}),
      friday: Day.fromFirestore(data['friday'] ?? {}),
      saturday: Day.fromFirestore(data['saturday'] ?? {}),
      sunday: Day.fromFirestore(data['sunday'] ?? {}),
    );
  }
}

class Day {
  int? start;
  int? end;

  Day({
    this.start,
    this.end,
  });

  factory Day.fromFirestore(Map<String, dynamic> data) {
    return Day(
      start: data['start'],
      end: data['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': this.start,
      'end': this.end,
    };
  }
}
