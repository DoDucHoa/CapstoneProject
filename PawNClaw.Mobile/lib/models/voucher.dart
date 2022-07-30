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

    factory Voucher.fromRawJson(String str) => Voucher.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        code: json["code"],
        minCondition: json["minCondition"].toDouble(),
        value: json["value"].toDouble(),
        startDate: DateTime.parse(json["startDate"]),
        expireDate: DateTime.parse(json["expireDate"]),
        status: json["status"],
        centerId: json["centerId"],
        voucherTypeCode: json["voucherTypeCode"],
        voucherTypeName: json["voucherTypeName"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "minCondition": minCondition,
        "value": value,
        "startDate": startDate!.toIso8601String(),
        "expireDate": expireDate!.toIso8601String(),
        "status": status,
        "centerId": centerId,
        "voucherTypeCode": voucherTypeCode,
        "voucherTypeName": voucherTypeName,
    };

    String formatStartDate(){
      return DateFormat('dd/MM/yyyy').format(this.startDate!);
     
    }

    String formatExpiredDate(){
      return DateFormat('dd/MM/yyyy').format(this.expireDate!);
     
    }
}
