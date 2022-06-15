// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'dart:convert';

import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/rating.dart';

import 'account.dart';

class Booking {
    Booking({
        this.id,
        this.subTotal,
        this.discount,
        this.total,
        this.checkIn,
        this.checkOut,
        this.createTime,
        this.startBooking,
        this.endBooking,
        this.rating,
        this.customerNote,
        this.staffNote,
        this.center,
        this.status,
        this.statusId
    });

    int? id;
    double? subTotal;
    double? discount;
    double? total;
    DateTime? checkIn;
    DateTime? checkOut;
    DateTime? createTime;
    DateTime? startBooking;
    DateTime? endBooking;
    double? rating;
    String? customerNote;
    String? staffNote;
    Center? center;
    Status? status;
    int? statusId;

    factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        subTotal: json["subTotal"] != null ? json["subTotal"].toDouble() : 0,
        discount:  json["discount"] != null ? json["discount"].toDouble() : 0,
        total: json["total"].toDouble(),
        checkIn:  json["checkIn"] != null ? DateTime.parse(json["checkIn"]) : null,
        checkOut:  json["checkOut"] != null ? DateTime.parse(json["checkOut"]) : null,
        createTime: DateTime.parse(json["createTime"]),
        startBooking: DateTime.parse(json["startBooking"]),
        endBooking: DateTime.parse(json["endBooking"]),
        rating: json["rating"] != null ? json["rating"].toDouble():0,
        customerNote: json["customerNote"],
        staffNote: json["staffNote"],
        center: Center.fromJson(json["center"]),
        status: Status.fromJson(json["status"]),
        statusId: json["statusId"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subTotal": subTotal,
        "discount": discount,
        "total": total,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "createTime": createTime!.toIso8601String(),
        "startBooking": startBooking!.toIso8601String(),
        "endBooking": endBooking!.toIso8601String(),
        "rating": rating,
        "customerNote": customerNote,
        "staffNote": staffNote,
        "center": center!.toJson(),
        "status": status!.toJson(),
        "statusId":statusId
    };
}


class Status {
    Status({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
class Rating {
  Rating({
    this.id,
    this.rating,
    this.comment,
    this.createdAt,
    this.booking,
  });

  int? id;
  int? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Account? user;
  Booking? booking;
}
