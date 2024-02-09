
import 'package:naai/models/user.dart';

class SalonData {
  String? id;
  String? address;
  num? rating, originalRating;
  String? name;
  String? imagePath;
  List? imageList;
  String? salonType;
  Timing? timing;
  String? distanceFromUserAsString;
  double? distanceFromUser;
  String? instagramLink;
  String? googleMapsLink;
  String? closingDay;
  num? discountPercentage;

  SalonData({
    this.id,
    this.address,
    this.rating,
    this.originalRating,
    this.name,
    this.imagePath,
    this.imageList,
    this.salonType,
    this.timing,
    this.distanceFromUserAsString,
    this.distanceFromUser,
    this.instagramLink,
    this.googleMapsLink,
    this.closingDay,
    this.discountPercentage
  });

  factory SalonData.fromDocumentSnapshot( data) {
    Map<String, dynamic> docData = data.data() as Map<String, dynamic>;

    return SalonData(
        id: docData['id'],
      //  address: ['address'] ?? {},
        name: docData['name'],
        rating: docData['rating'],
        originalRating: docData['rating'],
        imagePath: docData['imagePath'] ??
            'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR1S0Z2cZz7c6seds8lDlfjhTJN-0DguBaHZ7TM2wmw2h9kw8xR',
        imageList: docData['imageList'] ??
            const [
              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR1S0Z2cZz7c6seds8lDlfjhTJN-0DguBaHZ7TM2wmw2h9kw8xR',
              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR1S0Z2cZz7c6seds8lDlfjhTJN-0DguBaHZ7TM2wmw2h9kw8xR',
              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR1S0Z2cZz7c6seds8lDlfjhTJN-0DguBaHZ7TM2wmw2h9kw8xR',
            ],
        salonType: docData['salonType'],
        timing: Timing.fromFirestore(docData['timing'] ?? {}),
        instagramLink: docData['instagramLink'],
        googleMapsLink: docData['googleMapsLink'],
        closingDay: docData['closingDay'],
        discountPercentage: docData['discountPercentage']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'name': name,
      'rating': rating,
      'salonType': salonType,
      'timing': timing!.toJson(),
      'imageList': imageList,
      'discountPercentage': discountPercentage
    };
  }
}

class Timing {
  int? opening;
  int? closing;

  Timing({
    this.closing,
    this.opening,
  });

  factory Timing.fromFirestore(Map<String, dynamic> data) {
    return Timing(
      opening: data['opening'],
      closing: data['closing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opening': opening,
      'closing': closing,
    };
  }
}

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
