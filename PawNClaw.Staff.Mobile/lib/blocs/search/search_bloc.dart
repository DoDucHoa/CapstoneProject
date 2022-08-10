import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BookingRepository _bookingRepository;
  SearchBloc({required BookingRepository bookingRepository})
      : this._bookingRepository = bookingRepository,
        super(SearchInitial()) {
    on<SearchByCagecode>((event, emit) async {
      // TODO: implement event handler
      try {
        var booking = await _bookingRepository.searchBookingByCagecode(
            centerId: event.centerId, cageCode: event.cageCode);

        emit(SearchDone(booking, event.cageCode));
      } catch (e) {
        emit(SearchFail(e.toString()));
      }
    });
    on<ClearSearch>(
      (event, emit) {
        emit(SearchInitial());
      },
    );
  }
}
