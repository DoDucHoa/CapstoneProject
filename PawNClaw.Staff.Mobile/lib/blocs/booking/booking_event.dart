part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class GetProcessingBooking extends BookingEvent {
  final Account user;
  const GetProcessingBooking({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
