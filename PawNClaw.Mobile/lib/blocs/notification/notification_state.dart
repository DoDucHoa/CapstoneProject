part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<Notification> notifications;

  const NotificationLoaded(this.notifications);

  @override
  // TODO: implement props
  List<Object> get props => [notifications];
}
