import 'package:pncstaff_mobile_application/models/user_profile.dart';

abstract class BaseUserRepository {
  Future<UserProfile> getProfileById(int id);
  Future<bool> updateUserProfile(int id, String name, String phone);
  Future<bool> updateUserAvatar(int id, String url);
}
