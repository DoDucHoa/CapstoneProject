part of 'pet_bloc.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object> get props => [];
}

class PetInitial extends PetState {}

class PetsLoaded extends PetState {
  final List<Pet> pets;

  const PetsLoaded(this.pets);
  @override
  // TODO: implement props
  List<Object> get props => [pets];
}
