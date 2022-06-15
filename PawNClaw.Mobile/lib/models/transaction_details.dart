// To parse this JSON data, do
//
//     final transactionDetails = transactionDetailsFromJson(jsonString);

import 'dart:convert';

class TransactionDetails {
  TransactionDetails({
    this.bookingDetails,
    this.serviceOrders,
    this.supplyOrders,
  });

  List<BookingDetail>? bookingDetails;
  List<ServiceOrder>? serviceOrders;
  List<SupplyOrder>? supplyOrders;

  factory TransactionDetails.fromRawJson(String str) =>
      TransactionDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
        bookingDetails: List<BookingDetail>.from(
            json["bookingDetails"].map((x) => BookingDetail.fromJson(x))),
        serviceOrders: json["serviceOrders"] != null
            ? List<ServiceOrder>.from(
                json["serviceOrders"].map((x) => ServiceOrder.fromJson(x)))
            : null,
        supplyOrders: json["supplyOrders"] != null
            ? List<SupplyOrder>.from(
                json["supplyOrders"].map((x) => SupplyOrder.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "bookingDetails":
            List<BookingDetail>.from(bookingDetails!.map((x) => x.toJson())),
        "serviceOrders":
            List<ServiceOrder>.from(serviceOrders!.map((x) => x.toJson())),
        "supplyOrders":
            List<SupplyOrder>.from(supplyOrders!.map((x) => x.toJson())),
      };

  double getTotalServices() {
    if (serviceOrders == null) return 0;
    double total = 0;
    for (ServiceOrder order in serviceOrders!) {
      total += order.totalPrice!;
    }
    return total;
  }

  double getTotalSupplies() {
    if (supplyOrders == null) return 0;
    double total = 0;
    for (SupplyOrder order in supplyOrders!) {
      total += order.totalPrice!;
    }
    return total;
  }

  double getTotalCages() {
    double total = 0;
    for (BookingDetail order in bookingDetails!) {
      total += order.price!;
    }
    return total;
  }

  List<Pet> getPets() {
    List<Pet> pets = [];
    this.bookingDetails!.forEach((b) {
      b.petBookingDetails!.forEach((p) {
        pets.add(p.pet!);
      });
    });
    return pets;
  }

  bool haveItems(Pet pet){
    for (var element in this.serviceOrders!) {
      if (element.petId == pet.id){
        return true;
      }
    }
    for (var element in this.supplyOrders!) {
      if (element.petId == pet.id){
        return true;
      }
    }
    return false;
  }
}

class BookingDetail {
  BookingDetail(
      {this.bookingId,
      this.line,
      this.price,
      this.duration,
      this.petBookingDetails,
      this.cage});

  int? bookingId;
  int? line;
  double? price;
  double? duration;
  List<PetBookingDetail>? petBookingDetails;
  Cage? cage;

  factory BookingDetail.fromRawJson(String str) =>
      BookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDetail.fromJson(Map<String, dynamic> json) => BookingDetail(
      bookingId: json["bookingId"],
      line: json["line"],
      price: json["price"].toDouble(),
      duration: json["duration"].toDouble(),
      petBookingDetails: List<PetBookingDetail>.from(
          json["petBookingDetails"].map((x) => PetBookingDetail.fromJson(x))),
      cage: Cage.fromJson(json["c"]));

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "line": line,
        "price": price,
        "duration": duration,
        "petBookingDetails": List<PetBookingDetail>.from(
            petBookingDetails!.map((x) => x.toJson())),
        "c": cage!.toJson()
      };
  List<Pet> getPets(){
    List<Pet> pets = [];
    this.petBookingDetails!.forEach((element) {pets.add(element.pet!);});
    return pets;
  }
}

class Cage {
  Cage({this.cageType});

  CageType? cageType;
  factory Cage.fromRawJson(String str) => Cage.fromJson(json.decode(str));

  factory Cage.fromJson(Map<String, dynamic> json) => Cage(
        cageType: CageType.fromJson(json["cageType"]),
      );

