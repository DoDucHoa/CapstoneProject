import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/base_transaction_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TransactionRepository implements BaseTransactionRepository {
  final Dio _dio = Dio();

  @override
  Future<List<Booking>?> getTransactions(int customerId) async {
    final pref = await SharedPreferences.getInstance();
    try{
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String _url = "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/customer/$customerId";
      var response = await _dio.get(_url);
      print(response.data);
      final bookings = response.data.map<Booking>((e) => Booking.fromJson(e)).toList();
      print(bookings);
      return bookings;

    }catch(e){
      print(e);
      return null;
    }

  }

  @override
  Future<TransactionDetails?> getTransactionDetails(int bookingId) async{
    final pref = await SharedPreferences.getInstance();
    try{
      _dio.options.headers = {
        'Authorization': 'Bearer ' + pref.get("jwtToken").toString()
      };
      final String url = "https://pawnclawdevelopmentapi.azurewebsites.net/api/bookings/for-customer/$bookingId";
      var response = await _dio.get(url);
      print(response.data);
      final transactionDetails = TransactionDetails.fromJson(response.data);
      print(transactionDetails);
      return transactionDetails;
    }
    catch (e){
      print(e);
      return null;
    }
  }

  
  
  
}