part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingUpdated extends BookingState {
  final BookingRequestModel booking;
  final List<List<Pet>>? requests;
  final List<int>? selectedPetIds;
  final Pet? selectedPet;
  final String? voucherCode;
  const BookingUpdated(
      {required this.booking,
      this.requests,
      this.selectedPetIds,
      this.selectedPet,
      this.voucherCode});

  @override
  // TODO: implement props
  List<Object> get props => [booking];
}

class BookingSuccessful extends BookingState {
  final BookingRequestModel booking;
  final Center center;

  const BookingSuccessful(this.booking, this.center);

  @override
  // TODO: implement props
  List<Object> get props => [booking, center];
}

class BookingFailed extends BookingState {
  final String error;

  const BookingFailed(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
