import 'cage.dart';

class CageTypes {
  int? id;
  String? typeName;
  String? description;
  double? height;
  double? width;
  double? length;
  bool? isSingle;
  List<Cages>? cages;
  double? totalPrice;

  CageTypes(
      {this.id,
      this.typeName,
      this.description,
      this.height,
      this.width,
      this.length,
      this.isSingle,
      this.cages,
      this.totalPrice});

  CageTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['typeName'];
    description = json['description'];
    height = json['height'];
    width = json['width'];
    length = json['length'];
    isSingle = json['isSingle'];
    if (json['cages'] != null) {
      cages = <Cages>[];
      json['cages'].forEach((v) {
        cages!.add(new Cages.fromJson(v));
      });
    }
    totalPrice = double.parse(json['totalPrice']);
    // if (json['prices'] != null) {
    //   prices = <Null>[];
    //   json['prices'].forEach((v) {
    //     prices!.add(new Null.fromJson(v));
    //   });
    // }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeName'] = this.typeName;
    data['description'] = this.description;
    data['height'] = this.height;
    data['width'] = this.width;
    data['length'] = this.length;
    data['isSingle'] = this.isSingle;
    if (this.cages != null) {
      data['cages'] = this.cages!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice.toString();
    return data;
  }
}
