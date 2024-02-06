class SchedulingResponse {
  String status;
  String message;
  SchedulingRequest data;

  SchedulingResponse({required this.status, required this.message, required this.data});

  factory SchedulingResponse.fromJson(Map<String, dynamic> json) {
    return SchedulingResponse(
      status: json['status'],
      message: json['message'],
      data: SchedulingRequest.fromJson(json['data']),
    );
  }
}

class SchedulingData {
  String salonId;
  List<SchedulingRequest> requests;

  SchedulingData({required this.salonId, required this.requests});

  factory  SchedulingData.fromJson(Map<String, dynamic> json) {
    return  SchedulingData(
      salonId: json['salonId'] ?? '',
      requests: List<SchedulingRequest>.from(json['requests'].map((request) => SchedulingRequest.fromJson(request))),
    );
  }
}

class SchedulingRequest {
  String service;
  String artist;

  SchedulingRequest({required this.service, required this.artist});

  factory SchedulingRequest.fromJson(Map<String, dynamic> json) {
    return SchedulingRequest(
      service: json['service'] ?? '',
      artist: json['artist'] ?? '',
    );
  }
}
