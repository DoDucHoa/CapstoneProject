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
      var requestBody = {
        'IdToken': token,
        'deviceId': deviceId,
        'SignInMethod': 'Phone'
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/auth/sign-in";
      var response = await _dio.post(_url, data: requestBody);
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

  @override
  Future<Account?> signUp(
      {required String token,
      required String name,
      required String phone,
      required String email,
      required DateTime birthday}) async {
    // TODO: implement signUp
    var deviceId = await _getId();
    try {
      var requestBody = {
        'IdToken': token,
        'deviceId': deviceId,
        'SignInMethod': 'Phone',
        'UserName': email,
        'Phone': phone,
        'Name': name,
        'Birth': birthday.toIso8601String(),
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/auth/sign-up";
      var response = await _dio.post(_url, data: requestBody);
      final account = Account.fromJson(response.data);
      return account;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
