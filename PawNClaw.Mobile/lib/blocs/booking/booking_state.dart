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
  const BookingUpdated({required this.booking, this.requests});

  @override
  // TODO: implement props
  List<Object> get props => [booking];
}
