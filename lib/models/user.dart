
import 'dart:math';

class UserModel {
  String? name;
  String? phoneNumber;

  String? gmailId;
  String? appleId;
  String? gender;
  String? image;
  List<String>? preferredSalon;
  List<String>? preferredArtist;
  String? id;
  DateTime? loginTime;



  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
    this.preferredArtist,
    this.gender,
    this.id,
    this.image,
    this.loginTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'gmailId': gmailId,
      'appleId': appleId,
      'preferredSalon': preferredSalon,
      'preferredArtist': preferredArtist,
      'id': id,
      'gender': gender,
      'image':image,
      'loginTime': loginTime,
    };
  }

  UserModel.fromSnapshot( snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  UserModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    phoneNumber = map['phoneNumber'];
    gmailId = map['gmailId'];
    appleId = map['appleId'];
    gender = map['gender'];
    image = map['image'];
    preferredSalon = List<String>.from(map['preferredSalon'] ?? []);
    preferredArtist = List<String>.from(map['preferredArtist'] ?? []);
    id = map['id'];
    loginTime = (map['loginTime'] = DateTime.now());
  }
}

