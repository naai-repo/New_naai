import 'dart:convert';

class ServiceDataModel {
    final String? id;
    final String? salonId;
    final String? category;
    final String? sub_category;
    final String? serviceTitle;
    final String? description;
    final String? targetGender;
    final int? avgTime;
    final int? basePrice;
    final int? cutPrice;
    final String? createdAt;
    final String? updatedAt;
    final List<VariableService>? variables;
   
  ServiceDataModel({
    this.id,
    this.salonId,
    this.category,
    this.sub_category,
    this.serviceTitle,
    this.description,
    this.targetGender,
    this.avgTime,
    this.basePrice,
    this.cutPrice,
    this.createdAt,
    this.updatedAt,
    this.variables
  });


  ServiceDataModel copyWith({
    String? id,
    String? salonId,
    String? category,
    String? sub_category,
    String? serviceTitle,
    String? description,
    String? targetGender,
    int? avgTime,
    int? basePrice,
    int? cutPrice,
    String? createdAt,
    String? updatedAt,
    List<VariableService>? variables,
  }) {
    return ServiceDataModel(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      category: category ?? this.category,
      sub_category: sub_category ?? this.sub_category,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      description: description ?? this.description,
      targetGender: targetGender ?? this.targetGender,
      avgTime: avgTime ?? this.avgTime,
      basePrice: basePrice ?? this.basePrice,
      cutPrice: cutPrice ?? this.cutPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      variables: variables ?? this.variables,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'salonId': salonId,
      'category': category,
      'sub_category': sub_category,
      'serviceTitle': serviceTitle,
      'description': description,
      'targetGender': targetGender,
      'avgTime': avgTime,
      'basePrice': basePrice,
      'cutPrice': cutPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'variables': variables?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory ServiceDataModel.fromMap(Map<String, dynamic> map) {
    return ServiceDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      salonId: map['salonId'] != null ? map['salonId'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      sub_category: map['sub_category'] != null ? map['sub_category'] as String : null,
      serviceTitle: map['serviceTitle'] != null ? map['serviceTitle'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      targetGender: map['targetGender'] != null ? map['targetGender'] as String : null,
      avgTime: map['avgTime'] != null ? map['avgTime'] as int : null,
      basePrice: map['basePrice'] != null ? map['basePrice'] as int : null,
      cutPrice: map['cutPrice'] != null ? map['cutPrice'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      variables: map['variables'] != null ? List<VariableService>.from((map['variables'] as List<dynamic>).map<VariableService?>((x) => VariableService.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDataModel.fromJson(String source) => ServiceDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceDataModel(id: $id, salonId: $salonId, category: $category, sub_category: $sub_category, serviceTitle: $serviceTitle, description: $description, targetGender: $targetGender, avgTime: $avgTime, basePrice: $basePrice, cutPrice: $cutPrice, createdAt: $createdAt, updatedAt: $updatedAt, variables: $variables)';
  }
}

class VariableService {
  final String? variableType;
  final String? variableName;
  final int? variablePrice;
  final int? variableCutPrice;
  final int? variableTime;
  final String? id;

  VariableService({
    this.variableType,
    this.variableName,
    this.variablePrice,
    this.variableCutPrice,
    this.variableTime,
    this.id,
  });

  VariableService copyWith({
    String? variableType,
    String? variableName,
    int? variablePrice,
    int? variableCutPrice,
    int? variableTime,
    String? id,
  }) {
    return VariableService(
      variableType: variableType ?? this.variableType,
      variableName: variableName ?? this.variableName,
      variablePrice: variablePrice ?? this.variablePrice,
      variableCutPrice: variableCutPrice ?? this.variableCutPrice,
      variableTime: variableTime ?? this.variableTime,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'variableType': variableType,
      'variableName': variableName,
      'variablePrice': variablePrice,
      'variableCutPrice': variableCutPrice,
      'variableTime': variableTime,
      'id': id,
    };
  }

  factory VariableService.fromMap(Map<String, dynamic> map) {
    return VariableService(
      variableType: map['variableType'] != null ? map['variableType'] as String : null,
      variableName: map['variableName'] != null ? map['variableName'] as String : null,
      variablePrice: map['variablePrice'] != null ? map['variablePrice'] as int : null,
      variableCutPrice: map['variableCutPrice'] != null ? map['variableCutPrice'] as int : null,
      variableTime: map['variableTime'] != null ? map['variableTime'] as int : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VariableService.fromJson(String source) => VariableService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VariableService(variableType: $variableType, variableName: $variableName, variablePrice: $variablePrice, variableCutPrice: $variableCutPrice, variableTime: $variableTime, id: $id)';
  }
}
