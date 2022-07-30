import 'package:pncstaff_mobile_application/models/pet_center.dart';

class UserProfile {
  int? id;
  String? userName;
  int? createdUser;
  String? deviceId;
  String? phone;
  bool? status;
  String? roleCode;
  StaffIdNavigation? staffIdNavigation;
  List<Photos>? photos;
  PetCenter? center;

  UserProfile(
      {this.id,
      this.userName,
      this.createdUser,
      this.deviceId,
      this.phone,
      this.status,
      this.roleCode,
      this.staffIdNavigation,
      this.photos,
      this.center});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    createdUser = json['createdUser'];
    deviceId = json['deviceId'];
    phone = json['phone'];
    status = json['status'];
    roleCode = json['roleCode'];
    staffIdNavigation = json['staffIdNavigation'] != null
        ? new StaffIdNavigation.fromJson(json['staffIdNavigation'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['createdUser'] = this.createdUser;
    data['deviceId'] = this.deviceId;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['roleCode'] = this.roleCode;
    if (this.staffIdNavigation != null) {
      data['staffIdNavigation'] = this.staffIdNavigation!.toJson();
    }
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffIdNavigation {
  int? id;
  int? centerId;
  String? createDate;
  String? modifyDate;
  int? createUser;
  int? modifyUser;
  String? name;

  StaffIdNavigation(
      {this.id,
      this.centerId,
      this.createDate,
      this.modifyDate,
      this.createUser,
      this.modifyUser,
      this.name});

  StaffIdNavigation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    centerId = json['centerId'];
    createDate = json['createDate'];
    modifyDate = json['modifyDate'];
    createUser = json['createUser'];
    modifyUser = json['modifyUser'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['centerId'] = this.centerId;
    data['createDate'] = this.createDate;
    data['modifyDate'] = this.modifyDate;
    data['createUser'] = this.createUser;
    data['modifyUser'] = this.modifyUser;
    data['name'] = this.name;
    return data;
  }
}

class Photos {
  int? id;
  String? url;
  bool? status;

  Photos({
    this.id,
    this.url,
    this.status,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['status'] = this.status;
    return data;
  }
}
