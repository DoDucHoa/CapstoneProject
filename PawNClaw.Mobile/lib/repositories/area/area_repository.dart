import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/area.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_area_repository.dart';

class AreaRepository implements BaseAreaRepository {
  final Dio _dio = Dio();
  @override
  Future<List<Area>?> getAllArea() async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/cities";
      var response = await _dio.get(
        _url,
      );
      final areas = response.data.map<Area>((e) => Area.fromJson(e)).toList();
      print(areas);
      return areas;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Districts>?> getDistrictsByArea(String cityCode) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/districts/$cityCode";
      var response = await _dio.get(
        _url,
      );
      final districts =
          response.data.map<Districts>((e) => Districts.fromJson(e)).toList();
      print(districts);
      return districts;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
