import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/sponsor_banner.dart';
import 'package:pawnclaw_mobile_application/repositories/sponsor_banner/base_sponsor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SponsorRepository implements BaseSponsorRepository {
  final Dio _dio = Dio();

  @override
  Future<List<SponsorBanner>?> getSponsorBanners() async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString(),
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/sponsorbanners";
      var response = await _dio.get(_url);
      final banners = response.data
          .map<SponsorBanner>((e) => SponsorBanner.fromJson(e))
          .toList();
      // banners.forEach((e) => print(e.toJson()));
      return banners;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Center>?> getCentersByBrandId(int brandId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString(),
      };

      //var requestBody = {"pageNumber": 0, "pageSize": 5};
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/brand/$brandId";
      var response = await _dio.get(_url);

      //print(response.data);
      //var response = await request.asStream().first;
      print('[repo]get center at banner');
      final centers = response.data.map<Center>((e) => Center.fromJson(e)).toList();
      return centers;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
