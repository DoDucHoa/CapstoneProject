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
        emit(UpdatePetSelected(
            (state as UpdatePetSelected).pets..add(event.pet),
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
      var center = await _centerRepository.searchCenterToBooking(
          event.timeFrom,
          event.timeTo,
          (state as FillingInformation).requests,
          event.cityCode,
          event.districtCode,
          event.pageNumber);
      center != null ? emit(SearchCompleted(center)) : emit(Loading());
    });
  }
}
