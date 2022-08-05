part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotification extends NotificationEvent {
  final int userId;

  const LoadNotification(this.userId);

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}
