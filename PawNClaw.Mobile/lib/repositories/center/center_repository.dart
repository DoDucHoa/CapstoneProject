import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';
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
<<<<<<< HEAD
        if (response.data.toString().toLowerCase().contains("no response")) {
          searchResponseModel =
              SearchResponseModel(result: response.data.toString());
          return searchResponseModel;
        }
=======
        print(response.data);
>>>>>>> 2b95dde15b52104731b7d20d1adb7a38a16fddb8
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
      searchResponseModel = SearchResponseModel(
          result: e.response != null ? e.response!.data["Message"] : "error");
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
      print(json.encode(requestBody));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/center_detail";
      var response = await _dio.post(_url, data: requestBody);
      final center = Center.fromJson(response.data);
      //print(requestBody);
      print('[repo]center_detail:');
      print(response.data);
      return center;
    } on DioError catch (e) {
      print(e.response!.data);
      throw Exception(e.response!.data['Message']);
    }
  }

  @override
  Future<List<Center>?> getCentersByName(
      String searchValue, int pageNumber, int pageSize) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var params = {
        "name": searchValue,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      };
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/search-name";
      var response = await _dio.get(_url, queryParameters: params);
      var data = response.data["data"];
      print(data);
      var centers = data.map<Center>((e) => Center.fromJson(e)).toList();
      print(centers);
      return centers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Center>?> getAllCenter() async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };

      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters";
      var response = await _dio.get(_url);
      var data = response.data["data"];
      print('All');
      print(data);
      final centers = List<Center>.from(data.map((e) => Center.fromJson(e)));
      return centers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Center?> getCenterOverview(int centerId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        "authorization": "Bearer " + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/detail/$centerId";
      var response = await _dio.get(_url);
      print(response.data);
      final center = Center.fromJson(response.data);
      print('[repo]Center overview:');
      print(center.toJson());
      return center;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<SearchResponseModel?> checkCenterToBooking(int centerId,
      DateTime timeFrom, int due, List<List<Pet>> requests) async {
    final pref = await SharedPreferences.getInstance();
    var searchResponseModel;
    Response? response;
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "id": centerId,
        "startBooking": DateFormat('yyyy-MM-dd HH:mm:ss').format(timeFrom),
        "due": due,
        "_petRequests": [
          for (var items in requests) [for (var item in items) item.toJson()]
        ]
      };
      print("request check center");
      print(json.encode(requestBody));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/check_center";
      response = await _dio.post(_url, data: requestBody);

      if (response.statusCode == 200) {
        if (response.data["referenceCenter"] != null) {
          final centers = response.data["referenceCenter"]
              .map<Center>((e) => Center.fromJson(e))
              .toList();
          if (centers.isNotEmpty) {
            searchResponseModel = SearchResponseModel(
                petCenters: centers, result: 'reference center');
            return searchResponseModel;
          }
          searchResponseModel = SearchResponseModel(result: 'no reference');
          return searchResponseModel;
        }
        print('[repo] check center: ');
        //print(response.data);
        final center = Center.fromJson(response.data);
        // print('[repo] check center: ');
        print(center.toJson());
        searchResponseModel = SearchResponseModel(petCenters: [center]);

        return searchResponseModel;
      }
    } on DioError catch (e) {
      //print(response!.statusMessage);
      // print((e as DioError).message);
      throw Exception(e.response!.data['Message']);
      // searchResponseModel = SearchResponseModel(
      //     result: e.response != null ? e.response!.data["mess"] : "error");
      // return searchResponseModel;
    }
  }

  @override
  Future<List<Voucher>?> getCenterVouchers(int centerId, int customerId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };

      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/vouchers/for-cus/center/$customerId?centerId=$centerId";
      var response = await _dio.get(_url);
      print('[repo] Vouchers');
      final vouchers =
          List<Voucher>.from(response.data.map((e) => Voucher.fromJson(e)));
      vouchers.forEach((e) {
        print(e.toJson());
      });
      return vouchers;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position;
  }

  Future<String?> getAddress(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    print('${place.thoroughfare}');
    return '${place.street}';
    // print(address);
  }

  @override
  Future<List<LocationResponseModel>?> getCentersNearby(
      String latitude, String longitude) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        "authorization": "Bearer " + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "userLatitude": latitude,
        "userLongtitude": longitude
      };
      // print(json.encode(requestBody));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/petcenters/nearby_search";
      var response = await _dio.post(_url, data: requestBody);
      
      final locations =  List<LocationResponseModel>.from(response.data.map((e) => LocationResponseModel.fromJson(e)));
      print('[repo]Center nearby');
      // locations.forEach((element) {print(element.toJson());});
      return locations;
    } on DioError catch (e) {
      print(e);

    }
  }
}
