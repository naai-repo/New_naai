enum Gender {
  MALE,
  FEMALE,
  OTHERS,
}
extension GenderExtension on Gender {
  String getString() {
    switch (this) {
      case Gender.MALE:
        return 'MALE';
      case Gender.FEMALE:
        return 'UNISEX';
      case Gender.OTHERS:
        return 'OTHERS';
      default:
        return '';
    }
  }
}
enum Services {
  HAIR,
  SPA,
  BEAUTY,
  MAKEUP,
  NAIL,

}

enum StaffType {
  Single,
  Multiple,
}

enum FilterType {
  Rating,
}

enum Services2 {
  HAIR,
  SPA,
  Haircut,
  Beauty,
  Nails,

}
