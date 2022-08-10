import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/notification/notification_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/common/date_picker.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/repositories/activity/activity_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/notification/notification_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/transaction_repository.dart';
import 'package:pawnclaw_mobile_application/screens/notification_screen/components/noti_card.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/activity_list_screen.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/activity_screen.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/transaction_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoaded) {
          return Scaffold(
            backgroundColor: frameColor,
            appBar: AppBar(
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back_ios_new_outlined,
              //       color: Colors.black),
              //   onPressed: () =>
              //       Navigator.of(context).popUntil((route) => route.isFirst),
              // ),
              leading: Container(),
              leadingWidth: 0,
              title: Text(
                'Thông báo',
                style: TextStyle(
                    color: primaryFontColor,
                    fontWeight: FontWeight.w500,
                    fontSize: width * regularFontRate),
              ),
              backgroundColor: frameColor,
              elevation: 0,
            ),
            body: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: 5, width: width),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  var notification = state.notifications[index];
                  return NotificationCard(
                      notification: notification,
                      onPressed: () async {
                        if (notification.actorType == "Activity") {
                          var activity = await ActivityRepository()
                              .getActivityById(notification.actorId!);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityScreen(activity: activity!),
                            ),
                          );
                        }
                        if (notification.actorType == "Booking") {
                          var bookings = await TransactionRepository()
                              .getTransactions(notification.targetId!);
                          var booking = bookings!.firstWhere(
                              (element) => element.id == notification.actorId);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TransactionDetailsScreen(booking: booking),
                            ),
                          );
                        }
                      });
                }),
          );
        }
        return LoadingIndicator(loadingText: "Vui lòng đợi...");
      },
    );
  }
}
