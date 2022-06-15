part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];

}

class InitTransaction extends TransactionEvent{}

class GetTransactions extends TransactionEvent {
  final Account account;

  const GetTransactions(this.account);
  @override
  List<Object> get props => [account];
}

class GetTransactionDetails extends TransactionEvent{
  final int bookingId;
  const GetTransactionDetails(this.bookingId);
  @override 
  List<Object> get props => [bookingId];
}