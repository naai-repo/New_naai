import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/utils/enums.dart';

class ServiceDetail {
  Services? category;
  String? serviceTitle;
  double? price;
  Gender? targetGender;
  String? id;
  List<String>? artistIdList;

  ServiceDetail({
    this.category,
    this.serviceTitle,
    this.price,
    this.targetGender,
    this.artistIdList,
    this.id,
  });

  factory ServiceDetail.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> data = docData.data() as Map<String, dynamic>;

    return ServiceDetail(
      id: data['id'],
      artistIdList: data['artistIdList'].cast<String>(),
      category: Services.values[(Services.values.indexWhere(
          (category) => category.name.toLowerCase() == data['category']))],
      serviceTitle: data['serviceTitle'],
      price: data['price'].toDouble(),
      targetGender: data['targetGender'] == 'Men'
          ? Gender.MALE
          : data['targetGender'] == 'Women'
              ? Gender.FEMALE
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category?.index,
      'serviceTitle': serviceTitle,
      'price': price,
      'targetGender': targetGender?.index,
    };
  }
}
