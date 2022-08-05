import 'package:pawnclaw_mobile_application/models/notification.dart';

abstract class BaseNotificationRepository {
  Future<List<Notification>?> getNotification(int userId);
  Future<void> seenAll(int userId);
}
