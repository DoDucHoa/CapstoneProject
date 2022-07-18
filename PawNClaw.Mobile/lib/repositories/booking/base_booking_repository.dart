import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';

abstract class BaseBookingRepository {
  Future<String> createBooking(BookingRequestModel booking);
}
