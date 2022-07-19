import 'package:pawnclaw_mobile_application/models/area.dart';

abstract class BaseAreaRepository {
  Future<List<Area>?> getAllArea();

  Future<List<Districts>?> getDistrictsByArea(String cityCode);
}
