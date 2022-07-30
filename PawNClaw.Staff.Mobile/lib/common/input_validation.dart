import 'package:firebase_auth/firebase_auth.dart';

class InputValidator {
  String? isEmpty(String text) {
    if (text.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  String? isValidMail(String text) {
    var valid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
    return valid != true ? "Invalid email address" : null;
  }

  Future<String?> validatePassword(
      String oldPassword, String newPassword, String verifyPassword) async {
    var auth = FirebaseAuth.instance.currentUser;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: auth!.email!, password: oldPassword);
    } on FirebaseAuthException catch (_) {
      return "mật khẩu cũ sai";
    }
    if (oldPassword.isEmpty || newPassword.isEmpty || verifyPassword.isEmpty) {
      return "vui lòng điền đầy đủ thông tin";
    }
    if (newPassword.compareTo(verifyPassword) != 0) {
      return "mật khẩu xác thực sai";
    }
    return null;
  }
}
