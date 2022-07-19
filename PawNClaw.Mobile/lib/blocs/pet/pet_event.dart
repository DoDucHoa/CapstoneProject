part of 'pet_bloc.dart';

abstract class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

class GetPets extends PetEvent {
  final Account account;

  const GetPets(this.account);
  @override
  // TODO: implement props
  List<Object> get props => [account];
}
