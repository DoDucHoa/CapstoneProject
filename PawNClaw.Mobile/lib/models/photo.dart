// To parse this JSON data, do
//
//     final photo = photoFromJson(jsonString);

import 'dart:convert';

class Photo {
    Photo({
        this.id,
        this.photoTypeId,
        this.idActor,
        this.url,
        this.isThumbnail,
        this.status,
    });

    int? id;
    int? photoTypeId;
    int? idActor;
    String? url;
    bool? isThumbnail;
    bool? status;

    factory Photo.fromRawJson(String str) => Photo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        photoTypeId: json["photoTypeId"],
        idActor: json["idActor"],
        url: json["url"],
        isThumbnail: json["isThumbnail"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "photoTypeId": photoTypeId,
        "idActor": idActor,
        "url": url,
        "isThumbnail": isThumbnail,
        "status": status,
    };
}
