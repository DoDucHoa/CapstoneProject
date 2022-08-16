part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class InitSearch extends SearchEvent {}

class InitCheck extends SearchEvent {
  final int centerId;
  final List<List<Pet>>? requests;
  const InitCheck(this.centerId, this.requests);
  @override
  // TODO: implement props
  List<Object> get props => [centerId];
}

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

class RemovePetRequest extends SearchEvent {
  final List<Pet> pets;
  const RemovePetRequest(this.pets);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ConfirmRequest extends SearchEvent {
  final List<List<Pet>> requests;
  final int centerId;

  const ConfirmRequest(this.requests, this.centerId);

  @override
  // TODO: implement props
  List<Object> get props => [requests, centerId];
}

class SearchCenter extends SearchEvent {
  final List<List<Pet>> requests;
  final DateTime timeFrom;
  //final DateTime timeTo;
  final int due;
  final String cityCode;
  final String districtCode;
  final int pageNumber;
  final int customerId;

  const SearchCenter(this.requests, this.timeFrom, this.due /*this.timeTo*/,
      this.cityCode, this.districtCode, this.pageNumber, this.customerId);

  @override
  // TODO: implement props
  List<Object> get props =>
      [requests, timeFrom, due, cityCode, districtCode, pageNumber];
}

class CheckCenter extends SearchEvent {
  final int centerId;
  final List<List<Pet>> requests;
  final DateTime timeFrom;
  final int due;
  final int customerId;
  final String? target;
  const CheckCenter(this.centerId, this.requests, this.timeFrom, this.due,
      this.customerId, this.target);
  @override
  // TODO: implement props
  List<Object> get props => [centerId, requests, timeFrom, due, customerId];
}

class CheckReorder extends SearchEvent {
  final int centerId;
  final List<List<Pet>> requests;
  final DateTime timeFrom;
  final int due;
  final int customerId;
  final TransactionDetails transactionDetails;
  const CheckReorder(this.centerId, this.requests, this.timeFrom, this.due,
      this.customerId, this.transactionDetails);
  @override
  // TODO: implement props
  List<Object> get props => [centerId, requests, timeFrom, due, customerId];
}

class CheckSponsorCenter extends SearchEvent {
  final int centerId;
  final int customerId;
  final List<List<Pet>> requests;
  final DateTime timeFrom;
  final int due;
  const CheckSponsorCenter(
      this.centerId, this.customerId, this.requests, this.timeFrom, this.due);
  @override
  // TODO: implement props
  List<Object> get props => [centerId, customerId, requests, timeFrom, due];
}

class BackToPetSelection extends SearchEvent {
  final List<List<Pet>> requests;

  const BackToPetSelection(this.requests);

  @override
  // TODO: implement props
  List<Object> get props => [requests];
}
