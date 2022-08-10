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
  final int due;

  const InitBooking(
      {required this.startBooking,
      required this.endBooking,
      required this.centerId,
      required this.request,
      required this.customerId,
      required this.due});

  @override
  // TODO: implement props
  List<Object> get props =>
      [startBooking, endBooking, centerId, request, customerId, due];
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

class SelectRequest extends BookingEvent {
  final List<int> petId;

  const SelectRequest({required this.petId});

  @override
  List<Object> get props => [petId];
}

class AddVoucher extends BookingEvent {
  final String voucherCode;

  const AddVoucher({required this.voucherCode});

  @override
  List<Object> get props => [voucherCode];
}

class SelectSupply extends BookingEvent {
  final double sellPrice;
  final int supplyId;
  final int petId;
  final int quantity;
  final bool? isUpdate;

  const SelectSupply(
      {required this.sellPrice,
      required this.supplyId,
      required this.petId,
      required this.quantity,
      this.isUpdate});

  @override
  // TODO: implement props
  List<Object> get props => [sellPrice, supplyId, petId, quantity];
}

class SelectService extends BookingEvent {
  final List<ServicePrices> prices;
  final int serviceId;
  final int petId;
  final int quantity;
  final bool? isUpdate;

  const SelectService(
      {required this.prices,
      required this.serviceId,
      required this.petId,
      required this.quantity,
      this.isUpdate});

  @override
  // TODO: implement props
  List<Object> get props => [prices, serviceId, petId, quantity];
}

class ConfirmBookingRequest extends BookingEvent {
  final BookingRequestModel booking;
  final Center center;

  const ConfirmBookingRequest(this.booking, this.center);

  @override
  // TODO: implement props
  List<Object> get props => [booking, center];
}
