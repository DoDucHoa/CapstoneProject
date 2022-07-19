import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/pet_repository.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepository _petRepository;
  PetBloc({required PetRepository petRepository})
      : this._petRepository = petRepository,
        super(PetInitial()) {
    on<GetPets>((event, emit) async {
      // TODO: implement event handler
      final pets =
          await _petRepository.getPetsByCustomer(customerId: event.account.id!);
      if (pets != null) emit(PetsLoaded(pets));
    });
  }
}
