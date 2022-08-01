import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/activity.dart';
import 'package:pawnclaw_mobile_application/repositories/activity/base_activity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepository implements BaseActivityRepository {
  final Dio _dio = Dio();

  @override
  Future<Activity?> getActivityById(int id) async {
    // TODO: implement getActivityById
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookingactivities/$id";
      var response = await _dio.get(
        _url,
      );
      var data = response.data;
      final activity = Activity(
        id: data['id'],
        time: data['provideTime'],
        imgUrl: data['photos'][0]['url'],
      );
      // pets.forEach((e) => print(e.toJson()));
      return activity;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
