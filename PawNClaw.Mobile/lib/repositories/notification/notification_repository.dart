import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/notification.dart';
import 'package:pawnclaw_mobile_application/repositories/notification/base_notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository implements BaseNotificationRepository {
  final _dio = Dio();

  @override
  Future<List<Notification>?> getNotification(int userId) async {
    // TODO: implement getNotification
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/notification/for-customer/$userId";
      var response = await _dio.get(
        _url,
      );
      final notifications = response.data
          .map<Notification>((e) => Notification.fromJson(e))
          .toList();
      // pets.forEach((e) => print(e.toJson()));
      return notifications;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> seenAll(int userId) async {
    // TODO: implement seenAll
    // TODO: implement getNotification
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var data = {"id": userId, "targetType": "Customer"};
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/notification/seen-all";
      var response = await _dio.put(_url, queryParameters: data);
    } on DioError catch (e) {
      print(e);
    }
  }
}
