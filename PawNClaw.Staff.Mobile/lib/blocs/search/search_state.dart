part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchDone extends SearchState {
  final BookingDetail booking;
  final String cageCode;
  const SearchDone(this.booking, this.cageCode);

  @override
  // TODO: implement props
  List<Object> get props => [booking, cageCode];
}

class SearchFail extends SearchState {
  final String error;

  const SearchFail(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
