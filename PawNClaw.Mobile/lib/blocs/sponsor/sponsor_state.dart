part of 'sponsor_bloc.dart';

abstract class SponsorState extends Equatable {
  const SponsorState();
  
  @override
  List<Object> get props => [];
}

class SponsorInitial extends SponsorState {}

class LoadedBanners extends SponsorState{
  final List<SponsorBanner> banners;
  final List<String> photoURLs;
  final List<int> durations;
  const LoadedBanners(this.banners, this.photoURLs, this.durations);
  @override
  // TODO: implement props
  List<Object> get props => [banners];
}

class LoadedCenters extends SponsorState{
  final List<Center> centers;
  const LoadedCenters(this.centers);

  @override
  // TODO: implement props
  List<Object> get props => [centers];
}

class Loading extends SponsorState{}