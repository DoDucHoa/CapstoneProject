part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class InitActivity extends ActivityEvent {
  final BookingDetail booking;

  const InitActivity({required this.booking});

  @override
  // TODO: implement props
  List<Object> get props => [booking];
}
