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
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/pets/$customerId";
      var response = await _dio.get(
        _url,
      );
      final pets =
          response.data['data'].map<Pet>((e) => Pet.fromJson(e)).toList();
      // pets.forEach((e) => print(e.toJson()));
      return pets;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> createPet(Pet pet) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };

      print(json.encode(pet.toJson()));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/pets";
      var response = await _dio.post(_url, data: pet.toJson());

      // pets.forEach((e) => print(e.toJson()));
      return response.statusCode == 200;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> update(Pet pet) async {
    // TODO: implement update
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };

      Map<String, dynamic> data = {
        "id": pet.id,
        "weight": pet.weight,
        "length": pet.length,
        "height": pet.height,
        "name": pet.name,
        "birth": pet.birth!.toIso8601String(),
        "breedName": pet.breedName,
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/pets/customer";
      print(data);
      var response = await _dio.put(_url, data: data);

      // pets.forEach((e) => print(e.toJson()));
      return response.statusCode == 200;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }
}