  Map<String, dynamic> toJson() => {
        "cageType": cageType!.toJson(),
      };

  String toRawJson() => json.encode(toJson());
}

class CageType {
  CageType({this.id, this.typeName});

  int? id;
  String? typeName;
  factory CageType.fromRawJson(String str) =>
      CageType.fromJson(json.decode(str));

  factory CageType.fromJson(Map<String, dynamic> json) =>
      CageType(id: json["id"], typeName: json["typeName"]);

  Map<String, dynamic> toJson() => {"id": id, "typeName": typeName};

  String toRawJson() => json.encode(toJson());
}

class PetBookingDetail {
  PetBookingDetail({
    this.line,
    this.pet,
  });

  int? line;
  Pet? pet;

  factory PetBookingDetail.fromRawJson(String str) =>
      PetBookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PetBookingDetail.fromJson(Map<String, dynamic> json) =>
      PetBookingDetail(
        line: json["line"],
        pet: Pet.fromJson(json["pet"]),
      );

  Map<String, dynamic> toJson() => {
        "line": line,
        "pet": pet!.toJson(),
      };
}

class Pet {
  Pet({
    this.id,
    this.name,
    this.weight,
    this.height,
    this.length
  });

  int? id;
  String? name;
  double? weight;
  double? length;
  double? height;

  factory Pet.fromRawJson(String str) => Pet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json["id"],
        name: json["name"],
        weight: json["weight"].toDouble(),
        height: json["height"].toDouble(),
        length: json["length"].toDouble()
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "weight": weight,
        "height": height,
        "length": length
      };
}

class ServiceOrder {
  ServiceOrder({
    this.serviceId,
    this.quantity,
    this.sellPrice,
    this.totalPrice,
    this.petId,
    this.service,
  });

  int? serviceId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  int? petId;
  Service? service;

  factory ServiceOrder.fromRawJson(String str) =>
      ServiceOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServiceOrder.fromJson(Map<String, dynamic> json) => ServiceOrder(
        serviceId: json["serviceId"],
        quantity: json["quantity"],
        sellPrice: json["sellPrice"].toDouble(),
        totalPrice: json["totalPrice"].toDouble(),
        petId: json["petId"],
        service: Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "quantity": quantity,
        "sellPrice": sellPrice,
        "totalPrice": totalPrice,
        "petId": petId,
        "service": service!.toJson(),
      };
}

class Service {
  Service({
    this.id,
    this.description,
    this.discountPrice,
  });

  int? id;
  String? description;
  double? discountPrice;

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        description: json["description"],
        discountPrice: json["discountPrice"] != null
            ? json["discountPrice"].toDouble()
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "discountPrice": discountPrice,
      };
}

class SupplyOrder {
  SupplyOrder({
    this.supplyId,
    this.quantity,
    this.sellPrice,
    this.totalPrice,
    this.petId,
    this.supply,
  });

  int? supplyId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  int? petId;
  Supply? supply;

  factory SupplyOrder.fromRawJson(String str) =>
      SupplyOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupplyOrder.fromJson(Map<String, dynamic> json) => SupplyOrder(
        supplyId: json["supplyId"],
        quantity: json["quantity"],
        sellPrice: json["sellPrice"].toDouble(),
        totalPrice: json["totalPrice"].toDouble(),
        petId: json["petId"],
        supply: Supply.fromJson(json["supply"]),
      );

  Map<String, dynamic> toJson() => {
        "supplyId": supplyId,
        "quantity": quantity,
        "sellPrice": sellPrice,
        "totalPrice": totalPrice,
        "petId": petId,
        "supply": supply!.toJson(),
      };
}

class Supply {
  Supply({
    this.id,
    this.name,
    this.discountPrice,
  });

  int? id;
  String? name;
  double? discountPrice;

  factory Supply.fromRawJson(String str) => Supply.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Supply.fromJson(Map<String, dynamic> json) => Supply(
        id: json["id"],
        name: json["name"],
        discountPrice: json["discountPrice"] != null
            ? json["discountPrice"].toDouble()
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "discountPrice": discountPrice,
      };
}
