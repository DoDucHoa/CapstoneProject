import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/models/account.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;
  BookingBloc({required BookingRepository bookingRepository})
      : this._bookingRepository = bookingRepository,
        super(BookingInitial()) {
    on<GetProcessingBooking>((event, emit) async {
      // TODO: implement event handler
      var result = await _bookingRepository.getProcessingBooking(
          staffId: event.user.id!);
      emit(BookingLoaded(bookings: result ?? []));
    });
  }
}
