import 'package:dio/dio.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/photo.dart';
import 'package:pncstaff_mobile_application/repositories/booking/base_booking_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingRepository implements BaseBookingRepository {
  final Dio _dio = Dio();
  @override
  Future<List<BookingDetail>?> getProcessingBooking(
      {required int staffId}) async {
    // TODO: implement getProcessingBooking
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/center/$staffId?statusId=2";
      // "https://192.168.31.133/api/bookings/center/$staffId?statusId=2";
      var response = await _dio.get(
        _url,
      );
      //print(response.data);
      List<BookingDetail> bookings = response.data
          .map<BookingDetail>((e) => BookingDetail.fromJson(e))
          .toList();
      print('reponse: $bookings.length');
      bookings.first.bookingDetails!.forEach((element) {
        print(element.c!.toJson());
      });

      return bookings;
    } on DioError catch (e) {
      print(e.response?.data);
      throw Exception(e);
    }
  }

  @override
  Future<BookingDetail> getBookingDetail({required int bookingId}) async {
    // TODO: implement getBookingDetail
    // TODO: implement getProcessingBooking
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/for-staff/$bookingId";
      var response = await _dio.get(
        _url,
      );
      final booking = BookingDetail.fromJson(response.data);
      print(booking);
      return booking;
    } on DioError catch (e) {
      print(e.response!.data);
      throw Exception(e);
    }
  }

  @override
  Future<BookingDetail> searchBookingByCagecode(
      {required int centerId, required String cageCode}) async {
    // TODO: implement searchBookingByCagecode
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/get-booking-cagecode";
      var params = {'CenterId': centerId, 'StatusId': 2, 'CageCode': cageCode};
      // "https://192.168.31.133/api/bookings/center/$staffId?statusId=2";
      print(params);
      var response = await _dio.get(_url, queryParameters: params);
      print(response.data);
      final booking = BookingDetail.fromJson(response.data);
      return booking;
    } on DioError catch (e) {
      print(e.response?.data);
      throw Exception(e);
    }
  }
}
