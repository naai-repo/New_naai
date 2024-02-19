import 'dart:convert';

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });



  Location copyWith({
    String? type,
    List<double>? coordinates,
  }) {
    return Location(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'coordinates': coordinates,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      type: map['type'] != null ? map['type'] as String : null,
      coordinates: map['coordinates'] != null ? List<double>.from((map['coordinates'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(type: $type, coordinates: $coordinates)';
}
