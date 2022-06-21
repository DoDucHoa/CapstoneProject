import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/activity.dart';

import '../components/activity_card.dart';

class ActivityReportScreen extends StatefulWidget {
  final Activity activity;
  const ActivityReportScreen({required this.activity, Key? key})
      : super(key: key);

  @override
  State<ActivityReportScreen> createState() => _ActivityReportScreenState();
}

class _ActivityReportScreenState extends State<ActivityReportScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var activity = widget.activity;

    var _controller = TextEditingController();
    return Scaffold(
        backgroundColor: frameColor,
        appBar: AppBar(
            leading: IconButton(
          onPressed: (() => Navigator.of(context).pop()),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        )),
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 35),
        body: SingleChildScrollView(
            child: Column(children: [
          ActivityCard(activity: activity),
          //evidence
          Padding(
            padding: EdgeInsets.all(width * mediumPadRate),
            child: Column(children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(15),
              //   child: Image.asset(
              //     'lib/assets/center0.jpg',
              //     width: width * (1 - 2 * mediumPadRate),
              //     height: width * (1 - 2 * mediumPadRate) * 3 / 2,
              //     fit: BoxFit.cover,
              //   ),
              // ),
               Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      //margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextField(
                        controller: _controller,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Lí do",
                          hintText: 'Vấn đề của hoạt động này là gì?',
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)
                        ),
                        autofocus: false,
                      )),

              SizedBox(
                height: width * smallPadRate,
              ),
              //BUTTON
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      // primary: Cprim,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Container(
                    //width: width * (1 - 2 * regularPadRate),
                    padding:
                        EdgeInsets.symmetric(vertical: width * smallPadRate),
                    child: Center(
                      child: Text(
                        'Gửi báo cáo',
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
            ]),
          ),
        ])));
  }
}
