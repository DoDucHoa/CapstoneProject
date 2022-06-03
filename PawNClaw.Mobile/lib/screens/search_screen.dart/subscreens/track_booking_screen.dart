import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/booking_info_card.dart';

class TrackBooking extends StatefulWidget {
  const TrackBooking({required this.center, required this.booking, Key? key})
      : super(key: key);

  final petCenter.Center center;
  final BookingRequestModel booking;
  @override
  State<TrackBooking> createState() => _TrackBookingState();
}

class _TrackBookingState extends State<TrackBooking> {
  int currentstatus = 0;
  int maxStep = 4;
  List<String> STATUSLIST = [
    'Đặt lịch thành công',
    'Đã check-in tại trung tâm',
    'Đang tiến hành',
    'Hoàn thành'
  ];
  List<String> STATUSDESCRIPTIONS = [
    'Hãy đến trung tâm đúng giờ bạn nhé.',
    'Trung tâm đang tiến hành kiểm tra sức khỏe thú cưng.',
    'Trung tâm đang chăm sóc thú cưng của bạn.',
    'Hãy để lại đánh giá cho trung tâm nhé!'
  ];

  double lineLength = 50;

  @override
  Widget build(BuildContext context) {
    BookingRequestModel booking = widget.booking;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: regularPadRate * width,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: primaryFontColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
                height: height * 0.10,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(25),
                  //   bottomRight: Radius.circular(25),
                  // ),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: height * 0.04,
                      backgroundColor: lightPrimaryColor,
                      backgroundImage: AssetImage('lib/assets/vet-ava.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * smallPadRate),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.center.name!,
                            style: TextStyle(
                              fontSize: width * largeFontRate,
                              fontWeight: FontWeight.w500,
                              color: primaryFontColor,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: width * regularFontRate,
                                    color: primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.center.address,
                                  style: TextStyle(
                                    color: lightFontColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * smallFontRate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              BookingInfoCard(
                booking: booking,
              ),
              Container(
                  height: width / 4 * 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: lineLength - 18),
                          child: IconStepper(
                            icons: buildIcon(currentstatus),
                            onStepReached: (index) => setState(() {
                              currentstatus = index;
                            }),
                            activeStep: currentstatus,
                            direction: Axis.vertical,
                            lineLength: lineLength,
                            scrollingDisabled: true,
                            alignment: Alignment.topLeft,
                            stepPadding: 0,
                            stepRadius: 18,
                            activeStepBorderPadding: 0,
                            lineColor: lightFontColor,
                            enableNextPreviousButtons: false,
                            activeStepColor: primaryBackgroundColor,
                            stepColor: Colors.white,
                            activeStepBorderColor: Colors.white,
                            lineDotRadius: 0.7,
                            stepReachedAnimationEffect: Curves.easeIn,
                          )),
                      buildStatusCard(currentstatus, width)
                      //     Stepper(
                      //       onStepTapped: (value) => setState(() {
                      //         currentstatus = value;
                      //       }),

                      //       currentStep: currentstatus,
                      //   steps: [
                      //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus >= 0)? StepState.complete:StepState.indexed, isActive: (currentstatus >= 0)?true:false),
                      //     Step(title: Text(''), content: Text('Đặt lich thành công'),state:(currentstatus > 0)? StepState.complete:StepState.indexed, isActive: (currentstatus > 0)?true:false),
                      //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus > 1)? StepState.complete:StepState.indexed, isActive: (currentstatus > 1)?true:false),
                      //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus > 2)? StepState.complete:StepState.indexed, isActive: (currentstatus > 2)?true:false)
                      //   ],
                      // )
                    ],
                  ))
            ])));
  }

  List<Icon> buildIcon(int activeIndex) {
    List<Icon> iconList = [];
    for (var i = 0; i < maxStep; i++) {
      if (i == activeIndex)
        iconList.add(Icon(
          Icons.check_circle,
          color: primaryColor,
        ));
      else if (i < activeIndex)
        iconList.add(Icon(
          Icons.circle,
          color: primaryColor,
        ));
      else
        iconList.add(Icon(Icons.circle, color: lightFontColor));
    }
    return iconList;
  }

  Widget buildStatusCard(int activeIndex, double width) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (activeIndex > 0)
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildPreStatusCard(activeIndex, width)),
      Container(
        padding: EdgeInsets.only(top: 10),
        //margin: EdgeInsets.only(top: lineLength),
        child: Container(
            height: width / 4,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: frameColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(STATUSLIST[currentstatus],
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: width * (1 - mediumPadRate * 3 - regularPadRate),
                    child: Text(STATUSDESCRIPTIONS[currentstatus],
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: lightFontColor,
                            fontSize: 13)))
              ],
            )),
      )
    ]);
  }

  List<Widget> buildPreStatusCard(int activeIndex, double width) {
    List<Widget> list = [];
    for (var i = 0; i < activeIndex; i++) {
      list.add(Container(
        width: width * (1 - mediumPadRate * 3 - regularPadRate),
        padding: EdgeInsets.only(
            top: lineLength,
            bottom: lineLength - 18 - width * extraSmallPadRate),
        //margin: EdgeInsets.only(bottom:(lineLength*currentstatus)/2 - 18 - width*smallPadRate),
        child: Text(STATUSLIST[i],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: lightFontColor,
                fontSize: 13)),
      ));
    }
    return list;
  }
}
