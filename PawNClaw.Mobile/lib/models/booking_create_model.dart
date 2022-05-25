class BookingRequestModel {
  BookingCreateParameter? bookingCreateParameter;
  List<BookingDetailCreateParameters>? bookingDetailCreateParameters;
  List<ServiceOrderCreateParameters>? serviceOrderCreateParameters;
  List<SupplyOrderCreateParameters>? supplyOrderCreateParameters;

  BookingRequestModel(
      {this.bookingCreateParameter,
      this.bookingDetailCreateParameters,
      this.serviceOrderCreateParameters,
      this.supplyOrderCreateParameters});

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
}

class BookingCreateParameter {
  String? createTime;
  String? startBooking;
  String? endBooking;
  int? statusId;
  // Null? voucherCode;
  int? customerId;
  int? centerId;
  String? customerNote;

  BookingCreateParameter(
      {this.createTime,
      this.startBooking,
      this.endBooking,
      this.statusId,
      // this.voucherCode,
      this.customerId,
      this.centerId,
      this.customerNote});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['startBooking'] = this.startBooking;
    data['endBooking'] = this.endBooking;
    data['statusId'] = this.statusId;
    // data['voucherCode'] = this.voucherCode;
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
