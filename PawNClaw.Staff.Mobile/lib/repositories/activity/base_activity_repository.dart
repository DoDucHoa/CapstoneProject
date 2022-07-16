import 'package:pncstaff_mobile_application/models/activity_request_model.dart';

abstract class BaseActivityRepository {
  Future<String?> addNewActivity(ActivityRequestModel activity);
}
