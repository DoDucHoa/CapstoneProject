import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/models/review.dart';

import '../../models/account.dart';
import '../../models/booking.dart';
import '../../models/transaction_details.dart';
import '../../repositories/transaction/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository = TransactionRepository();
  TransactionBloc() : super(TransactionInitial()) {
    on<GetTransactions>((event, emit) async {
      final transactions =
          await _transactionRepository.getTransactions(event.account.id!);
      if (transactions != null) {
        transactions.sort((a, b) => b.createTime!.compareTo(a.createTime!));
        emit(TransactionLoaded(transactions));
      }
    });
    on<GetTransactionDetails>((event, emit) async {
      final transactionDetails =
          await _transactionRepository.getTransactionDetails(event.bookingId);
      print("line of BookingDetails: " +
          transactionDetails!.bookingDetails!.length.toString());
      print("line of petbookingdetails: " +
          transactionDetails.bookingDetails!.first.petBookingDetails!.length
              .toString());
      print('cage: ' +
          transactionDetails.bookingDetails!.first.cage!.cageType!.typeName!);
      print('service: ' + transactionDetails.serviceOrders!.length.toString());
      print('supply: ' + transactionDetails.supplyOrders!.length.toString());
      print('act: ' + transactionDetails.bookingActivities!.length.toString());
      if (transactionDetails != null)
        emit(TransactionDetailsLoaded(transactionDetails));
    });

    on<SendReview>((event, emit) async{
      bool sent = await _transactionRepository.sendReview(event.review);
      if (sent) {
        emit(ReviewSent(event.review.bookingId!));
      }

    });
  }
}
