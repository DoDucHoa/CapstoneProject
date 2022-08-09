import 'pet.dart';
import 'package:intl/intl.dart';

class BookingDetail {
  int? id;
  DateTime? startBooking;
  DateTime? endBooking;
  String? customerNote;
  String? staffNote;
  Customer? customer;
  int? centerId;
  List<BookingDetails>? bookingDetails;
  List<ServiceOrders>? serviceOrders;
  List<SupplyOrders>? supplyOrders;
  List<BookingActivities>? bookingActivities;
  double? totalSupply;
  double? totalService;

  BookingDetail(
      {this.id,
      this.startBooking,
      this.endBooking,
      this.customerNote,
      this.staffNote,
      this.customer,
      this.centerId,
      this.bookingDetails,
      this.serviceOrders,
      this.supplyOrders,
      this.bookingActivities,
      this.totalService,
      this.totalSupply});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startBooking = DateTime.parse(json['startBooking']);
    endBooking = DateTime.parse(json['endBooking']);
    customerNote = json['customerNote'];
    staffNote = json['staffNote'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    centerId = json['centerId'];
    totalSupply = json['totalSupply'];
    totalService = json['totalService'];
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
    } else
      serviceOrders = [];
    if (json['supplyOrders'] != null) {
      supplyOrders = <SupplyOrders>[];
      json['supplyOrders'].forEach((v) {
        supplyOrders!.add(new SupplyOrders.fromJson(v));
      });
    } else
      supplyOrders = [];
    if (json['bookingActivities'] != null) {
      bookingActivities = <BookingActivities>[];
      json['bookingActivities'].forEach((v) {
        bookingActivities!.add(new BookingActivities.fromJson(v));
      });
    } else
      bookingActivities = [];
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
    if (this.bookingActivities != null) {
      data['bookingActivities'] =
          this.bookingActivities!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<String> getAllStartTime() {
    List<String> times = [];
    this.bookingDetails!.forEach((element) {
      element.foodSchedules!.forEach((element) {
        times.add(element.fromTime!);
      });
    });
    return times.toSet().toList();
  }

  List<BookingDetails> getUndoneFeedingAct() {
    List<BookingDetails> undone = [];
    this.bookingActivities!.forEach((activity) {
      // booking.bookingActivities?.forEach((element) {
      //   if (element.provideTime == null) {
      //     undone.add(booking);
      //   }
      // });
      if (activity.bookingDetailId != null && activity.provideTime == null) {
        this.bookingDetails!.forEach((detail) {
          if (detail.id == activity.bookingDetailId) {
            undone.add(detail);
          }
        });
      }
    });
    undone.toSet().toList();
    return undone;
  }

  List<BookingActivities> getUndoneActivities() {
    return this
        .bookingActivities!
        .where((element) => element.provideTime == null)
        .toList();
  }

  int getSupplyActivities() {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.supplyId != null) {
        count++;
      }
    });

    return count;
  }

  int getServiceActivities() {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.serviceId != null) {
        count++;
      }
    });
    return count;
  }

  int getTotalActivities() {
    return this.bookingActivities!.length;
  }

  List<SupplyOrders> getUndoneSupplyAct() {
    List<SupplyOrders> undone = [];
    this.bookingActivities!.forEach((element) {
      if (element.supplyId != null && element.provideTime == null) {
        this.supplyOrders?.forEach((supply) {
          if (element.petId == supply.petId) {
            undone.add(supply);
          }
        });
      }
    });
    return undone;
  }

  List<SupplyOrders> getDoneSupplyAct() {
    List<SupplyOrders> done = [];
    this.bookingActivities!.forEach((element) {
      if (element.supplyId != null && element.provideTime != null) {
        this.supplyOrders?.forEach((supply) {
          if (element.petId == supply.petId) {
            done.add(supply);
          }
        });
      }
    });
    return done;
  }

  int getRemainSupplyAct(SupplyOrders supply) {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.supplyId == supply.supply!.id &&
          element.provideTime == null) {
        count++;
      }
    });
    return count;
  }

  int getRemainServiceAct(ServiceOrders service) {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.serviceId == service.service!.id &&
          element.provideTime == null) {
        count++;
      }
    });
    return count;
  }

  int getRemainFeedingAct() {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.bookingDetailId != null && element.provideTime == null) {
        count++;
      }
    });
    return count;
  }

  List<ServiceOrders> getUndoneServiceAct() {
    List<ServiceOrders> undone = [];
    this.bookingActivities!.forEach((element) {
      if (element.serviceId != null && element.provideTime == null) {
        this.serviceOrders?.forEach((service) {
          if (element.petId == service.petId) {
            undone.add(service);
          }
        });
      }
    });
    return undone;
  }

  List<ServiceOrders> getDoneServiceAct() {
    List<ServiceOrders> done = [];
    this.bookingActivities!.forEach((element) {
      if (element.serviceId != null && element.provideTime != null) {
        this.serviceOrders?.forEach((service) {
          if (element.petId == service.petId) {
            done.add(service);
          }
        });
      }
    });
    return done;
  }

  int getDoneActivites() {
    int count = 0;
    this.bookingActivities!.forEach((element) {
      if (element.provideTime != null) {
        count++;
      }
    });
    return count;
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
  int? bookingId;
  int? id;
  double? price;
  String? cageCode;
  // int? centerId;
  double? duration;
  // Null? note;
  // Null? booking;
  // Cage? c;
  List<BookingActivities>? bookingActivities;
  List<PetBookingDetails>? petBookingDetails;
  List<FoodSchedules>? foodSchedules;
  String? cageType;

  BookingDetails(
      {this.bookingId,
      this.id,
      this.price,
      this.cageCode,
      // this.centerId,
      this.duration,
      // this.note,
      // this.booking,
      // this.c,
      this.bookingActivities,
      this.petBookingDetails,
      this.foodSchedules,
      this.cageType});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    id = json['id'];
    price = json['price'];
    cageCode = json['cageCode'];
    // centerId = json['centerId'];
    duration = json['duration'];
    // note = json['note'];
    // booking = json['booking'];
    // c = json['c'];
    if (json['bookingActivities'] != null) {
      bookingActivities = <BookingActivities>[];
      json['bookingActivities'].forEach((v) {
        bookingActivities!.add(new BookingActivities.fromJson(v));
      });
    }
    if (json['petBookingDetails'] != null) {
      petBookingDetails = <PetBookingDetails>[];
      json['petBookingDetails'].forEach((v) {
        petBookingDetails!.add(new PetBookingDetails.fromJson(v));
      });
    }
    if (json['foodSchedules'] != null) {
      foodSchedules = <FoodSchedules>[];
      json['foodSchedules'].forEach((v) {
        foodSchedules!.add(new FoodSchedules.fromJson(v));
      });
    }
    cageType = json['cageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['bookingId'] = this.bookingId;
    data['id'] = this.id;
    data['price'] = this.price;
    data['cageCode'] = this.cageCode;
    // data['centerId'] = this.centerId;
    data['duration'] = this.duration;
    // data['note'] = this.note;
    // data['booking'] = this.booking;
    // data['c'] = this.c;
    if (this.bookingActivities != null) {
      data['bookingActivities'] =
          this.bookingActivities!.map((v) => v.toJson()).toList();
    }
    if (this.petBookingDetails != null) {
      data['petBookingDetails'] =
          this.petBookingDetails!.map((v) => v.toJson()).toList();
    }
    if (this.foodSchedules != null) {
      data['foodSchedules'] =
          this.foodSchedules!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // List<BookingActivities> getUndoneActivities() {
  //   return this
  //       .bookingActivities!
  //       .where((element) => element.provideTime == null)
  //       .toList();
  // }
}

class FoodSchedules {
  int? id;
  String? fromTime;
  String? toTime;
  String? name;
  int? cageTypeId;
  // Null? cageType;

  FoodSchedules({
    this.id,
    this.fromTime,
    this.toTime,
    this.name,
    this.cageTypeId,
    // this.cageType
  });

  FoodSchedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromTime = json['fromTime'];
    toTime = json['toTime'];
    name = json['name'];
    cageTypeId = json['cageTypeId'];
    // cageType = json['cageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['name'] = this.name;
    data['cageTypeId'] = this.cageTypeId;
    // data['cageType'] = this.cageType;
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
  int? bookingId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  int? petId;
  // Null? booking;
  Pet? pet;
  Service? service;

  ServiceOrders(
      {
      // this.serviceId,
      this.bookingId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      this.petId,
      // this.booking,
      this.pet,
      this.service});

  ServiceOrders.fromJson(Map<String, dynamic> json) {
    // serviceId = json['serviceId'];
    bookingId = json['bookingId'];
    quantity = json['quantity'];
    sellPrice = json['sellPrice'];
    totalPrice = json['totalPrice'];
    note = json['note'];
    petId = json['petId'];
    // booking = json['booking'];
    pet = json['pet'] != null ? new Pet.fromJson(json['pet']) : null;
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['serviceId'] = this.serviceId;
    data['bookingId'] = this.bookingId;
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
  int? bookingId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  int? petId;
  // Null? booking;
  Pet? pet;
  Supply? supply;

  SupplyOrders(
      {
      //   this.supplyId,
      this.bookingId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      this.petId,
      // this.booking,
      this.pet,
      this.supply});

  SupplyOrders.fromJson(Map<String, dynamic> json) {
    // supplyId = json['supplyId'];
    bookingId = json['bookingId'];
    quantity = json['quantity'];
    sellPrice = json['sellPrice'];
    totalPrice = json['totalPrice'];
    note = json['note'];
    petId = json['petId'];
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

class BookingActivities {
  int? id;
  String? provideTime;
  String? description;
  int? bookingId;
  int? bookingDetailId;
  int? petId;
  int? supplyId;
  int? serviceId;
  DateTime? activityTimeFrom;
  DateTime? activityTimeTo;
  bool? isOnTime;
  Pet? pet;
  Service? service;
  Supply? supply;

  // List<Null>? photos;

  BookingActivities({
    this.id,
    this.provideTime,
    this.description,
    this.bookingId,
    this.bookingDetailId,
    this.petId,
    this.supplyId,
    this.serviceId,
    this.activityTimeFrom,
    this.activityTimeTo,
    this.isOnTime,
    this.pet,
    this.service,
    this.supply,
    // this.photos
  });

  BookingActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provideTime = json['provideTime'];
    description = json['description'];
    bookingId = json['bookingId'];
    bookingDetailId = json['bookingDetailId'];
    petId = json['petId'];
    supplyId = json['supplyId'];
    serviceId = json['serviceId'];
    activityTimeFrom = DateTime.tryParse(json['activityTimeFrom']);
    activityTimeTo = DateTime.tryParse(json['activityTimeTo']);
    isOnTime = json['isOnTime'];
    pet = json['pet'] != null ? Pet.fromJson(json['pet']) : null;
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    supply = json['supply'] != null ? Supply.fromJson(json['supply']) : null;
    // if (json['photos'] != null) {
    //   photos = <Null>[];
    //   json['photos'].forEach((v) {
    //     photos!.add(new Null.fromJson(v));
    //   });
    // }
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
    data['activityTimeFrom'] = this.activityTimeFrom;
    data['activityTimeTo'] = this.activityTimeTo;
    data['isOnTime'] = this.isOnTime;
    data['pet'] = this.pet;
    data['service'] = this.service;
    data['supply'] = this.supply;
    // if (this.photos != null) {
    //   data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
