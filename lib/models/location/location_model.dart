
class UserLocationModel {
  String? type;
  List<dynamic>? query;
  List<Feature>? features;
  String? attribution;

  UserLocationModel({this.type, this.query, this.features, this.attribution});

  UserLocationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json["query"] != null && json["query"].isNotEmpty == true) {
      query = json["query"][0].runtimeType == String
          ? json['query'].cast<String>()
          : json['query'].cast<double>();
    }
    if (json['features'] != null) {
      features = <Feature>[];
      json['features'].forEach((v) {
        features!.add(Feature.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['query'] = this.query;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    return data;
  }
}

class Feature {
  String? id;
  String? type;
  List<String>? placeType;
  Properties? properties;
  String? textEnGb;
  String? placeNameEnGb;
  String? text;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  Feature(
      {this.id,
      this.type,
      this.placeType,
      this.properties,
      this.textEnGb,
      this.placeNameEnGb,
      this.text,
      this.placeName,
      this.center,
      this.geometry,
      this.context});

  Feature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    if (json['place_type'] != null) {
      placeType = json['place_type'].cast<String>();
    }
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    textEnGb = json['text_en-gb'];
    placeNameEnGb = json['place_name_en-gb'];
    text = json['text'];
    placeName = json['place_name'];
    if (json['center'] != null) {
      center = json['center'].cast<double>();
    }
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    if (json['context'] != null) {
      context = <Context>[];
      json['context'].forEach((v) {
        context!.add(new Context.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['place_type'] = this.placeType;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    data['text_en-gb'] = this.textEnGb;
    data['place_name_en-gb'] = this.placeNameEnGb;
    data['text'] = this.text;
    data['place_name'] = this.placeName;
    data['center'] = this.center;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  String? foursquare;
  bool? landmark;
  String? category;
  String? address;

  Properties({this.foursquare, this.landmark, this.category, this.address});

  Properties.fromJson(Map<String, dynamic> json) {
    foursquare = json['foursquare'];
    landmark = json['landmark'];
    category = json['category'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foursquare'] = this.foursquare;
    data['landmark'] = this.landmark;
    data['category'] = this.category;
    data['address'] = this.address;
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    return data;
  }
}

class Context {
  String? id;
  String? textEnGb;
  String? text;
  String? wikidata;
  String? languageEnGb;
  String? language;
  String? shortCode;

  Context(
      {this.id,
      this.textEnGb,
      this.text,
      this.wikidata,
      this.languageEnGb,
      this.language,
      this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    textEnGb = json['text_en-gb'];
    text = json['text'];
    wikidata = json['wikidata'];
    languageEnGb = json['language_en-gb'];
    language = json['language'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text_en-gb'] = this.textEnGb;
    data['text'] = this.text;
    data['wikidata'] = this.wikidata;
    data['language_en-gb'] = this.languageEnGb;
    data['language'] = this.language;
    data['short_code'] = this.shortCode;
    return data;
  }
}
