import 'package:dio/dio.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/repositories/booking/base_booking_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingRepository implements BaseBookingRepository {
  final Dio _dio = Dio();
  @override
  Future<String> createBooking(BookingRequestModel booking) async {
    // TODO: implement createBooking
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = booking.toJson();
      print('requestbody here:');
      print(json.encode(requestBody));
      const String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings";
      var response = await _dio.post(_url, data: requestBody);
      final result = response.statusCode;
      return result.toString();
      // return '';
    } on DioError catch (e) {
      //throw Exception(e.response!.data);
      return e.response!.data["Message"];
    }
  }
  
  @override
  Future<String> cancelBooking(int bookingId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/customer/cancel-booking?id=$bookingId";
      var response = await _dio.put(_url);
      final result = response.statusCode;
      return result.toString();
      // return '';
    } on DioError catch (e) {
      //throw Exception(e.response!.data);
      print(e);
      return e.response!.data["Message"];
    }
    
  }
}
