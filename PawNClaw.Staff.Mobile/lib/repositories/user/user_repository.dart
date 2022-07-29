import 'package:dio/dio.dart';
import 'package:pncstaff_mobile_application/models/user_profile.dart';
import 'package:pncstaff_mobile_application/repositories/center/center_repository.dart';
import 'package:pncstaff_mobile_application/repositories/user/base_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository implements BaseUserRepository {
  final Dio _dio = Dio();

  @override
  Future<UserProfile> getProfileById(int id) async {
    // TODO: implement getProfileById
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/accounts/${id}";
      // "https://192.168.31.133/api/bookings/center/$staffId?statusId=2";
      var response = await _dio.get(
        _url,
      );
      print(response.data);
      final profile = UserProfile.fromJson(response.data);
      var center = await CenterRepository().getCenterByStaff(id);
      profile.center = center;
      return profile;
    } on DioError catch (e) {
      print(e.response?.data);
      throw Exception(e);
    }
  }

  @override
  Future<bool> updateUserProfile(int id, String name, String phone) async {
    // TODO: implement updateUserProfile
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/staffs";
      // "https://192.168.31.133/api/bookings/center/$staffId?statusId=2";
      Map<String, dynamic> query = {
        "id": id,
        "modifyUser": id,
        "name": name,
        "phone": phone
      };
      print(query);
      var response = await _dio.put(_url, queryParameters: query);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response?.data);
      throw Exception(e);
    }
  }
}
