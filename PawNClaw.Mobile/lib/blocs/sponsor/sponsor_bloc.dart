import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/sponsor_banner.dart';
import 'package:pawnclaw_mobile_application/repositories/sponsor_banner/sponsor_repository.dart';

import '../../models/center.dart';

part 'sponsor_event.dart';
part 'sponsor_state.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  final SponsorRepository _sponsorRepository = SponsorRepository();
  SponsorBloc() : super(SponsorInitial()) {
    on<InitSponsorBanner>((event, emit)  async{
      final banners = await _sponsorRepository.getSponsorBanners();
      if (banners != null){
         var photoUrl = banners.map(((element) { if (element.photos != null) {return element.photos!.first.url!;} return 'lib/assets/center0.jpg';})).toList();
         var durations = banners.map(((element) => element.duration!.toInt() )).toList();

        emit(LoadedBanners(banners, photoUrl, durations));
      }
    });

    on<GetCenterAtBanner>((event, emit) async {
      final centers = await  _sponsorRepository.getCentersByBrandId(event.brandId);
      if (centers != null){
        emit(LoadedCenters(centers));
      }
    });
  }
}
