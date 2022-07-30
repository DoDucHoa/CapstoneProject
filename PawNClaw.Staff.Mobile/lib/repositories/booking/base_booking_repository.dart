import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';

abstract class BaseBookingRepository {
  Future<List<BookingDetail>?> getProcessingBooking({required int staffId});
  Future<BookingDetail>? searchBookingByCagecode(
      {required int centerId, required String cageCode});
  Future<BookingDetail> getBookingDetail({required int bookingId});
}
