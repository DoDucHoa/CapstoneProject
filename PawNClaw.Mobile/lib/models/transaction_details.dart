// To parse this JSON data, do
//
//     final transactionDetails = transactionDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:pawnclaw_mobile_application/models/activity.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/review.dart';

class TransactionDetails {
  TransactionDetails(
      {this.bookingId,
      this.bookingDetails,
      this.serviceOrders,
      this.supplyOrders,
      this.bookingActivities,
      this.invoiceUrl});
  int? bookingId;
  List<BookingDetail>? bookingDetails;
  List<ServiceOrder>? serviceOrders;
  List<SupplyOrder>? supplyOrders;
  List<BookingActivities>? bookingActivities;
  String? invoiceUrl;
  Review? review;

  factory TransactionDetails.fromRawJson(String str) =>
      TransactionDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
          invoiceUrl: json["invoiceUrl"],
          bookingId: json["id"],
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
          bookingActivities: List<BookingActivities>.from(
              json["bookingActivities"]
                  .map((x) => BookingActivities.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": bookingId,
        "bookingDetails":
            List<BookingDetail>.from(bookingDetails!.map((x) => x.toJson())),
        "serviceOrders":
            List<ServiceOrder>.from(serviceOrders!.map((x) => x.toJson())),
        "supplyOrders":
            List<SupplyOrder>.from(supplyOrders!.map((x) => x.toJson())),
        "bookingActivities": List<BookingActivities>.from(
            bookingActivities!.map((x) => x.toJson()))
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

  List<Pet> getPetsInCage(int bookingDetailId) {
    List<Pet> pets = [];
    this
        .bookingDetails!
        .where((e) => e.id == bookingDetailId)
        .first
        .petBookingDetails!
        .forEach((p) {
      pets.add(p.pet!);
    });

    this.bookingDetails!.forEach(print);
    // this.bookingDetails!.forEach((b) {
    //   b.petBookingDetails!.forEach((p) {
    //     pets.add(p.pet!);
    //   });
    // });
    print(pets);
    return pets;
  }

  bool haveItems(Pet pet) {
    for (var element in this.serviceOrders!) {
      if (element.petId == pet.id) {
        return true;
      }
    }
    for (var element in this.supplyOrders!) {
      if (element.petId == pet.id) {
        return true;
      }
    }
    return false;
  }

  List<Activity> getFeedActivities() {
    List<Activity> FEED_ACTS = [];
    for (var act in this.bookingActivities!) {
      if (act.bookingDetailId != null && act.provideTime != null) {
        for (var pet in getPetsInCage(act.bookingDetailId!)) {
          Cage cage = this
                      .bookingDetails!
                      .where((e) => e.id == act.bookingDetailId)
                      .first
                      .cage!;
          FEED_ACTS.add(Activity(
              id: act.id!,
              time: DateTime.parse(act.provideTime!),
              type: ActivityType(0),
              product: Product(
                  id: 0,
                  name: cage
                      .cageType!
                      .typeName!,
                  imgUrl: cage.cageType!.photo!.url ?? "",
                  note: act.description != null
                      ? act.description!
                      : 'Cho ${pet.name} ăn'),
              pet: pet,
              imgUrl: act.photo!.isNotEmpty ? act.photo!.first.url : null));
        }
      }

      print(FEED_ACTS);
    }
    return FEED_ACTS;
  }

  List<Activity> getSupplyActivities() {
    List<Activity> SUPPLY_ACTS = [];
    for (var act in this.bookingActivities!) {
      if (act.supplyId != null && act.provideTime != null) {
        for (var pet in getPets()) {
          if (pet.id == act.petId) {
            Supply supply = this
                .supplyOrders!
                .where((e) => e.supplyId == act.supplyId)
                .first
                .supply!;
            SUPPLY_ACTS.add(Activity(
                id: act.id!,
                time: DateTime.parse(act.provideTime!),
                type: ActivityType(1),
                product: Product(
                    id: 0,
                    name: supply
                        .name!,
                    imgUrl:  supply.photo?.url ?? "",
                    note: act.description != null
                        ? act.description!
                        : 'Không có chú thích'),
                pet: pet,
                imgUrl: act.photo!.isNotEmpty ? act.photo!.first.url : null));
          }
        }
      }
    }
    return SUPPLY_ACTS;
  }

  List<Activity> getServiceActivities() {
    List<Activity> SERVICE_ACTS = [];
    for (var act in this.bookingActivities!) {
      if (act.serviceId != null && act.provideTime != null) {
        for (var pet in getPets()) {
          if (pet.id == act.petId) {
             Service service = 
                        serviceOrders!
                        .where((e) => e.serviceId == act.serviceId)
                        .first
                        .service!;
            SERVICE_ACTS.add(Activity(
                id: act.id!,
                time: DateTime.parse(act.provideTime!),
                type: ActivityType(2),
                product: Product(
                    id: 0,
                    name: service
                        .description!,
                    imgUrl: service.photo?.url ?? "",
                    note: act.description != null
                        ? act.description!
                        : 'Không có chú thích'),
                pet: pet,
                imgUrl: act.photo!.isNotEmpty ? act.photo!.first.url : null));
          }
        }
      }
    }
    return SERVICE_ACTS;
  }

  List<Activity> getAllActivities() {
    List<Activity> list = getFeedActivities();
    list.addAll(getServiceActivities());
    list.addAll(getSupplyActivities());
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  List<List<Pet>> idsToPetRequest(List<Pet> customerPets) {
    List<List<Pet>> requests = [];
    List<List<int>> petIds = bookingDetails!.map((e) => e.getPetIds()).toList();

    for (var petid in petIds) {
      List<Pet> request = [];
      for (var id in petid) {
        for (var pet in customerPets) {
          if (pet.id == id) {
            request.add(pet);
          }
        }
      }
      requests.add(request);
    }
    return requests;
  }
}

class BookingDetail {
  BookingDetail(
      {this.bookingId,
      this.id,
      this.price,
      this.duration,
      this.petBookingDetails,
      this.cageCode,
      this.cage});

  int? bookingId;
  int? id;
  double? price;
  double? duration;
  String? cageCode;
  List<PetBookingDetail>? petBookingDetails;
  Cage? cage;

  factory BookingDetail.fromRawJson(String str) =>
      BookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDetail.fromJson(Map<String, dynamic> json) => BookingDetail(
      bookingId: json["bookingId"],
      id: json["id"],
      price: json["price"].toDouble(),
      duration: json["duration"].toDouble(),
      petBookingDetails: List<PetBookingDetail>.from(
          json["petBookingDetails"].map((x) => PetBookingDetail.fromJson(x))),
      cageCode: json["cageCode"],
      cage: Cage.fromJson(json["c"]));

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "id": id,
        "price": price,
        "duration": duration,
        "cageCode": cageCode,
        "petBookingDetails": List<PetBookingDetail>.from(
            petBookingDetails!.map((x) => x.toJson())),
        "c": cage!.toJson()
      };
  List<Pet> getPets() {
    List<Pet> pets = [];
    this.petBookingDetails!.forEach((element) {
      pets.add(element.pet!);
    });
    return pets;
  }

  List<int> getPetIds() {
    List<int> pets = [];
    this.petBookingDetails!.forEach((element) {
      pets.add(element.pet!.id!);
    });
    return pets;
  }
}

class Cage {
  Cage({this.cageType, this.name});

  CageType? cageType;
  String? name;
  factory Cage.fromRawJson(String str) => Cage.fromJson(json.decode(str));

  factory Cage.fromJson(Map<String, dynamic> json) =>
      Cage(cageType: CageType.fromJson(json["cageType"]), name: json["name"]);

  Map<String, dynamic> toJson() =>
      {"cageType": cageType!.toJson(), "name": name};

  String toRawJson() => json.encode(toJson());
}

class CageType {
  CageType({this.id, this.typeName, this.photo});

  int? id;
  String? typeName;
  Photo? photo;
  factory CageType.fromRawJson(String str) =>
      CageType.fromJson(json.decode(str));

  factory CageType.fromJson(Map<String, dynamic> json) => CageType(
      id: json["id"],
      typeName: json["typeName"],
      photo: json["photos"].first != null
          ? Photo.fromJson(json["photos"].first)
          : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "typeName": typeName,
        "photos": [photo!.toJson()]
      };

  String toRawJson() => json.encode(toJson());
}

class PetBookingDetail {
  PetBookingDetail({
    this.bookingDetailId,
    this.pet,
  });

  int? bookingDetailId;
  Pet? pet;

  factory PetBookingDetail.fromRawJson(String str) =>
      PetBookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PetBookingDetail.fromJson(Map<String, dynamic> json) =>
      PetBookingDetail(
        bookingDetailId: json["bookingDetailId"],
        pet: Pet.fromJson(json["pet"]),
      );

  Map<String, dynamic> toJson() => {
        "bookingDetailId": bookingDetailId,
        "pet": pet!.toJson(),
      };
}

class ServiceOrder {
  ServiceOrder(
      {this.serviceId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.petId,
      this.service,
      this.note});

  int? serviceId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  int? petId;
  Service? service;
  String? note;

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
      note: json['note']);

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "quantity": quantity,
        "sellPrice": sellPrice,
        "totalPrice": totalPrice,
        "petId": petId,
        "service": service!.toJson(),
        "note": note
      };
}

