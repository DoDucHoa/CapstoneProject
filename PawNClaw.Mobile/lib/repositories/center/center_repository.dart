import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/center/base_center_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CenterRepository implements BaseCenterRepository {
  final Dio _dio = Dio();
  @override
  Future<SearchResponseModel?> searchCenterToBooking(
      DateTime timeFrom,
      //DateTime timeTo,
      int due,
      List<List<Pet>> requests,
      String city,
      String district,
      int pageNumber) async {
        
    final pref = await SharedPreferences.getInstance();
    var searchResponseModel;
    Response? response;
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "city": city,
        "district": district,
        "startBooking": DateFormat('yyyy-MM-dd HH:mm:ss').format(timeFrom),
        //"endBooking": DateFormat('yyyy-MM-dd HH:mm:ss').format(timeTo),
        "due": due,
        // "_petRequests": parseRequestToJson(requests),
        "_petRequests": [
          for (var items in requests) [for (var item in items) item.toJson()]
        ],
        "paging": {"pageNumber": pageNumber, "pageSize": 5}
      };
      print("request search");
      print(json.encode(requestBody));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/main-search";
      response = await _dio.post(_url, data: requestBody);
      
      if (response.statusCode == 200) {
        var data = response.data['data'];

        print(data["petCenters"]);
        final centers =
            data['petCenters'].map<Center>((e) => Center.fromJson(e)).toList();
        //var data = json.decode(response.data);

        var metadata = response.data['metadata'];
        searchResponseModel = SearchResponseModel(
            petCenters: centers,
            city: data['city'],
            district: data['district'],
            districtName: data['districtName'],
            page: metadata['currentPage']);
        print(response.data);
        centers.forEach((c) {
          print(c.toJson());
        });
        if (district != data['district'])
          print(district + '=>' + data['district']);
        print(response.data);
        return searchResponseModel;
      }
      
    } catch (e) {
      //print(response!.statusMessage);
      print((e as DioError).message);
      searchResponseModel = SearchResponseModel(result: e.response != null ? e.response!.data["Message"] : "error");
      return searchResponseModel;
    }
  }

  @override
  Future<Center?> getCenterDetail(List<List<Pet>> requests, int centerId,
      DateTime timeFrom, DateTime timeTo) async {
    // TODO: implement getCenterDetail
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "id": centerId,
        "_petRequests": [
          for (var items in requests) [for (var item in items) item.toJson()]
        ],
        "startBooking": DateFormat('yyyy-MM-dd HH:mm:ss').format(timeFrom),
        "endBooking": DateFormat('yyyy-MM-dd HH:mm:ss').format(timeTo),
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/center_detail";
      var response = await _dio.post(_url, data: requestBody);
      final center = Center.fromJson(response.data);
      print(requestBody);
      print(response.data);
      return center;
    } on DioError catch (e) {
      print(e.response!.data);
      throw Exception(e.response!.data['Message']);
    }
  }
}
