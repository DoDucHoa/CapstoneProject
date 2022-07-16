part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingDetail> bookings;

  const BookingLoaded({required this.bookings});

  @override
  // TODO: implement props
  List<Object> get props => [bookings];
}
