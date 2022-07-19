import 'package:pncstaff_mobile_application/models/pet_center.dart';

abstract class BaseCenterRepository {
  Future<PetCenter> getCenterByStaff(int id);
}
