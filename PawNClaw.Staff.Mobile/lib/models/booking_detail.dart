import 'pet.dart';

class BookingDetail {
  int? id;
  DateTime? startBooking;
  DateTime? endBooking;
  String? customerNote;
  String? staffNote;
  Customer? customer;
  List<BookingDetails>? bookingDetails;
  List<ServiceOrders>? serviceOrders;
  List<SupplyOrders>? supplyOrders;

  BookingDetail(
      {this.id,
      this.startBooking,
      this.endBooking,
      this.customerNote,
      this.staffNote,
      this.customer,
      this.bookingDetails,
      this.serviceOrders,
      this.supplyOrders});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startBooking = DateTime.parse(json['startBooking']);
    endBooking = DateTime.parse(json['endBooking']);
    customerNote = json['customerNote'];
    staffNote = json['staffNote'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['bookingDetails'] != null) {
      bookingDetails = <BookingDetails>[];
      json['bookingDetails'].forEach((v) {
        bookingDetails!.add(new BookingDetails.fromJson(v));
      });
    }
    if (json['serviceOrders'] != null) {
      serviceOrders = <ServiceOrders>[];
      json['serviceOrders'].forEach((v) {
        serviceOrders!.add(new ServiceOrders.fromJson(v));
      });
    }
    if (json['supplyOrders'] != null) {
      supplyOrders = <SupplyOrders>[];
      json['supplyOrders'].forEach((v) {
        supplyOrders!.add(new SupplyOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startBooking'] = this.startBooking;
    data['endBooking'] = this.endBooking;
    data['customerNote'] = this.customerNote;
    data['staffNote'] = this.staffNote;
    if (this.bookingDetails != null) {
      data['bookingDetails'] =
          this.bookingDetails!.map((v) => v.toJson()).toList();
    }
    if (this.serviceOrders != null) {
      data['serviceOrders'] =
          this.serviceOrders!.map((v) => v.toJson()).toList();
    }
    if (this.supplyOrders != null) {
      data['supplyOrders'] = this.supplyOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  IdNavigation? idNavigation;

  Customer({this.id, this.name, this.idNavigation});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    idNavigation = json['idNavigation'] != null
        ? new IdNavigation.fromJson(json['idNavigation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.idNavigation != null) {
      data['idNavigation'] = this.idNavigation!.toJson();
    }
    return data;
  }
}

class IdNavigation {
  int? id;
  String? phone;

  IdNavigation({this.id, this.phone});

  IdNavigation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    return data;
  }
}

class BookingDetails {
  // int? bookingId;
  int? line;
  double? price;
  String? cageCode;
  // int? centerId;
  double? duration;
  // Null? note;
  // Null? booking;
  // Null? c;
  List<PetBookingDetails>? petBookingDetails;

  BookingDetails(
      {
      // this.bookingId,
      this.line,
      this.price,
      this.cageCode,
      // this.centerId,
      this.duration,
      // this.note,
      // this.booking,
      // this.c,
      this.petBookingDetails});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    // bookingId = json['bookingId'];
    line = json['line'];
    price = json['price'];
    cageCode = json['cageCode'];
    // centerId = json['centerId'];
    duration = json['duration'];
    // note = json['note'];
    // booking = json['booking'];
    // c = json['c'];
    if (json['petBookingDetails'] != null) {
      petBookingDetails = <PetBookingDetails>[];
      json['petBookingDetails'].forEach((v) {
        petBookingDetails!.add(new PetBookingDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['bookingId'] = this.bookingId;
    data['line'] = this.line;
    data['price'] = this.price;
    data['cageCode'] = this.cageCode;
    // data['centerId'] = this.centerId;
    data['duration'] = this.duration;
    // data['note'] = this.note;
    // data['booking'] = this.booking;
    // data['c'] = this.c;
    if (this.petBookingDetails != null) {
      data['petBookingDetails'] =
          this.petBookingDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PetBookingDetails {
  // int? bookingId;
  int? line;
  // int? petId;
  // Null? bookingDetail;
  Pet? pet;

  PetBookingDetails({
    // this.bookingId,
    this.line,
    // this.petId,
    // this.bookingDetail,
    this.pet,
  });

  PetBookingDetails.fromJson(Map<String, dynamic> json) {
    // bookingId = json['bookingId'];
    line = json['line'];
    // petId = json['petId'];
    // bookingDetail = json['bookingDetail'];
    pet = json['pet'] != null ? new Pet.fromJson(json['pet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['bookingId'] = this.bookingId;
    data['line'] = this.line;
    // data['petId'] = this.petId;
    // data['bookingDetail'] = this.bookingDetail;
    if (this.pet != null) {
      data['pet'] = this.pet!.toJson();
    }
    return data;
  }
}

class ServiceOrders {
  // int? serviceId;
  // int? bookingId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  // int? petId;
  // Null? booking;
  Pet? pet;
  Service? service;

  ServiceOrders(
      {
      // this.serviceId,
      // this.bookingId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      // this.petId,
      // this.booking,
      this.pet,
      this.service});

  ServiceOrders.fromJson(Map<String, dynamic> json) {
    // serviceId = json['serviceId'];
    // bookingId = json['bookingId'];
    quantity = json['quantity'];
    sellPrice = json['sellPrice'];
    totalPrice = json['totalPrice'];
    note = json['note'];
    // petId = json['petId'];
    // booking = json['booking'];
    pet = json['pet'] != null ? new Pet.fromJson(json['pet']) : null;
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['serviceId'] = this.serviceId;
    // data['bookingId'] = this.bookingId;
    data['quantity'] = this.quantity;
    data['sellPrice'] = this.sellPrice;
    data['totalPrice'] = this.totalPrice;
    data['note'] = this.note;
    // data['petId'] = this.petId;
    // data['booking'] = this.booking;
    if (this.pet != null) {
      data['pet'] = this.pet!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  String? description;
  double? sellPrice;
  double? discountPrice;
  // String? createDate;
  // String? modifyDate;
  // int? createUser;
  // int? modifyUser;
  // bool? status;
  // int? centerId;
  // Null? center;
  // Null? createUserNavigation;
  // Null? modifyUserNavigation;
  // List<Null>? serviceOrders;
  // List<Null>? servicePrices;

  Service({
    this.id,
    this.description,
    this.sellPrice,
    this.discountPrice,
    // this.createDate,
    // this.modifyDate,
    // this.createUser,
    // this.modifyUser,
    // this.status,
    // this.centerId,
    // this.center,
    // this.createUserNavigation,
    // this.modifyUserNavigation,
    // this.serviceOrders,
    // this.servicePrices
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    sellPrice = json['sellPrice'];
    discountPrice = json['discountPrice'];
    // // createDate = json['createDate'];
    // // modifyDate = json['modifyDate'];
    // // createUser = json['createUser'];
    // // modifyUser = json['modifyUser'];
    // // status = json['status'];
    // // centerId = json['centerId'];
    // // center = json['center'];
    // // createUserNavigation = json['createUserNavigation'];
    // // modifyUserNavigation = json['modifyUserNavigation'];
    // if (json['serviceOrders'] != null) {
    //   serviceOrders = <Null>[];
    //   json['serviceOrders'].forEach((v) {
    //     serviceOrders!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['servicePrices'] != null) {
    //   servicePrices = <Null>[];
    //   json['servicePrices'].forEach((v) {
    //     servicePrices!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['sellPrice'] = this.sellPrice;
    data['discountPrice'] = this.discountPrice;
    // data['createDate'] = this.createDate;
    // data['modifyDate'] = this.modifyDate;
    // data['createUser'] = this.createUser;
    // data['modifyUser'] = this.modifyUser;
    // data['status'] = this.status;
    // data['centerId'] = this.centerId;
    // data['center'] = this.center;
    // data['createUserNavigation'] = this.createUserNavigation;
    // data['modifyUserNavigation'] = this.modifyUserNavigation;
    // if (this.serviceOrders != null) {
    //   data['serviceOrders'] =
    //       this.serviceOrders!.map((v) => v.toJson()).toList();
    // }
    // if (this.servicePrices != null) {
    //   data['servicePrices'] =
    //       this.servicePrices!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class SupplyOrders {
  // int? supplyId;
  // int? bookingId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  // int? petId;
  // Null? booking;
  Pet? pet;
  Supply? supply;

  SupplyOrders(
      {
      //   this.supplyId,
      // this.bookingId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      // this.petId,
      // this.booking,
      this.pet,
      this.supply});

  SupplyOrders.fromJson(Map<String, dynamic> json) {
    // supplyId = json['supplyId'];
    // bookingId = json['bookingId'];
    quantity = json['quantity'];
    sellPrice = json['sellPrice'];
    totalPrice = json['totalPrice'];
    note = json['note'];
    // petId = json['petId'];
    // booking = json['booking'];
    pet = json['pet'] != null ? new Pet.fromJson(json['pet']) : null;
    supply =
        json['supply'] != null ? new Supply.fromJson(json['supply']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['supplyId'] = this.supplyId;
    // data['bookingId'] = this.bookingId;
    data['quantity'] = this.quantity;
    data['sellPrice'] = this.sellPrice;
    data['totalPrice'] = this.totalPrice;
    data['note'] = this.note;
    // data['petId'] = this.petId;
    // data['booking'] = this.booking;
    if (this.pet != null) {
      data['pet'] = this.pet!.toJson();
    }
    if (this.supply != null) {
      data['supply'] = this.supply!.toJson();
    }
    return data;
  }
}

class Supply {
  int? id;
  String? name;
  double? sellPrice;
  double? discountPrice;
  int? quantity;
  // String? createDate;
  // String? modifyDate;
  // int? createUser;
  // int? modifyUser;
  // bool? status;
  // String? supplyTypeCode;
  // int? centerId;
  // Null? center;
  // Null? createUserNavigation;
  // Null? modifyUserNavigation;
  // Null? supplyTypeCodeNavigation;
  // List<Null>? supplyOrders;

  Supply({
    this.id,
    this.name,
    this.sellPrice,
    this.discountPrice,
    this.quantity,
    // this.createDate,
    // this.modifyDate,
    // this.createUser,
    // this.modifyUser,
    // this.status,
    // this.supplyTypeCode,
    // this.centerId,
    // this.center,
    // this.createUserNavigation,
    // this.modifyUserNavigation,
    // this.supplyTypeCodeNavigation,
    // this.supplyOrders
  });

  Supply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sellPrice = json['sellPrice'];
    discountPrice = json['discountPrice'];
    quantity = json['quantity'];
    // createDate = json['createDate'];
    // modifyDate = json['modifyDate'];
    // createUser = json['createUser'];
    // modifyUser = json['modifyUser'];
    // status = json['status'];
    // supplyTypeCode = json['supplyTypeCode'];
    // centerId = json['centerId'];
    // center = json['center'];
    // createUserNavigation = json['createUserNavigation'];
    // modifyUserNavigation = json['modifyUserNavigation'];
    // supplyTypeCodeNavigation = json['supplyTypeCodeNavigation'];
    // if (json['supplyOrders'] != null) {
    //   supplyOrders = <Null>[];
    //   json['supplyOrders'].forEach((v) {
    //     supplyOrders!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sellPrice'] = this.sellPrice;
    data['discountPrice'] = this.discountPrice;
    data['quantity'] = this.quantity;
    // data['createDate'] = this.createDate;
    // data['modifyDate'] = this.modifyDate;
    // data['createUser'] = this.createUser;
    // data['modifyUser'] = this.modifyUser;
    // data['status'] = this.status;
    // data['supplyTypeCode'] = this.supplyTypeCode;
    // data['centerId'] = this.centerId;
    // data['center'] = this.center;
    // data['createUserNavigation'] = this.createUserNavigation;
    // data['modifyUserNavigation'] = this.modifyUserNavigation;
    // data['supplyTypeCodeNavigation'] = this.supplyTypeCodeNavigation;
    // if (this.supplyOrders != null) {
    //   data['supplyOrders'] = this.supplyOrders!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
