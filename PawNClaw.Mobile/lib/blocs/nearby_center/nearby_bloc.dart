import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';

part 'nearby_event.dart';
part 'nearby_state.dart';

class NearbyBloc extends Bloc<NearbyEvent, NearbyState> {
  NearbyBloc() : super(NearbyInitial()) {
    //TO-DO: init nearby position to use later


    on<GetCurrentLocation>((event, emit) async {
      emit(Loading());
      var position = await CenterRepository().getCurrentLocation();
      if (position != null){
        emit(LoadedCurrentPosition(position));
      }
    });
    on<GetAddress>((event, emit) async {
      emit(Loading());
      var address = await CenterRepository().getAddress(event.position);
      if (address != null){
        emit(LoadedAddress(event.position, address));
      }
    });

    on<GetCenterNearby>((event, emit) async {
      emit(Loading());
      var response = await CenterRepository().getCentersNearby(event.latitude.toString(), event.longitude.toString());
      if (response != null){
        emit(LoadCentersNearby(response, event.address));
      }
    });
  }
}
