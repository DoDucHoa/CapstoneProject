import 'package:pawnclaw_mobile_application/models/activity.dart';

abstract class BaseActivityRepository {
  Future<Activity?> getActivityById(int id);
}
