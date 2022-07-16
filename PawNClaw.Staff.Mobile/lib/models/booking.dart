import 'booking_detail.dart';
import 'pet.dart';
import 'package:intl/intl.dart';

class Booking {
  int? id;
  // int? subTotal;
  // Null? discount;
  // int? total;
  // Null? checkIn;
  // Null? checkOut;
  // String? createTime;
  DateTime? startBooking;
  DateTime? endBooking;
  // int? statusId;
  // Null? voucherCode;
  // int? customerId;
  // int? centerId;
  // Null? rating;
  // Null? customerNote;
  // String? staffNote;
  // Null? center;
  Customer? customer;
  double? totalSupply;
  double? totalService;
  // Null? status;
  // Null? voucherCodeNavigation;
  // Null? generalLedger;
  List<BookingDetails>? bookingDetails;
  // List<Null>? petHealthHistories;
  // List<Null>? serviceOrders;
  // List<Null>? supplyOrders;

  Booking({
    this.id,
    // this.subTotal,
    // this.discount,
    // this.total,
    // this.checkIn,
    // this.checkOut,
    // this.createTime,
    this.startBooking,
    this.endBooking,
    // this.statusId,
    // this.voucherCode,
    // this.customerId,
    // this.centerId,
    // this.rating,
    // this.customerNote,
    // this.staffNote,
    // this.center,
    this.customer,
    this.totalSupply,
    this.totalService,
    // this.status,
    // this.voucherCodeNavigation,
    // this.generalLedger,
    this.bookingDetails,
    // this.petHealthHistories,
    // this.serviceOrders,
    // this.supplyOrders
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // subTotal = json['subTotal'];
    // discount = json['discount'];
    // total = json['total'];
    // checkIn = json['checkIn'];
    // checkOut = json['checkOut'];
    // createTime = json['createTime'];
    startBooking = DateTime.parse(json['startBooking']);
    endBooking = DateTime.parse(json['endBooking']);
    // statusId = json['statusId'];
    // voucherCode = json['voucherCode'];
    // customerId = json['customerId'];
    // centerId = json['centerId'];
    // rating = json['rating'];
    // customerNote = json['customerNote'];
    // staffNote = json['staffNote'];
    // center = json['center'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    totalSupply = json['totalSupply'];
    totalService = json['totalService'];
    // status = json['status'];
    // voucherCodeNavigation = json['voucherCodeNavigation'];
    // generalLedger = json['generalLedger'];
    if (json['bookingDetails'] != null) {
      bookingDetails = <BookingDetails>[];
      json['bookingDetails'].forEach((v) {
        bookingDetails!.add(new BookingDetails.fromJson(v));
      });
    }
    // if (json['petHealthHistories'] != null) {
    //   petHealthHistories = <Null>[];
    //   json['petHealthHistories'].forEach((v) {
    //     petHealthHistories!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['serviceOrders'] != null) {
    //   serviceOrders = <Null>[];
    //   json['serviceOrders'].forEach((v) {
    //     serviceOrders!.add(new Null.fromJson(v));
    //   });
    // }
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
    // data['subTotal'] = this.subTotal;
    // data['discount'] = this.discount;
    // data['total'] = this.total;
    // data['checkIn'] = this.checkIn;
    // data['checkOut'] = this.checkOut;
    // data['createTime'] = this.createTime;
    data['startBooking'] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(this.startBooking!);
    data['endBooking'] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(this.endBooking!);
    // data['statusId'] = this.statusId;
    // data['voucherCode'] = this.voucherCode;
    // data['customerId'] = this.customerId;
    // data['centerId'] = this.centerId;
    // data['rating'] = this.rating;
    // data['customerNote'] = this.customerNote;
    // data['staffNote'] = this.staffNote;
    // data['center'] = this.center;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    // data['status'] = this.status;
    // data['voucherCodeNavigation'] = this.voucherCodeNavigation;
    // data['generalLedger'] = this.generalLedger;
    if (this.bookingDetails != null) {
      data['bookingDetails'] =
          this.bookingDetails!.map((v) => v.toJson()).toList();
    }
    // if (this.petHealthHistories != null) {
    //   data['petHealthHistories'] =
    //       this.petHealthHistories!.map((v) => v.toJson()).toList();
    // }
    // if (this.serviceOrders != null) {
    //   data['serviceOrders'] =
    //       this.serviceOrders!.map((v) => v.toJson()).toList();
    // }
    // if (this.supplyOrders != null) {
    //   data['supplyOrders'] = this.supplyOrders!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  // String? birth;
  // Null? gender;
  // Null? idNavigation;
  // List<Null>? bookings;
  // List<Null>? customerAddresses;
  // List<Null>? pets;

  Customer({
    this.id,
    this.name,
    // this.birth,
    // this.gender,
    // this.idNavigation,
    // this.bookings,
    // this.customerAddresses,
    // this.pets
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // birth = json['birth'];
    // gender = json['gender'];
    // idNavigation = json['idNavigation'];
    // if (json['bookings'] != null) {
    //   bookings = <Null>[];
    //   json['bookings'].forEach((v) {
    //     bookings!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['customerAddresses'] != null) {
    //   customerAddresses = <Null>[];
    //   json['customerAddresses'].forEach((v) {
    //     customerAddresses!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['pets'] != null) {
    //   pets = <Null>[];
    //   json['pets'].forEach((v) {
    //     pets!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    // data['birth'] = this.birth;
    // data['gender'] = this.gender;
    // data['idNavigation'] = this.idNavigation;
    // if (this.bookings != null) {
    //   data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    // }
    // if (this.customerAddresses != null) {
    //   data['customerAddresses'] =
    //       this.customerAddresses!.map((v) => v.toJson()).toList();
    // }
    // if (this.pets != null) {
    //   data['pets'] = this.pets!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
