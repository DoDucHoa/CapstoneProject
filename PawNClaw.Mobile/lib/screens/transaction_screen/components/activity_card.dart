import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/activity_screen.dart';

import '../../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({required this.activity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: (() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ActivityScreen(activity: activity)));
        }),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Row(children: [
              Container(
                margin: EdgeInsets.all(width * extraSmallPadRate + 5),
                height: 55,
                child: ClipRRect(
                  child: (activity.product!.imgUrl.isEmpty)
                      ? Image.asset((activity.type!.id == 0)
                          ? "lib/assets/cage.png"
                          : (activity.type!.id == 1)
                              ? "lib/assets/supply.png"
                              : "lib/assets/service.png")
                      : Image.network(activity.product!.imgUrl),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: width * 0.6,
                      child: Text(
                        activity.product!.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Container(
                      width: width * 0.6,
                      child: Text(
                        activity.product!.note,
                        style: TextStyle(
                            color: lightFontColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Text(
                      '   ●  ' +
                          DateFormat('HH:mm a, dd/MM/yyyy')
                              .format(DateTime.parse(activity.time.toString())),
                      style: TextStyle(
                          color: lightFontColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              )
            ]),
            SizedBox(
              height: 2,
              width: width,
              child: DecoratedBox(decoration: BoxDecoration(color: frameColor)),
            ),
            Row(children: [
              Container(
                  margin: EdgeInsets.all(width * extraSmallPadRate + 5),
                  height: 35,
                  child: (activity.pet!.photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (activity.pet!.petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(activity.pet!.photos!.first.url!),
                        ) // borderRadius: BorderRadius.circular(35),),
                  ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.pet!.name!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(activity.pet!.breedName!,
                      style: TextStyle(color: lightFontColor, fontSize: 13)),
                ],
              )
            ]),
          ]),
        ));
  }
}
