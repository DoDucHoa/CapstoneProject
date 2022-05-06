import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pawnclaw_mobile_application/models/account.dart';

abstract class BaseAuthRepository {
  Future<Account?> signIn({
    required String token,
  });
  Future<void> signOut();
}