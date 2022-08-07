part of 'sponsor_bloc.dart';

abstract class SponsorEvent extends Equatable {
  const SponsorEvent();

  @override
  List<Object> get props => [];
}

class InitSponsorBanner extends SponsorEvent{}

class GetCenterAtBanner extends SponsorEvent{
  final int brandId;

  const GetCenterAtBanner(this.brandId);

  @override
  // TODO: implement props
  List<Object> get props => [brandId];
}