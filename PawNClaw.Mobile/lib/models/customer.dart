// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

class Customer {
    Customer({
        this.id,
        this.name,
        this.birth,
        this.gender,
    });

    int? id;
    String? name;
    DateTime? birth;
    int? gender;

    factory Customer.fromRawJson(String str) => Customer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        birth: json["birth"] == null ? null : DateTime.parse(json["birth"]),
        gender: json["gender"] == null ? null : json["gender"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "birth": birth == null ? null : birth!.toIso8601String(),
        "gender": gender == null ? null : gender,
    };
}
