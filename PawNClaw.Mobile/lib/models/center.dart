import 'cage_type.dart';

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
  List<CageTypes>? _cageTypes;
  List<Services>? _services;
  List<Supplies>? _supplies;

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
      String? brand,
      List<CageTypes>? cageTypes,
      List<Services>? services,
      List<Supplies>? supplies}) {
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
    if (cageTypes != null) {
      this._cageTypes = cageTypes;
    }
    if (supplies != null) {
      this._supplies = supplies;
    }
    if (services != null) {
      this._services = services;
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
  List<CageTypes>? get cageTypes => _cageTypes;
  set cageTypes(List<CageTypes>? cageTypes) => _cageTypes = cageTypes;
  List<Services>? get services => _services;
  set services(List<Services>? services) => _services = services;
  List<Supplies>? get supplies => _supplies;
  set supplies(List<Supplies>? supplies) => _supplies = supplies;

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
    if (json['cageTypes'] != null) {
      _cageTypes = <CageTypes>[];
      json['cageTypes'].forEach((v) {
        _cageTypes!.add(new CageTypes.fromJson(v));
      });
    }
    if (json['services'] != null) {
      _services = <Services>[];
      json['services'].forEach((v) {
        _services!.add(new Services.fromJson(v));
      });
    }
    if (json['supplies'] != null) {
      _supplies = <Supplies>[];
      json['supplies'].forEach((v) {
        _supplies!.add(new Supplies.fromJson(v));
      });
    }
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
    if (this._cageTypes != null) {
      data['cageTypes'] = this._cageTypes!.map((v) => v.toJson()).toList();
    }
    if (this._services != null) {
      data['services'] = this._services!.map((v) => v.toJson()).toList();
    }
    if (this._supplies != null) {
      data['supplies'] = this._supplies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? description;
  double? sellPrice;
  double? discountPrice;
  List<ServicePrices>? servicePrices;

  Services(
      {this.id,
      this.description,
      this.sellPrice,
      this.discountPrice,
      this.servicePrices});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    sellPrice = json['sellPrice'];
    discountPrice = json['discountPrice'];
    if (json['servicePrices'] != null) {
      servicePrices = <ServicePrices>[];
      json['servicePrices'].forEach((v) {
        servicePrices!.add(new ServicePrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['sellPrice'] = this.sellPrice;
    data['discountPrice'] = this.discountPrice;
    if (this.servicePrices != null) {
      data['servicePrices'] =
          this.servicePrices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicePrices {
  int? id;
  double? price;
  double? minWeight;
  double? maxWeight;

  ServicePrices({this.id, this.price, this.minWeight, this.maxWeight});

  ServicePrices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    minWeight = json['minWeight'];
    maxWeight = json['maxWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['minWeight'] = this.minWeight;
    data['maxWeight'] = this.maxWeight;
    return data;
  }
}

class Supplies {
  int? id;
  String? name;
  double? sellPrice;
  double? discountPrice;
  int? quantity;
  bool? status;
  String? supplyTypeCode;

  Supplies({
    this.id,
    this.name,
    this.sellPrice,
    this.discountPrice,
    this.quantity,
    this.status,
    this.supplyTypeCode,
  });

  Supplies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sellPrice = json['sellPrice'];
    discountPrice = json['discountPrice'];
    quantity = json['quantity'];
    status = json['status'];
    supplyTypeCode = json['supplyTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sellPrice'] = this.sellPrice;
    data['discountPrice'] = this.discountPrice;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['supplyTypeCode'] = this.supplyTypeCode;
    return data;
  }

  
}
