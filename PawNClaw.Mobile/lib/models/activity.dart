import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';

class Activity {
  final int id;
  //final String name;
  late ActivityType? type;
  late Product? product;
  DateTime time;
  late Pet? pet;
  String? imgUrl;
  Activity(
      {required this.id,
      this.type,
      this.product,
      required this.time,
      this.pet,
      required this.imgUrl});
}

class Product {
  final int id;
  final String name;
  final String imgUrl;
  final String note;

  Product(
      {required this.id,
      required this.name,
      required this.imgUrl,
      required this.note});
}

class ActivityType {
  late int id;
  late String? name;

  //ActivityType({required this.id, this.name});

  ActivityType(int id) {
    this.id = id;
    switch (id) {
      case 0:
        this.name = 'Cho ăn';
        break;
      case 1:
        this.name = 'Đồ dùng';
        break;
      default:
        this.name = 'Dịch vụ';
    }
  }
}
