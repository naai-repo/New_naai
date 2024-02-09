// not in used

class Booking {
  String? id;
  String? artistId;
  int? startTime;
  int? endTime;
  List<String>? serviceIds;
  String? salonId;
  String? userId;
  String? selectedDate;
  String? bookingCreatedOn;
  String? bookingCreatedFor;

  // Parameters to ensure perfect transaction working
  double? price;
  String? transactionStatus;
  String? paymentId;
  String? orderId;
  String? errorMessage;

  /// These are additional parameters. Not being fetched/sent from/to Firebase
  /// This is being used to display the booking related data on the app only.
  String? salonName;
  String? artistName;
  List<String>? bookedServiceNames;
  double totalPrice;
  bool isUpcoming;
  String? createdOnString;
  DateTime? selectedDateInDateTimeFormat;

  Booking({
    this.id,
    this.artistId,
    this.startTime,
    this.endTime,
    this.salonId,
    this.userId,
    this.serviceIds,
    this.bookingCreatedFor,
    this.bookingCreatedOn,
    this.price,
    this.transactionStatus,
    this.paymentId,
    this.orderId,
    this.errorMessage,
    this.salonName,
    this.artistName,
    this.bookedServiceNames ,
    this.totalPrice = 0,
    this.isUpcoming = false,
    this.createdOnString,
    this.selectedDateInDateTimeFormat,
  });

  factory Booking.fromDocumentSnapshot(docData) {
    Map<String, dynamic> data = docData.data() as Map<String, dynamic>;

    return Booking(
      id: data['id'],
      artistId: data['artistId'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      salonId: data['salonId'],
      userId: data['userId'],
      serviceIds:
          data['serviceIds'] != null ? data['serviceIds'].cast<String>() : [],
      bookingCreatedOn: data['bookingCreatedOn'],
      bookingCreatedFor: data['bookingCreatedFor'],
      price: data['price'],
      transactionStatus: data['transactionStatus'],
      paymentId: data['paymentId'],
      orderId: data['orderId'],
      errorMessage: data['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'startTime': startTime,
      'endTime': endTime,
      'salonId': salonId,
      'userId': userId,
      'serviceIds': serviceIds,
      'bookingCreatedOn': bookingCreatedOn,
      'bookingCreatedFor': bookingCreatedFor,
      'price': price,
      'transactionStatus': transactionStatus,
      'paymentId': paymentId,
      'orderId': orderId,
      'errorMessage': errorMessage,
    };
  }
}
