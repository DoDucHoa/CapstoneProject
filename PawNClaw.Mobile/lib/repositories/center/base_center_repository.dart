import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

abstract class BaseCenterRepository {
  Future<SearchResponseModel?> searchCenterToBooking(
      DateTime timeFrom,
      int due,
      List<List<Pet>> requests,
      String city,
      String district,
      int PageNumber);
  Future<Center?> getCenterDetail(List<List<Pet>> requests, int centerId,
      DateTime timeFrom, DateTime timeTo);
}
