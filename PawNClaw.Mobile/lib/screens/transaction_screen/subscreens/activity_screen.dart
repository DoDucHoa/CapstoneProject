import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
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
                                  'Đây là bằng chứng được cung cấp từ phía trung tâm trong quá trình cung cấp dịch vụ. Nếu bạn thấy bằng chứng chưa thuyết phục, xin hãy trao đổi với trung tâm bằng [Liên hệ với trung tâm]. Trong trường hợp trung tâm vẫn chưa giải quyết thỏa đáng, xin hãy [Báo cáo hoạt động này]',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                PrimaryButton(text: 'Đóng', onPressed: ()=> Navigator.of(context).pop(), contextWidth: width)
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
        // title: Text('Chi tiết hoạt động', style: TextStyle(color: Colors.black, fontSize: 18),),
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
                          ? FadeInImage.assetNetwork(placeholder: 'lib/assets/new-paw.gif', image:
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
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) =>
                  //               ActivityReportScreen(activity: activity)));
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Colors.white,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(15))),
                  //     child: Container(
                  //       //width: width*(1 - 2*regularPadRate),
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: width * smallPadRate,
                  //       ),
                  //       child: Center(
                  //         child: Text(
                  //           'Báo cáo hoạt động này',
                  //           style: TextStyle(
                  //               color: primaryColor,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w700),
                  //         ),
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: width * smallPadRate,
                  // ),
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
                            'Liên hệ với trung tâm',
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
