import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';

import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';

import '../sponsor/sponsor_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CenterRepository _centerRepository = CenterRepository();
  SearchBloc() : super(SearchInitial()) {
    on<InitSearch>((event, emit) {
      // TODO: implement event handler
      emit(UpdatePetSelected([], []));
    });

    on<InitCheck>((event, emit) {
      if (event.requests == null) {
        emit(CheckCenterInitial(event.centerId));
        emit(UpdatePetSelected([], []));
      }else {
        emit(CheckCenterInitial(event.centerId));
        emit(FillingInformation(event.requests!, event.centerId));
      }
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

        emit(UpdatePetSelected(pets, (state as UpdatePetSelected).requests));
      },
    );
    on<AddPetRequest>((event, emit) {
      emit(UpdatePetSelected(
          [], (state as UpdatePetSelected).requests..add(event.pets)));
    });

    on<RemovePetRequest>((event, emit) {
      print('at remove pet request');
      print(event.pets);
      emit(UpdatePetSelected(
          [],
          (state as UpdatePetSelected).requests
            ..removeWhere((element) => element.contains(event.pets[0]))));
    });
    on<ConfirmRequest>((event, emit) {
      if (state is UpdatePetSelected){
emit(FillingInformation(
          (state as UpdatePetSelected).requests, event.centerId));
      }else{
        emit(FillingInformation(event.requests, event.centerId));
      }
      
    });
    on<SearchCenter>((event, emit) async {
      emit(Loading());
      var searchResponse = await _centerRepository.searchCenterToBooking(
          event.timeFrom,
          event.due,
          event.requests,
          event.cityCode,
          event.districtCode,
          event.pageNumber,
          event.customerId);

      (searchResponse == null)
          ? emit(Loading())
          : (searchResponse.petCenters != null)
              ? emit(SearchCompleted(searchResponse.petCenters!, event.requests,
                  event.timeFrom, event.due, searchResponse))
              : emit(SearchFail(searchResponse.result!, event.requests, null, "search"));
    });
    on<CheckCenter>((event, emit) async {
      emit(Loading());
      var searchResponse = await _centerRepository.checkCenterToBooking(
          event.centerId,
          event.customerId,
          event.timeFrom,
          event.due,
          event.requests);
      if (searchResponse == null)
        emit(Loading());
      else if (searchResponse.petCenters != null) {
        if (searchResponse.petCenters!.length == 1 &&
            searchResponse.petCenters!.first.id == event.centerId) {
          print('center is available');
          emit(CheckedCenter(searchResponse.petCenters!.first, event.requests,
              event.timeFrom, event.due));
        } else {
          emit(SearchCompleted(searchResponse.petCenters!, event.requests,
              event.timeFrom, event.due, searchResponse));
        }
      } else {
        searchResponse.result =
            searchResponse.result ?? "" + event.centerId.toString();
        emit(SearchFail(searchResponse.result!, event.requests, event.centerId, event.target));
      }
    });
    on<CheckSponsorCenter>((event, emit) async {
      emit(Loading());
      var searchResponse = await _centerRepository.checkCenterToBooking(
          event.centerId,
          event.customerId,
          event.timeFrom,
          event.due,
          event.requests);
      if (searchResponse == null)
        emit(Loading());
      else if (searchResponse.petCenters != null) {
        emit(CheckedSponsorCenter(searchResponse.petCenters!.first,
            event.requests, event.timeFrom, event.due));
      } else if (searchResponse.result!.contains('reference')) {
        var centers = await _centerRepository.getAllCenter();
        centers!.removeWhere((element) => element.id == event.centerId);
        searchResponse.result = "sponsors";
        emit(SearchCompleted(centers, event.requests, event.timeFrom, event.due,
            searchResponse));
      } else {
        emit(SearchFail(searchResponse.result!, event.requests, event.centerId, "check"));
      }
    });
    on<BackToPetSelection>(
      (event, emit) {
        emit(UpdatePetSelected([], event.requests));
      },
    );

    on<CheckReorder>((event, emit) async {
      emit(Loading());
      var searchResponse = await _centerRepository.checkCenterToBooking(
          event.centerId,
          event.customerId,
          event.timeFrom,
          event.due,
          event.requests);
      if (searchResponse == null)
        emit(Loading());
      else if (searchResponse.petCenters != null) {
        if (searchResponse.petCenters!.length == 1 &&
            searchResponse.petCenters!.first.id == event.centerId) {
          print('center is available');
          emit(CheckedCenter(searchResponse.petCenters!.first, event.requests,
              event.timeFrom, event.due));
        } else {
          emit(SearchCompleted(searchResponse.petCenters!, event.requests,
              event.timeFrom, event.due, searchResponse));
        }
      } else {
        searchResponse.result =
            searchResponse.result ?? "" + event.centerId.toString();
        emit(SearchFail(searchResponse.result!, event.requests, event.centerId, event.transactionDetails));
      }
    });
  }
}
