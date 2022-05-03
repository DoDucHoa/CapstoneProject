import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/base_auth_repository.dart';

class AuthRepository implements BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final Dio _dio = Dio();

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<Account?> signIn({required String token}) async {
    // TODO: implement signIn
    var deviceId = await _getId();
    try {
      var queryParameters = {
        'IdToken': token,
        'deviceId': deviceId,
        'SignInMethod': 'Phone'
      };
      const String _url =
          "https://pawnclawapi.azurewebsites.net/api/auth/sign-in";
      var response = await _dio.post(_url, queryParameters: queryParameters);
      final account = Account.fromJson(response.data);
      return account;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