class Service {
  Service({
    this.id,
    this.description,
    this.discountPrice,
    this.photo
  });

  int? id;
  String? description;
  double? discountPrice;
  Photo? photo;

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        description: json["description"],
        discountPrice: json["discountPrice"] != null
            ? json["discountPrice"].toDouble()
            : 0,
        photo: json["photos"].toString() != "[]" ? Photo.fromJson(json["photos"].last) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "discountPrice": discountPrice,
      };
}

class SupplyOrder {
  SupplyOrder(
      {this.supplyId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.petId,
      this.supply,
      this.note});

  int? supplyId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  int? petId;
  Supply? supply;
  String? note;

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
      note: json["note"]);

  Map<String, dynamic> toJson() => {
        "supplyId": supplyId,
        "quantity": quantity,
        "sellPrice": sellPrice,
        "totalPrice": totalPrice,
        "petId": petId,
        "supply": supply!.toJson(),
        "note": note
      };
}

class Supply {
  Supply({
    this.id,
    this.name,
    this.discountPrice,
    this.photo
  });

  int? id;
  String? name;
  double? discountPrice;
  Photo? photo;

  factory Supply.fromRawJson(String str) => Supply.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Supply.fromJson(Map<String, dynamic> json) => Supply(
        id: json["id"],
        name: json["name"],
        discountPrice: json["discountPrice"] != null
            ? json["discountPrice"].toDouble()
            : 0,
            photo: (json["photos"].toString() != "[]")? Photo.fromJson(json["photos"].last):null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "discountPrice": discountPrice,
        "photos": [photo!.toJson()]
      };
}

