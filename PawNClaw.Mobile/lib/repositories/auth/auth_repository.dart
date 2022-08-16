import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/customer.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/base_auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        'SignInMethod': 'Phone'
      };
      //print(token);
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/auth/sign-in";
      var response = await _dio.post(_url, data: requestBody);
      final account = Account.fromJson(response.data);
      await pref.setString("jwtToken", account.jwtToken ?? "");
      print(pref.get("jwtToken"));
      return account;
    } on DioError catch (e) {
      print(e.response);
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
    final pref = await SharedPreferences.getInstance();
    try {
      var requestBody = {
        '_loginRequestModel': {
          'IdToken': token,
          'deviceId': deviceId,
          'SignInMethod': 'Phone'
        },
        '_accountRequest': {
          'UserName': email,
          'RoleCode': 'CUS',
          'deviceId': deviceId,
          'Phone': phone
        },
        '_customerRequest': {
          'Name': name,
          'Birth': birthday.toIso8601String(),
        }
      };
      print(requestBody);
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/auth/sign-up";
      var response = await _dio.post(_url, data: requestBody);
      final account = Account.fromJson(response.data);
      await pref.setString("jwtToken", account.jwtToken ?? "");
      print(pref.get("jwtToken"));
      return account;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Customer?> getCustomerInfo(int accountId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/accounts/$accountId";
      var response = await _dio.get(_url);
      final customer = Customer.fromJson(response.data["customer"]);
      print('[repository] getCustomerInfo: ${customer.name}');
      print(response.data);
      return customer;
    } on DioError catch (e) {
      print(e.response!.data);
      return null;
    }
  }

  @override
  Future<bool> updateCustomerAvatar(Photo photo) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
     
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/photos/account";
      var response = await _dio.post(_url, data: photo.toJson());
      //final customer = Customer.fromJson(response.data["customer"]);
      print('[repository] update avatar: ${response.statusMessage}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;

      //print(response.data);
    } on DioError catch (e) {
      print(e.response!.data);
      return false;
    }
  }

  @override
  Future<bool> updateCustomerInfo(Account user, Customer customer) async {
    final pref = await SharedPreferences.getInstance();
    var deviceId = await _getId();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "account": {
          "id": user.id,
          "userName": user.email,
          "phone": user.phone,
          "roleCode": "CUS",
          "deviceId": deviceId,
          "status": true,
          "createdUser": 1,
          "customer": {
            "id": customer.id,
            "name": customer.name,
            "birth": customer.birth!.toIso8601String(),
            "gender": customer.gender
          }
        }
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/accounts";
      var response = await _dio.put(_url, data: requestBody);
      //final customer = Customer.fromJson(response.data["customer"]);
      print('[repository] update customer: ${response.statusMessage}');
      if (response.statusMessage == "OK") {
        return true;
      }
      return false;

      //print(response.data);
    } on DioError catch (e) {
      print('[repository] update customer: ${e.response!.data["Message"]}');
      //print(e.response!.data["Message"]);
      return e.response!.data["Message"].toString().contains("Value cannot be null");
    }
  }

  Future<String?> getPolicy() async{
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/policies/for-customer";
      var response = await _dio.get(_url);
      
      print('[repository] getPolicy: ${response.data["policy"]}');
      return response.data["policy"];
    } on DioError catch (e) {
      print(e.response!.data);
      return null;
    }
  }
}
