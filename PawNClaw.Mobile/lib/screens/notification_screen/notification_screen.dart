import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/notification/notification_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/notification/notification_repository.dart';

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    color: Colors.black),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
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
            body: ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) => Container(
                child: Column(
                  children: [
                    Text(state.notifications[index].title!),
                    Text(state.notifications[index].content!),
                  ],
                ),
              ),
            ),
          );
        }
        return LoadingIndicator(loadingText: "vui long cho");
      },
    );
  }
}
