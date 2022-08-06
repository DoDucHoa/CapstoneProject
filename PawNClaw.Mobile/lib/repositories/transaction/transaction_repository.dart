import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/review.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/base_transaction_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionRepository implements BaseTransactionRepository {
  final Dio _dio = Dio();

  @override
  Future<List<Booking>?> getTransactions(int customerId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/customer/$customerId";
      var response = await _dio.get(_url);
      //print(response.data);
      List<Booking> bookings =
          response.data.map<Booking>((e) => Booking.fromJson(e)).toList();

      // print(bookings);
      return bookings;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<TransactionDetails?> getTransactionDetails(int bookingId) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/for-customer/$bookingId";
      var response = await _dio.get(url);
      // print(response.data);
      final transactionDetails = TransactionDetails.fromJson(response.data);
      if (response.data['rating'] != null) {
          var customer = response.data['customer'];
          transactionDetails.review = Review(
              customerName: customer['name'],
              rating: response.data['rating'],
              bookingId: response.data['id'],
              customerAva: customer['photos'],
              description: response.data['feedback'],
              customerId: response.data['customerId']);
            
        }
      //print(transactionDetails);
      return transactionDetails;
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  @override
  Future<bool> sendReview(Review review) async {
    final pref = await SharedPreferences.getInstance();
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      var requestBody = {
        "bookingId": review.bookingId,
        "rating": review.rating,
        "feedback": review.description
      };

      const String url =
          "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/rating";
      var response = await _dio.put(url, queryParameters: requestBody);
      if(response.statusCode == 200)
       return true;
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
