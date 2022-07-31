import 'package:pawnclaw_mobile_application/models/sponsor_banner.dart';

import '../../models/center.dart';

abstract class BaseSponsorRepository{
  
  Future<List<SponsorBanner>?> getSponsorBanners();
  Future<List<Center>?> getCentersByBrandId(int brandId);

}