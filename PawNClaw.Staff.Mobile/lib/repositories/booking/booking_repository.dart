import 'package:dio/dio.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/repositories/booking/base_booking_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingRepository implements BaseBookingRepository {
  final Dio _dio = Dio();
  @override
  Future<List<Booking>?> getProcessingBooking({required int staffId}) async {
    // TODO: implement getProcessingBooking
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/center/$staffId?statusId=2";
      var response = await _dio.get(
        _url,
      );
      final bookings =
          response.data.map<Booking>((e) => Booking.fromJson(e)).toList();
      print(bookings);
      return bookings;
    } on DioError catch (e) {
      print(e.response!.data);
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
}
