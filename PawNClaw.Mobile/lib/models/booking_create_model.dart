import 'dart:convert';

import 'package:pawnclaw_mobile_application/models/voucher.dart';

class BookingRequestModel {
  BookingCreateParameter? bookingCreateParameter;
  List<BookingDetailCreateParameters>? bookingDetailCreateParameters;
  List<ServiceOrderCreateParameters>? serviceOrderCreateParameters;
  List<SupplyOrderCreateParameters>? supplyOrderCreateParameters;
  List<int>? selectedPetsIds;
  String? voucherCode;

  BookingRequestModel(
      {this.bookingCreateParameter,
      this.bookingDetailCreateParameters,
      this.serviceOrderCreateParameters,
      this.supplyOrderCreateParameters,
      this.selectedPetsIds,
      this.voucherCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingCreateParameter != null) {
      data['bookingCreateParameter'] = this.bookingCreateParameter!.toJson();
    }
    if (this.bookingDetailCreateParameters != null) {
      data['bookingDetailCreateParameters'] =
          this.bookingDetailCreateParameters!.map((v) => v.toJson()).toList();
    }
    if (this.serviceOrderCreateParameters != null) {
      data['serviceOrderCreateParameters'] =
          this.serviceOrderCreateParameters!.map((v) => v.toJson()).toList();
    }
    if (this.supplyOrderCreateParameters != null) {
      data['supplyOrderCreateParameters'] =
          this.supplyOrderCreateParameters!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toRawJson() => json.encode(toJson());

  double getTotalSupply() {
    double total = 0;
    this.supplyOrderCreateParameters!.forEach((element) {
      total += element.totalPrice!;
    });
    return total;
  }

  double getTotalService() {
    double total = 0;
    this.serviceOrderCreateParameters!.forEach((element) {
      total += element.totalPrice!;
    });
    return total;
  }

  double getTotalCage() {
    double total = 0;
    this.bookingDetailCreateParameters!.forEach((element) {
      total += element.price!;
    });
    return total;
  }

  double getTotal() {
    double total =
        this.getTotalSupply() + this.getTotalCage() + this.getTotalService();
    return total;
  }

  int getCartCount() {
    int count = 0;
    this.supplyOrderCreateParameters!.forEach((element) {
      count++;
    });
    this.serviceOrderCreateParameters!.forEach((element) {
      count++;
    });
    this.bookingDetailCreateParameters!.forEach((element) {
      count++;
    });
    print('count ${count}');
    return count;
  }

  int isCageSelected(BookingDetailCreateParameters bookingDetails) {
    if (bookingDetailCreateParameters == null ||
        bookingDetailCreateParameters!.isEmpty) return -1;
    for (int i = 0; i < bookingDetailCreateParameters!.length; i++) {
      for (var petId in bookingDetailCreateParameters![i].petId!) {
        if (bookingDetails.petId!.first == petId) {
          return i;
        }
      }
    }
    return -1;
  }

  int isAddedToCart(int typeId, String itemId) {
    switch (typeId) {
      case 0:
        {
          int count = 0;
          this.bookingDetailCreateParameters!.forEach((element) {
            if (element.cageCode == itemId) count++;
          });
          return count;
        }
      case 1:
        {
          for (var element in this.supplyOrderCreateParameters!) {
            if (element.supplyId.toString() == itemId) return element.quantity!;
          }
          break;
        }
      case 2:
        {
          for (var element in this.serviceOrderCreateParameters!) {
            if (element.serviceId.toString() == itemId)
              return element.quantity!;
          }
        }
    }
    return 0;
  }

  bool hasAdditionalItems(int petId) {
    if (this.supplyOrderCreateParameters == null &&
        this.serviceOrderCreateParameters == null) return false;
    for (var supply in this.supplyOrderCreateParameters!) {
      if (supply.petId == petId) return true;
    }
    for (var service in this.serviceOrderCreateParameters!) {
      if (service.petId == petId) return true;
    }
    return false;
  }

  double getTotalDiscount(List<Voucher> vouchers) {
    var voucher = vouchers.firstWhere((element) => element.code == bookingCreateParameter!.voucherCode);
    if (voucher.voucherTypeName!.contains('Phần trăm')) {
      return getTotal() * voucher.value! / 100;
    }
    return voucher.value!;
  }


}

class BookingCreateParameter {
  String? createTime;
  String? startBooking;
  String? endBooking;
  int? statusId;
  String? voucherCode;
  double? total;
  int? customerId;
  int? centerId;
  String? customerNote;
  int? due;

  BookingCreateParameter(
      {this.createTime,
      this.startBooking,
      this.endBooking,
      this.statusId,
      this.voucherCode,
      this.total,
      this.customerId,
      this.centerId,
      this.customerNote,
      this.due});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['startBooking'] = this.startBooking;
    data['endBooking'] = this.endBooking;
    data['statusId'] = this.statusId;
    data['voucherCode'] = this.voucherCode;
    data['total'] = this.total;
    data['customerId'] = this.customerId;
    data['centerId'] = this.centerId;
    data['customerNote'] = this.customerNote;
    return data;
  }
}

class BookingDetailCreateParameters {
  double? price;
  String? cageCode;
  int? duration;
  String? note;
  List<int>? petId;

  BookingDetailCreateParameters(
      {this.price, this.cageCode, this.duration, this.note, this.petId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['cageCode'] = this.cageCode;
    data['duration'] = this.duration;
    data['note'] = this.note;
    data['petId'] = this.petId;
    return data;
  }

  
}

class ServiceOrderCreateParameters {
  int? serviceId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  int? petId;

  ServiceOrderCreateParameters(
      {this.serviceId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      this.petId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['quantity'] = this.quantity;
    data['sellPrice'] = this.sellPrice;
    data['note'] = this.note;
    data['petId'] = this.petId;
    return data;
  }
}

class SupplyOrderCreateParameters {
  int? supplyId;
  int? quantity;
  double? sellPrice;
  double? totalPrice;
  String? note;
  int? petId;

  SupplyOrderCreateParameters(
      {this.supplyId,
      this.quantity,
      this.sellPrice,
      this.totalPrice,
      this.note,
      this.petId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplyId'] = this.supplyId;
    data['quantity'] = this.quantity;
    data['sellPrice'] = this.sellPrice;
    data['totalPrice'] = this.totalPrice;
    data['note'] = this.note;
    data['petId'] = this.petId;
    return data;
  }
}
