class Center {
  int? _id;
  String? _name;
  String? _address;
  String? _phone;
  int? _rating;
  int? _ratingCount;
  bool? _status;
  int? _brandId;
  String? _openTime;
  String? _closeTime;
  String? _brand;

  Center(
      {int? id,
      String? name,
      String? address,
      String? phone,
      int? rating,
      int? ratingCount,
      bool? status,
      int? brandId,
      String? openTime,
      String? closeTime,
      String? brand}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (address != null) {
      this._address = address;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (rating != null) {
      this._rating = rating;
    }
    if (ratingCount != null) {
      this._ratingCount = ratingCount;
    }
    if (status != null) {
      this._status = status;
    }
    if (brandId != null) {
      this._brandId = brandId;
    }
    if (openTime != null) {
      this._openTime = openTime;
    }
    if (closeTime != null) {
      this._closeTime = closeTime;
    }
    if (brand != null) {
      this._brand = brand;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get address => _address;
  set address(String? address) => _address = address;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  int? get rating => _rating;
  set rating(int? rating) => _rating = rating;
  int? get ratingCount => _ratingCount;
  set ratingCount(int? ratingCount) => _ratingCount = ratingCount;
  bool? get status => _status;
  set status(bool? status) => _status = status;
  int? get brandId => _brandId;
  set brandId(int? brandId) => _brandId = brandId;
  String? get openTime => _openTime;
  set openTime(String? openTime) => _openTime = openTime;
  String? get closeTime => _closeTime;
  set closeTime(String? closeTime) => _closeTime = closeTime;
  String? get brand => _brand;
  set brand(String? brand) => _brand = brand;

  Center.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _address = json['address'];
    _phone = json['phone'];
    _rating = json['rating'];
    _ratingCount = json['ratingCount'];
    _status = json['status'];
    _brandId = json['brandId'];
    _openTime = json['openTime'];
    _closeTime = json['closeTime'];
    _brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['address'] = this._address;
    data['phone'] = this._phone;
    data['rating'] = this._rating;
    data['ratingCount'] = this._ratingCount;
    data['status'] = this._status;
    data['brandId'] = this._brandId;
    data['openTime'] = this._openTime;
    data['closeTime'] = this._closeTime;
    data['brand'] = this._brand;
    return data;
  }
}
