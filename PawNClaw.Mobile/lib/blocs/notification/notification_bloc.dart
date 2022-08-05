import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawnclaw_mobile_application/models/notification.dart';
import 'package:pawnclaw_mobile_application/repositories/notification/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  NotificationBloc(NotificationRepository notificationRepository)
      : _notificationRepository = notificationRepository,
        super(NotificationInitial()) {
    on<LoadNotification>((event, emit) async {
      // TODO: implement event handler
      var values = await _notificationRepository.getNotification(event.userId);
      emit(NotificationLoaded(values!));
      await _notificationRepository.seenAll(event.userId);
    });
  }
}
