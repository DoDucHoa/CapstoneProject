import 'package:pncstaff_mobile_application/models/account.dart';

abstract class BaseAuthRepository {
  Future<Account?> signIn({
    required String token,
  });
  Future<void> signOut();
  Future<Account?> signUp({
    required String token,
    required String name,
    required String phone,
    required String email,
    required DateTime birthday,
  });
}
