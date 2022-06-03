part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class InitBooking extends BookingEvent {
  final DateTime startBooking;
  final DateTime endBooking;
  final int centerId;
  final List<List<Pet>> request;
  final int customerId;

  const InitBooking(
      {required this.startBooking,
      required this.endBooking,
      required this.centerId,
      required this.request,
      required this.customerId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [startBooking, endBooking, centerId, request, customerId];
}

class SelectCage extends BookingEvent {
  final double price;
  final String cageCode;
  final List<int> petId;

  const SelectCage(
      {required this.price, required this.cageCode, required this.petId});

  @override
  // TODO: implement props
  List<Object> get props => [price, cageCode, petId];
}

class SelectSupply extends BookingEvent {
  final double sellPrice;
  final int supplyId;
  final int petId;

  const SelectSupply(
      {required this.sellPrice, required this.supplyId, required this.petId});

  @override
  // TODO: implement props
  List<Object> get props => [sellPrice, supplyId, petId];
}

class SelectService extends BookingEvent {
  final List<ServicePrices> prices;
  final int serviceId;
  final int petId;

  const SelectService(
      {required this.prices, required this.serviceId, required this.petId});

  @override
  // TODO: implement props
  List<Object> get props => [prices, serviceId, petId];
}
