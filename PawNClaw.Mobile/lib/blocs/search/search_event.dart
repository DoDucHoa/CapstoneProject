part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class InitSearch extends SearchEvent {}

class SelectPet extends SearchEvent {
  final Pet pet;

  const SelectPet(this.pet);

  @override
  // TODO: implement props
  List<Object> get props => [pet];
}

class AddPetRequest extends SearchEvent {
  final List<Pet> pets;

  const AddPetRequest(this.pets);

  @override
  // TODO: implement props
  List<Object> get props => [pets];
}

class ConfirmRequest extends SearchEvent {
  final List<List<Pet>> requests;

  const ConfirmRequest(this.requests);

  @override
  // TODO: implement props
  List<Object> get props => [requests];
}

class SearchCenter extends SearchEvent {
  final List<List<Pet>> requests;
  final DateTime timeFrom;
  final DateTime timeTo;
  final String cityCode;
  final String districtCode;
  final int pageNumber;

  const SearchCenter(this.requests, this.timeFrom, this.timeTo, this.cityCode,
      this.districtCode, this.pageNumber);

  @override
  // TODO: implement props
  List<Object> get props =>
      [requests, timeFrom, timeTo, cityCode, districtCode, pageNumber];
}
