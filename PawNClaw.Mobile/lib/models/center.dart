import 'package:pawnclaw_mobile_application/models/voucher.dart';

import 'cage_type.dart';
import  'dart:convert';

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
  dynamic _brand;
  List<CageTypes>? _cageTypes;
  List<Services>? _services;
  List<Supplies>? _supplies;
  String? _endBooking;
  List<Voucher>? _vouchers;

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
      List<Supplies>? supplies,
      String? endBooking,
      List<Voucher>? vouchers}) {
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
    if (endBooking != null) {
      this._endBooking = endBooking;
    }
    if (vouchers != null) {
      this._vouchers = vouchers;
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
  String? get endBooking => _endBooking;
  List<Voucher>? get vouchers => _vouchers;

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
    _endBooking = json['endBooking'];

    if(json['vouchers'] != null){
      _vouchers = <Voucher>[];
      json['vouchers'].forEach((v) {
        _vouchers!.add(new Voucher.fromJson(v));
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
    data['endBooking'] = this._endBooking;
    if (this._vouchers != null) {
      data['vouchers'] = this._vouchers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String shortAddress() {
    var splited = this.address!.split(",");
    return splited[0] + ', ' + splited[1];
  }
}

class Services {
  int? id;
  String? description;
  double? discountPrice;
  List<ServicePrices>? servicePrices;
  double? minPrice;
  double? maxPrice;

  Services(
      {this.id,
      this.description,
      this.discountPrice,
      this.servicePrices,
      this.minPrice,
      this.maxPrice});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    discountPrice = json['discountPrice'];
    if (json['servicePrices'] != null) {
      servicePrices = <ServicePrices>[];
      json['servicePrices'].forEach((v) {
        servicePrices!.add(new ServicePrices.fromJson(v));
      });
      if (servicePrices!.isEmpty) {
        servicePrices = null;
        minPrice = json['minPrice'].toDouble();
        maxPrice = json['maxPrice'].toDouble();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['discountPrice'] = this.discountPrice;
    if (this.servicePrices != null) {
      data['servicePrices'] =
          this.servicePrices!.map((v) => v.toJson()).toList();
    } else {
      data['minPrice'] = this.minPrice;
      data['maxPrice'] = this.maxPrice;
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

class SearchResponseModel {
  List<Center>? petCenters;
  String? city;
  String? district;
  String? districtName;
  int? page;
  String? result;

  SearchResponseModel(
      {this.petCenters,
      this.city,
      this.district,
      this.districtName,
      this.page,
      this.result});
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

class LocationResponseModel {
    LocationResponseModel({
        this.id,
        this.longtitude,
        this.latitude,
        this.cityCode,
        this.districtCode,
        this.wardCode,
        this.center,
        this.distance,
        this.duration,
    });

    int? id;
    String? longtitude;
    String? latitude;
    int? cityCode;
    int? districtCode;
    int? wardCode;
    Center? center;
    String? distance;
    String? duration;

    factory LocationResponseModel.fromRawJson(String str) => LocationResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LocationResponseModel.fromJson(Map<String, dynamic> json) => LocationResponseModel(
        id: json["id"],
        longtitude: json["longtitude"],
        latitude: json["latitude"],
        cityCode: json["cityCode"],
        districtCode: json["districtCode"],
        wardCode: json["wardCode"],
        center: Center.fromJson(json["idNavigation"]),
        distance: json["distance"],
        duration: json["duration"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "longtitude": longtitude,
        "latitude": latitude,
        "cityCode": cityCode,
        "districtCode": districtCode,
        "wardCode": wardCode,
        "idNavigation": center!.toJson(),
        "distance": distance,
        "duration": duration,
    };
}
