part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  // final List<List<Pet>> requests;

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Loading extends SearchState {
  const Loading();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdatePetSelected extends SearchState {
  final List<Pet> pets;
  final List<List<Pet>> requests;
  const UpdatePetSelected(this.pets, this.requests);

  @override
  // TODO: implement props
  List<Object> get props => [pets, requests];
}

class FillingInformation extends SearchState {
  final List<List<Pet>> requests;

  const FillingInformation(this.requests);

  @override
  // TODO: implement props
  List<Object> get props => [requests];
}

class SearchCompleted extends SearchState {
  final SearchResponseModel searchResponse;
  final List<Center> centers;
  final List<List<Pet>> requests;
  final DateTime bookingDate;
  
  //final DateTime endDate;
  final int due;
  const SearchCompleted(
      this.centers, this.requests, this.bookingDate, this.due, this.searchResponse);// this.endDate);

  @override
  // TODO: implement props
  List<Object> get props => [centers, requests, bookingDate, due, searchResponse];
}

class SearchFail extends SearchState{
  final String errorMessage;
  final List<List<Pet>> requests;
  const SearchFail(this.errorMessage, this.requests);

  @override
  // TODO: implement props
  List<Object> get props => [errorMessage];
}