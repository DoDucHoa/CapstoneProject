import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/track_booking_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BookingSuccess extends StatefulWidget {
  const BookingSuccess({Key? key}) : super(key: key);

  @override
  State<BookingSuccess> createState() => _BookingSuccessState();
}

class _BookingSuccessState extends State<BookingSuccess> {
  //double value = 0;

  @override
  void initState() {
    // TODO: implement initState
    //_animationController = AnimationController(...);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: width * regularPadRate),
          margin: EdgeInsets.symmetric(
              vertical: width/3, horizontal: width * regularPadRate),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              //SizedBox(height: ,)
              TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1200),
                  curve: Curves.easeOut,
                  builder: (context, value, child) => SizedBox(
                      width: width / 2,
                      height: width / 2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: double.parse(value.toString()),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                            strokeWidth: 15,
                            
                            // radius: width / 4,
                            // lineWidth: 18,
                            // percent: double.parse(value.toString()),
                            // animation: true,
                            // circularStrokeCap: CircularStrokeCap.round,
                            // progressColor: primaryColor,
                            // center: (double.parse(value.toString()) == 1)?
                            // Center(
                            //   child: Icon(
                            //     Icons.check_rounded,
                            //     size: width / 3,
                            //     color: primaryColor,
                            //   ),
                            // ):Text(''),
                            backgroundColor: lightPrimaryColor,
                          ),
                          (double.parse(value.toString()) == 1)
                              ? Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: width / 3,
                                    color: primaryColor,
                                  ),
                                )
                              : Text(''),
                        ],
                      ))),
              SizedBox(
                height: width * smallPadRate,
                
              ),
              Text('Congratulations!'),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * mediumPadRate,
                  vertical: width * smallPadRate,
                ),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TrackBooking()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text(
                          "ĐÓNG",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              )
            ],
          )),
    );
  }
}