class BookingActivities {
  int? id;
  String? provideTime;
  String? description;
  int? bookingId;
  int? bookingDetailId;
  int? petId;
  int? supplyId;
  int? serviceId;
  Pet? pet;
  Service? service;
  Supply? supply;
  List<Photo>? photo;
  String? activityTimeFrom;
  String? activityTimeTo;
  bool? isOnTime;

  BookingActivities(
      {this.id,
      this.provideTime,
      this.description,
      this.bookingId,
      this.bookingDetailId,
      this.petId,
      this.supplyId,
      this.serviceId,
      this.pet,
      this.service,
      this.supply,
      this.photo,
      this.activityTimeFrom,
      this.activityTimeTo,
      this.isOnTime});

  BookingActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provideTime = json['provideTime'];
    description = json['description'];
    bookingId = json['bookingId'];
    bookingDetailId = json['bookingDetailId'];
    petId = json['petId'];
    supplyId = json['supplyId'];
    serviceId = json['serviceId'];
    pet = json['pet'] != null ? Pet.fromJson(json['pet']) : null;
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    supply = json['supply'] != null ? Supply.fromJson(json['supply']) : null;
    photo = json['photos'] != null
        ? List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x)))
        : null;
    activityTimeFrom = json['activityTimeFrom'];
    activityTimeTo = json['activityTimeTo'];
    isOnTime = json['isOnTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provideTime'] = this.provideTime;
    data['description'] = this.description;
    data['bookingId'] = this.bookingId;
    data['bookingDetailId'] = this.bookingDetailId;
    data['petId'] = this.petId;
    data['supplyId'] = this.supplyId;
    data['serviceId'] = this.serviceId;
    data['pet'] = this.pet;
    data['service'] = this.service;
    data['supply'] = this.supply;
    data['photos'] = this.photo;
    data['activityTimeFrom'] = this.activityTimeFrom;
    data['activityTimeTo'] = this.activityTimeTo;
    data['isOnTime'] = this.isOnTime;

    // if (this.photos != null) {
    //   data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Photo {
  int? photoTypeId;
  int? idActor;
  int? line;
  String? url;
  bool? isThumbnail;
  bool? status;
  Null? photoType;

  Photo(
      {this.photoTypeId,
      this.idActor,
      this.line,
      this.url,
      this.isThumbnail,
      this.status,
      this.photoType});

  Photo.fromJson(Map<String, dynamic> json) {
    photoTypeId = json['photoTypeId'];
    idActor = json['idActor'];
    line = json['line'];
    url = json['url'];
    isThumbnail = json['isThumbnail'];
    status = json['status'];
    photoType = json['photoType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoTypeId'] = this.photoTypeId;
    data['idActor'] = this.idActor;
    data['line'] = this.line;
    data['url'] = this.url;
    data['isThumbnail'] = this.isThumbnail;
    data['status'] = this.status;
    data['photoType'] = this.photoType;
    return data;
  }
}
