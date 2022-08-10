import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/constants.dart';
import '../../../common/date_picker.dart';
import '../../../models/notification.dart' as noti;

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {required this.notification, required this.onPressed, Key? key})
      : super(key: key);
  final noti.Notification notification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(width * smallPadRate),
        margin:
            EdgeInsets.symmetric(horizontal: width * smallPadRate, vertical: 4),
        decoration: BoxDecoration(
          color: notification.seen == false
              ? primaryBackgroundColor
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(minHeight: height * 0.1),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title!,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, height: 1.2),
                ),
                Container(
                    width: width * 0.6,
                    child: Text(
                      notification.content!,
                      style: TextStyle(height: 1.2),
                    )),
                SizedBox(height: 10),
                Text(
                  timeAgo(DateTime.parse(notification.time!)),
                  style: TextStyle(
                      //fontStyle: FontStyle.italic,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          !notification.seen! ? primaryColor : lightFontColor,
                      height: 1),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: notification.seen! ? frameColor : Colors.white),
              child: Icon(
                  notification.actorType == 'Activity'
                      ? Iconsax.activity
                      : notification.actorType == 'Booking'
                          ? Iconsax.money_time
                          : Iconsax.document,
                  color: !notification.seen! ? primaryColor : lightFontColor),
            )
          ],
        ),
      ),
    );
  }
}
