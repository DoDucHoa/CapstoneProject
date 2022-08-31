import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/components/checkout_today.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/components/nextup_tasks.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/components/todo_list.dart';

class TrackingActivities extends StatefulWidget {
  const TrackingActivities({
    Key? key,
  }) : super(key: key);

  @override
  State<TrackingActivities> createState() => _TrackingActivitiesState();
}

class _TrackingActivitiesState extends State<TrackingActivities> {
  @override
  Widget build(BuildContext context) {
    var state = (BlocProvider.of<BookingBloc>(context).state as BookingLoaded);
    return TabBarView(children: [
      // TodoList(bookings: state.bookings),
      CheckoutToday(bookings: state.bookings),
      NextUpTasks(bookings: state.bookings),
    ]);
  }
}
