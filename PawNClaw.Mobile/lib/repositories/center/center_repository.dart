import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/center/base_center_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CenterRepository implements BaseCenterRepository {
  final Dio _dio = Dio();
  @override
  Future<List<Center>?> searchCenterToBooking(
      DateTime timeFrom,
      DateTime timeTo,
      List<List<Pet>> requests,
      String city,
      String district,
      int pageNumber) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "city": city,
        "district": district,
        "startBooking": DateFormat('yyyy-MM-dd hh:mm:ss').format(timeFrom),
        "endBooking": DateFormat('yyyy-MM-dd hh:mm:ss').format(timeTo),
        // "_petRequests": parseRequestToJson(requests),
        "_petRequests": [
          for (var items in requests) [for (var item in items) item.toJson()]
        ],
        "paging": {"pageNumber": pageNumber, "pageSize": 5}
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/main-search";
      var response = await _dio.post(_url, data: requestBody);
      final centers =
          response.data['data'].map<Center>((e) => Center.fromJson(e)).toList();
      print(centers);
      return centers;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
