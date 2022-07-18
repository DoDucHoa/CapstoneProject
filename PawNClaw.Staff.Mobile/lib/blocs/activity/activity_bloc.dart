import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial()) {
    on<InitActivity>((event, emit) {
      // TODO: implement event handler
    });
  }
}
