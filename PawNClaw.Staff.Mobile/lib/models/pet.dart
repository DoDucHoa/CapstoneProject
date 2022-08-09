import 'package:pncstaff_mobile_application/models/photo.dart';
import 'package:pncstaff_mobile_application/models/user_profile.dart';

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
  List<Photos>? _photos;
  // Null? _petTypeCodeNavigation;
  // List<Null>? _petSearchDetails;
  // List<Null>? _petHealthHistories;

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
      List<Photos>? photos
      // Null? petTypeCodeNavigation,
      // List<Null>? petSearchDetails,
      // List<Null>? petHealthHistories
      }) {
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
    if (photos != null) {
      this._photos = photos;
    }
    // if (petTypeCodeNavigation != null) {
    //   this._petTypeCodeNavigation = petTypeCodeNavigation;
    // }
    // if (petSearchDetails != null) {
    //   this._petSearchDetails = petSearchDetails;
    // }
    // if (petHealthHistories != null) {
    //   this._petHealthHistories = petHealthHistories;
    // }
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
  List<Photos>? get photos => _photos;
  set photos(List<Photos>? photos) => _photos = photos;
  // Null? get petTypeCodeNavigation => _petTypeCodeNavigation;
  // set petTypeCodeNavigation(Null? petTypeCodeNavigation) =>
  //     _petTypeCodeNavigation = petTypeCodeNavigation;
  // List<Null>? get petSearchDetails => _petSearchDetails;
  // set petSearchDetails(List<Null>? petSearchDetails) =>
  //     _petSearchDetails = petSearchDetails;
  // List<Null>? get petHealthHistories => _petHealthHistories;
  // set petHealthHistories(List<Null>? petHealthHistories) =>
  //     _petHealthHistories = petHealthHistories;

  Pet.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _weight = json['weight'];
    _length = json['length'];
    _height = json['height'];
    _name = json['name'];
    _birth = DateTime.now();
    _status = json['status'];
    _petTypeCode = json['petTypeCode'];
    _breedName = json['breedName'];
    if (json['photos'] != null) {
      _photos = <Photos>[];
      json['photos'].forEach((v) {
        _photos!.add(new Photos.fromJson(v));
      });
    }
    // _petTypeCodeNavigation = json['petTypeCodeNavigation'];
    // if (json['petSearchDetails'] != null) {
    //   _petSearchDetails = <Null>[];
    //   json['petSearchDetails'].forEach((v) {
    //     _petSearchDetails!.add(new .fromJson(v));
    //   });
    // }
    // if (json['petHealthHistories'] != null) {
    //   _petHealthHistories = <Null>[];
    //   json['petHealthHistories'].forEach((v) {
    //     _petHealthHistories!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
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
    // if (this._petHealthHistories != null) {
    //   data['petHealthHistories'] =
    //       this._petHealthHistories!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
