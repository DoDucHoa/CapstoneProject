import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pncstaff_mobile_application/models/account.dart';
import 'package:pncstaff_mobile_application/repositories/center/center_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_auth_repository.dart';

class AuthRepository implements BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final Dio _dio = Dio();

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<Account?> signIn({required String token}) async {
    // TODO: implement signIn
    final pref = await SharedPreferences.getInstance();
    var deviceId = await _getId();
    try {
      var requestBody = {
        'IdToken': token,
        'deviceId': deviceId,
        'SignInMethod': 'Email'
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/auth/sign-in";
      var response = await _dio.post(_url, data: requestBody);
      print(response);
      final account = Account.fromJson(response.data);
      await pref.setString("jwtToken", account.jwtToken ?? "");
      print(pref.get("jwtToken"));
      var center = await CenterRepository().getCenterByStaff(account.id!);
      account.petCenter = center;
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
    return await FirebaseMessaging.instance.getToken();
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
        'RoleCode': 'CUS'
      };
      print(requestBody);
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
