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
  const BookingUpdated(
      {required this.booking,
      this.requests,
      this.selectedPetIds,
      this.selectedPet});

  @override
  // TODO: implement props
  List<Object> get props => [booking];
}
