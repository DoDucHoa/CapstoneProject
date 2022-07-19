import 'package:dio/dio.dart';
import 'package:pncstaff_mobile_application/models/pet_center.dart';
import 'package:pncstaff_mobile_application/repositories/center/base_center_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CenterRepository implements BaseCenterRepository {
  @override
  Future<PetCenter> getCenterByStaff(int id) async {
    // TODO: implement getCenterByStaff
    final Dio _dio = Dio();
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/staff/$id";
      // "https://192.168.31.133/api/bookings/center/$staffId?statusId=2";
      var response = await _dio.get(
        _url,
      );
      print(response.data);
      final center = PetCenter.fromJson(response.data);
      return center;
    } on DioError catch (e) {
      print(e.response?.data);
      throw Exception(e);
    }
  }
}
