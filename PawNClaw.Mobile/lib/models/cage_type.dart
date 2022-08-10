import 'package:pawnclaw_mobile_application/models/photo.dart';

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
  double? minPrice;
  double? maxPrice;
  Photo? photo;

  CageTypes(
      {this.id,
      this.typeName,
      this.description,
      this.height,
      this.width,
      this.length,
      this.isSingle,
      this.cages,
      this.totalPrice,
      this.minPrice,
      this.maxPrice,
      this.photo});

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
    totalPrice =
        json['totalPrice'] == null ? null : double.parse(json['totalPrice']);
    minPrice = json['minPrice'] == null ? null : json['minPrice'].toDouble();
    maxPrice = json['maxPrice'] == null ? null : json['maxPrice'].toDouble();

    // if (json['prices'] != null) {
    //   prices = <Null>[];
    //   json['prices'].forEach((v) {
    //     prices!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['photos'] != null) {
      var photos = <Photo>[];
      json['photos'].forEach((v) {
        photos.add(Photo.fromJson(v));
      });
      if(photos.isNotEmpty) photo = photos.first;
    }
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
    if (this.totalPrice != null) data['totalPrice'] = this.totalPrice.toString();
    if (this.maxPrice != null) data['maxPrice'] = this.maxPrice.toString();
    if (this.minPrice != null) data['minPrice'] = this.minPrice.toString();
    if (this.photo != null) {
      data['photos'] = this.photo!.toJson();
    }
    return data;
  }
}
