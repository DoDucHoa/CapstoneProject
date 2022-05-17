import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/base_pet_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetRepository implements BasePetRepository {
  final Dio _dio = Dio();
  @override
  Future<List<Pet>?> getPetsByCustomer({required int customerId}) async {
    // TODO: implement getPetsByCustomer
    // TODO: implement signIn
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/pets/11";
      var response = await _dio.get(
        _url,
      );
      final pets =
          response.data['data'].map<Pet>((e) => Pet.fromJson(e)).toList();
      print(pets);
      return pets;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
