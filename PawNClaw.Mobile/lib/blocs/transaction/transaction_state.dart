part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Booking> transactions;

  const TransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionDetailsLoaded extends TransactionState{
  final TransactionDetails transactionDetails;

  const TransactionDetailsLoaded(this.transactionDetails);
  @override 
  List<Object> get props => [transactionDetails];
}