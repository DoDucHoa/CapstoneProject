import 'package:geolocator/geolocator.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';

abstract class BaseCenterRepository {
  Future<SearchResponseModel?> searchCenterToBooking(DateTime timeFrom, int due,
      List<List<Pet>> requests, String city, String district, int pageNumber, int customerId);
  Future<Center?> getCenterDetail(List<List<Pet>> requests, int centerId,
      DateTime timeFrom, DateTime timeTo);
  Future<List<Center>?> getCentersByName(
      String searchValue, int pageNumber, int pageSize);
  Future<List<Center>?> getAllCenter();
  Future<Center?> getCenterOverview(int centerId);
  Future<SearchResponseModel?> checkCenterToBooking(
      int centerId, int customerId, DateTime timeFrom, int due, List<List<Pet>> requests);
  Future<List<Voucher>?> getCenterVouchers(int centerId, int customerId);
  Future<Position?> getCurrentLocation();
  Future<String?> getAddress(Position position);
  Future<List<LocationResponseModel>?> getCentersNearby(
      String latitude, String longitude);
}
