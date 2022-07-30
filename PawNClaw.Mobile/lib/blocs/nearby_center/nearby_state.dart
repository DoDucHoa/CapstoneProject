part of 'nearby_bloc.dart';

abstract class NearbyState extends Equatable {
  const NearbyState();
  
  @override
  List<Object> get props => [];
}

class NearbyInitial extends NearbyState {}

class LoadedCurrentPosition extends NearbyState{
  final Position position;

  const LoadedCurrentPosition(this.position);
  @override
  List<Object> get props => [position];
}

class LoadedAddress extends NearbyState{
  final Position position;
  final String address;

  const LoadedAddress(this.position, this.address);

  @override
  List<Object> get props => [position, address];
}

class Loading extends NearbyState{}

class LoadCentersNearby extends NearbyState{
  final List<LocationResponseModel> response;
  final String address;
  const LoadCentersNearby(this.response, this.address);
  
  @override
  List<Object> get props => [response, address];
}