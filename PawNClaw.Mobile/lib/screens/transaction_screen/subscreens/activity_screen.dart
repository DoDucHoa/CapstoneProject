import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/activity.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/activity_card.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/activity_report_screen.dart';

class ActivityScreen extends StatefulWidget {
  final Activity activity;
  const ActivityScreen({required this.activity, Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    var activity = widget.activity;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: frameColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() => Navigator.of(context).pop()),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 35,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            padding: EdgeInsets.all(20),
                            width: width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '????y l?? b???ng ch???ng ???????c cung c???p t??? ph??a trung t??m trong qu?? tr??nh cung c???p d???ch v???. N???u b???n th???y b???ng ch???ng ch??a thuy???t ph???c, xin h??y trao ?????i v???i trung t??m b???ng [Li??n h??? v???i trung t??m]. Trong tr?????ng h???p trung t??m v???n ch??a gi???i quy???t th???a ????ng, xin h??y [B??o c??o ho???t ?????ng n??y]',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        width: width * (0.5 - 2 * smallPadRate),
                                        child: Center(child: Text('????ng'))))
                              ],
                            ),
                          ),
                        ));
              },
              icon: Icon(
                Icons.info_rounded,
                color: primaryColor,
              ))
        ],
        // title: Text('Chi ti???t ho???t ?????ng', style: TextStyle(color: Colors.black, fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ActivityCard(activity: activity),
            //evidence
            Padding(
              padding: EdgeInsets.all(width * mediumPadRate),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (activity.imgUrl != null)
                          ? FadeInImage.assetNetwork(placeholder: 'lib/assets/paw-gif.gif', image:
                              activity.imgUrl!,
                              width: width * (1 - 2 * mediumPadRate),
                              height: width * (1 - 2 * mediumPadRate) * 3 / 2,
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.scaleDown,
                             
                            )
                          : Image.asset(
                              'lib/assets/center0.jpg',
                              width: width * (1 - 2 * mediumPadRate),
                              height: width * (1 - 2 * mediumPadRate) * 3 / 2,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: width * smallPadRate,
                  ),
                  //BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ActivityReportScreen(activity: activity)));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Container(
                        //width: width*(1 - 2*regularPadRate),
                        padding: EdgeInsets.symmetric(
                          vertical: width * smallPadRate,
                        ),
                        child: Center(
                          child: Text(
                            'B??o c??o ho???t ?????ng n??y',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: width * smallPadRate,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          // primary: Cprim,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Container(
                        //width: width * (1 - 2 * regularPadRate),
                        padding: EdgeInsets.symmetric(
                            vertical: width * smallPadRate),
                        child: Center(
                          child: Text(
                            'Li??n h??? v???i trung t??m',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: width * mediumPadRate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
