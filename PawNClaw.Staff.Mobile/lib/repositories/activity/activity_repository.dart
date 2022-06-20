import 'package:dio/dio.dart';
import 'package:pncstaff_mobile_application/models/activity_request_model.dart';
import 'package:pncstaff_mobile_application/repositories/activity/base_activity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepository implements BaseActivityRepository {
  final Dio _dio = Dio();
  @override
  Future<String?> addNewActivity(ActivityRequestModel activity) async {
    // TODO: implement addNewActivity
    final pref = await SharedPreferences.getInstance();
    try {
      var requestBody = activity.toJson();
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookingactivities";
      print(requestBody);
      var response = await _dio.post(_url, data: requestBody);
      switch (response.statusCode) {
        case 200:
          return "success";
        default:
          return "error";
      }
    } on DioError catch (e) {
      print(e.response?.data);
      return null;
    }
  }
}
