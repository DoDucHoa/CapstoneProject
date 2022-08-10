// import 'package:pncstaff_mobile_application/models/photo.dart';

class PetCenter {
  int? id;
  String? name;
  String? address;
  String? phone;
  double? rating;
  String? createDate;
  String? modifyDate;
  int? createUser;
  int? modifyUser;
  bool? status;
  int? brandId;
  String? openTime;
  String? closeTime;
  String? description;
  String? checkin;
  String? checkout;
  int? ratingCount;
  String? endBooking;
  // Photo? photos;

  PetCenter({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.rating,
    this.createDate,
    this.modifyDate,
    this.createUser,
    this.modifyUser,
    this.status,
    this.brandId,
    this.openTime,
    this.closeTime,
    this.description,
    this.checkin,
    this.checkout,
    this.ratingCount,
    this.endBooking,
    //this.photos
  });

  PetCenter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    rating = json['ratingPoint'];
    createDate = json['createDate'];
    modifyDate = json['modifyDate'];
    createUser = json['createUser'];
    modifyUser = json['modifyUser'];
    status = json['status'];
    brandId = json['brandId'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    description = json['description'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    ratingCount = json['ratingCount'];
    endBooking = json['endBooking'];

    // photos = Photo.fromJson(json['photos']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['ratingPoint'] = this.rating!.toDouble();
    data['createDate'] = this.createDate;
    data['modifyDate'] = this.modifyDate;
    data['createUser'] = this.createUser;
    data['modifyUser'] = this.modifyUser;
    data['status'] = this.status;
    data['brandId'] = this.brandId;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['description'] = this.description;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['ratingCount'] = this.ratingCount;
    data['endBooking'] = this.endBooking;
    // data['photos'] = this.photos?.toJson();
    return data;
  }
}
