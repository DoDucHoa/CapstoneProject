part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchByCagecode extends SearchEvent {
  final String cageCode;
  final int centerId;

  SearchByCagecode(this.cageCode, this.centerId);

  @override
  // TODO: implement props
  List<Object> get props => [cageCode, centerId];
}

class ClearSearch extends SearchEvent{}