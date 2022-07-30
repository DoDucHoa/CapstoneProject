import 'dart:convert';

import 'package:pawnclaw_mobile_application/models/photo.dart';

class Pet {
  int? _id;
  double? _weight;
  double? _length;
  double? _height;
  String? _name;
  DateTime? _birth;
  bool? _status;
  String? _petTypeCode;
  String? _breedName;
  // Null? _petTypeCodeNavigation;
  // List<Null>? _petSearchDetails;
  List<PetHealthHistories>? _petHealthHistories;
  String? _photoUrl;
  int? _customerId;
  List<Photo>? _photos;

  Pet(
      {int? id,
      double? weight,
      double? length,
      double? height,
      String? name,
      DateTime? birth,
      bool? status,
      String? petTypeCode,
      String? breedName,
      // Null? petTypeCodeNavigation,
      // List<Null>? petSearchDetails,
      List<PetHealthHistories>? petHealthHistories,
      String? photoUrl,
      int? customerId,
      List<Photo>? photos}) {
    if (id != null) {
      this._id = id;
    }
    if (weight != null) {
      this._weight = weight;
    }
    if (length != null) {
      this._length = length;
    }
    if (height != null) {
      this._height = height;
    }
    if (name != null) {
      this._name = name;
    }
    if (birth != null) {
      this._birth = birth;
    }
    if (status != null) {
      this._status = status;
    }
    if (petTypeCode != null) {
      this._petTypeCode = petTypeCode;
    }
    if (breedName != null) {
      this._breedName = breedName;
    }
    // if (petTypeCodeNavigation != null) {
    //   this._petTypeCodeNavigation = petTypeCodeNavigation;
    // }
    // if (petSearchDetails != null) {
    //   this._petSearchDetails = petSearchDetails;
    // }
    if (petHealthHistories != null) {
      this._petHealthHistories = petHealthHistories;
    }
    if (photoUrl != null) {
      this._photoUrl = photoUrl;
    }
    if (customerId != null) {
      this._customerId = customerId;
    }
    if (photos != null) {
      this._photos = photos;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  double? get weight => _weight;
  set weight(double? weight) => _weight = weight;
  double? get length => _length;
  set length(double? length) => _length = length;
  double? get height => _height;
  set height(double? height) => _height = height;
  String? get name => _name;
  set name(String? name) => _name = name;
  DateTime? get birth => _birth;
  set birth(DateTime? birth) => _birth = birth;
  bool? get status => _status;
  set status(bool? status) => _status = status;
  String? get petTypeCode => _petTypeCode;
  set petTypeCode(String? petTypeCode) => _petTypeCode = petTypeCode;
  String? get breedName => _breedName;
  set breedName(String? breedName) => _breedName = breedName;
  String? get photoUrl => _photoUrl;
  set photoUrl(String? photoUrl) => _photoUrl = photoUrl;
  List<Photo>? get photos => _photos;
  set photos(List<Photo>? photos) => _photos = photos;
  // Null? get petTypeCodeNavigation => _petTypeCodeNavigation;
  // set petTypeCodeNavigation(Null? petTypeCodeNavigation) =>
  //     _petTypeCodeNavigation = petTypeCodeNavigation;
  // List<Null>? get petSearchDetails => _petSearchDetails;
  // set petSearchDetails(List<Null>? petSearchDetails) =>
  //     _petSearchDetails = petSearchDetails;
  List<PetHealthHistories>? get petHealthHistories => _petHealthHistories;
  set petHealthHistories(List<PetHealthHistories>? petHealthHistories) =>
      _petHealthHistories = petHealthHistories;

  Pet.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _weight = json['weight'];
    _length = json['length'];
    _height = json['height'];
    _name = json['name'];
    _birth = DateTime.parse((json['birth']).toString());
    _status = json['status'];
    _petTypeCode = json['petTypeCode'];
    _breedName = json['breedName'];
    // _petTypeCodeNavigation = json['petTypeCodeNavigation'];
    // if (json['petSearchDetails'] != null) {
    //   _petSearchDetails = <Null>[];
    //   json['petSearchDetails'].forEach((v) {
    //     _petSearchDetails!.add(new .fromJson(v));
    //   });
    // }
    if (json['petHealthHistories'] != null) {
      _petHealthHistories = <PetHealthHistories>[];
      json['petHealthHistories'].forEach((v) {
        _petHealthHistories!.add(PetHealthHistories.fromJson(v));
      });
    }
    if (json['photos'] != null) {
      _photos = <Photo>[];
      json['photos'].forEach((v) {
        photos!.add(Photo.fromJson(v));
      });
    }
    _customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) {
      data['id'] = this._id;
    }
    data['weight'] = this._weight;
    data['length'] = this._length;
    data['height'] = this._height;
    data['name'] = this._name;
    data['birth'] = this._birth!.toIso8601String();
    data['status'] = this._status;
    data['petTypeCode'] = this._petTypeCode;
    data['breedName'] = this._breedName;
    // data['petTypeCodeNavigation'] = this._petTypeCodeNavigation;
    // if (this._petSearchDetails != null) {
    //   data['petSearchDetails'] =
    //       this._petSearchDetails!.map((v) => v.toJson()).toList();
    // }
    if (this._petHealthHistories != null) {
      data['petHealthHistories'] =
          this._petHealthHistories!.map((v) => v.toJson()).toList();
    }
    if (this._photoUrl != null) {
      data['photoUrl'] = this._photoUrl;
    }
    data['customerId'] = this._customerId;
    return data;
  }
}

class PetHealthHistories {
  PetHealthHistories({
    this.id,
    this.checkedDate,
    this.description,
    this.centerName,
    this.weight,
    this.height,
    this.length,
    this.petId,
    this.bookingId,
    this.booking,
  });

  int? id;
  DateTime? checkedDate;
  String? description;
  String? centerName;
  double? weight;
  double? height;
  double? length;
  int? petId;
  int? bookingId;
  dynamic booking;

  factory PetHealthHistories.fromRawJson(String str) =>
      PetHealthHistories.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PetHealthHistories.fromJson(Map<String, dynamic> json) =>
      PetHealthHistories(
        id: json["id"],
        checkedDate: DateTime.parse(json["checkedDate"]),
        description: json["description"],
        centerName: json["centerName"],
        weight: json["weight"].toDouble(),
        height: json["height"].toDouble(),
        length: json["length"].toDouble(),
        petId: json["petId"],
        bookingId: json["bookingId"],
        booking: json["booking"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "checkedDate": checkedDate!.toIso8601String(),
        "description": description,
        "centerName": centerName,
        "weight": weight,
        "height": height,
        "length": length,
        "petId": petId,
        "bookingId": bookingId,
        "booking": booking,
      };
}
