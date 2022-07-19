import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CenterRepository _centerRepository = CenterRepository();
  SearchBloc() : super(SearchInitial()) {
    on<InitSearch>((event, emit) {
      // TODO: implement event handler
      emit(UpdatePetSelected([], []));
    });
    on<SelectPet>(
      (event, emit) {
        var inputPet = event.pet;
        var pets = (state as UpdatePetSelected).pets;
        if (pets.contains(inputPet)) {
          pets.remove(inputPet);
        } else {
          pets.add(inputPet);
        }

        print('im here');
        emit(UpdatePetSelected(
            pets,
            //(state as UpdatePetSelected).pets..add(event.pet),
            (state as UpdatePetSelected).requests));
      },
    );
    on<AddPetRequest>((event, emit) {
      emit(UpdatePetSelected(
          [], (state as UpdatePetSelected).requests..add(event.pets)));
    });
    on<ConfirmRequest>((event, emit) {
      emit(FillingInformation((state as UpdatePetSelected).requests));
    });
    on<SearchCenter>((event, emit) async {
      emit(Loading());
      var searchResponse = await _centerRepository.searchCenterToBooking(
          event.timeFrom,
          event.due,
          event.requests,
          event.cityCode,
          event.districtCode,
          event.pageNumber);

      (searchResponse == null)
          ? emit(Loading())
          : (searchResponse.petCenters != null)
              ? emit(SearchCompleted(searchResponse.petCenters!, event.requests,
                  event.timeFrom, event.due, searchResponse))
              : emit(SearchFail(searchResponse.result!, event.requests));
    });
    on<BackToPetSelection>(
      (event, emit) {
        emit(UpdatePetSelected([], event.requests));
      },
    );
  }
}
