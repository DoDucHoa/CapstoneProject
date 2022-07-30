// To parse this JSON data, do
//
//     final sponsorBanner = sponsorBannerFromJson(jsonString);

import 'dart:convert';

import 'package:pawnclaw_mobile_application/models/photo.dart';

class SponsorBanner {
  SponsorBanner({
    this.id,
    this.title,
    this.content,
    this.startDate,
    this.endDate,
    this.duration,
    this.status,
    this.brandId,
    this.photos,
  });

  int? id;
  String? title;
  String? content;
  DateTime? startDate;
  DateTime? endDate;
  double? duration;
  bool? status;
  int? brandId;
  List<Photo>? photos;

  factory SponsorBanner.fromRawJson(String str) =>
      SponsorBanner.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory SponsorBanner.fromJson(Map<String, dynamic> json) => SponsorBanner(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        duration: json["duration"].toDouble(),
        status: json["status"],
        brandId: json["brandId"],
        photos: json["photos"] != null ? List<Photo>.from(json["photos"].map((e) => Photo.fromJson(e))) : null,
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "content": content,
  //       "startDate": startDate!.toIso8601String(),
  //       "endDate": endDate!.toIso8601String(),
  //       "duration": duration,
  //       "status": status,
  //       "brandId": brandId,
  //       "photos": photos!.toJson(),
  //     };
}

// class Sponsors {
//   List<SponsorBanner> banners;

//   Sponsors(this.banners);

//   List<String>? getPhotosUrl() {
//     var urls = this.banners.map((element) {
//       if (element.photos != null) return element.photos;
//       return 'lib/assets/center0.jpg';
//     }).toList();
//     return urls;
//   }
// }
