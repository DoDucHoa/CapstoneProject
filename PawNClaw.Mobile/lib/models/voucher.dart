// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

class Voucher {
    Voucher({
        this.code,
        this.minCondition,
        this.value,
        this.startDate,
        this.expireDate,
        this.status,
        this.centerId,
        this.voucherTypeCode,
        this.voucherTypeName,
        this.description

    });

    String? code;
    double? minCondition;
    double? value;
    DateTime? startDate;
    DateTime? expireDate;
    bool? status;
    int? centerId;
    String? voucherTypeCode;
    dynamic voucherTypeName;
    String? description;

    factory Voucher.fromRawJson(String str) => Voucher.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        code: json["code"],
        minCondition: json["minCondition"].toDouble(),
        value: json["value"].toDouble(),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        expireDate:json["expireDate"] == null ? null : DateTime.parse(json["expireDate"]),
        status: json["status"],
        centerId: json["centerId"],
        voucherTypeCode: json["voucherTypeCode"],
        voucherTypeName: json["voucherTypeName"],
        description: json["description"]
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "minCondition": minCondition,
        "value": value,
        "startDate":startDate != null ?  startDate!.toIso8601String() : null,
        "expireDate":expireDate != null ? expireDate!.toIso8601String() : null,
        "status": status,
        "centerId": centerId,
        "voucherTypeCode": voucherTypeCode,
        "voucherTypeName": voucherTypeName,
        "description": description
    };

    String formatStartDate(){
      return DateFormat('dd/MM/yyyy').format(this.startDate!);
     
    }

    String formatExpiredDate(){
      return DateFormat('dd/MM/yyyy').format(this.expireDate!);
     
    }
}
