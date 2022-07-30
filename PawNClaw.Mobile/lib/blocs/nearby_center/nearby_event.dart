part of 'nearby_bloc.dart';

abstract class NearbyEvent extends Equatable {
  const NearbyEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocation extends NearbyEvent{
  const GetCurrentLocation();

  @override
  List<Object> get props => [];
}

class GetAddress extends NearbyEvent{
  final Position position;
  const GetAddress(this.position);

  @override
  List<Object> get props => [position];
}

class GetCenterNearby extends NearbyEvent{
  final double latitude;
  final double longitude;
  final String address;
  const GetCenterNearby(this.latitude, this.longitude, this.address);

  @override
  // TODO: implement props
  List<Object> get props => [latitude, longitude, address];
}