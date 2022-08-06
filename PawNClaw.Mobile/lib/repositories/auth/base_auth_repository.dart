import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';

import '../../models/customer.dart';

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

  Future<Customer?> getCustomerInfo(int accountId);
  Future<bool> updateCustomerInfo(Account user, Customer customer);
  Future<bool> updateCustomerAvatar(Photo photo);
}
