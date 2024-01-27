class ServiceResponse {
  final String status;
  final String message;
  final ServiceData data;

  ServiceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: ServiceData.fromJson(json['data'] ?? {}),
    );
  }
}

class ServiceData {
  final String id;
  final String category;
  final String serviceTitle;
  final String description;
  final String targetGender;
  final List<String> salonIds;
  final int avgTime;
  final int basePrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ServiceData({
    required this.id,
    required this.category,
    required this.serviceTitle,
    required this.description,
    required this.targetGender,
    required this.salonIds,
    required this.avgTime,
    required this.basePrice,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
      description: json['description'] ?? '',
      targetGender: json['targetGender'] ?? '',
      salonIds: List<String>.from(json['salonIds'] ?? []),
      avgTime: json['avgTime'] ?? 0,
      basePrice: json['basePrice'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      v: json['__v'] ?? 0,
    );
  }
}