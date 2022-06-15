import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/booking.dart';

abstract class BaseTransactionRepository {

  Future<List<Booking>?> getTransactions(int customerId);
  Future<TransactionDetails?> getTransactionDetails(int bookingId);
}