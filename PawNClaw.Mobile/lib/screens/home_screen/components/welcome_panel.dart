import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/components/elevated_container.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

class WelcomePanel extends StatelessWidget {
  const WelcomePanel({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: height * 0.35,
        ),
        Container(
          padding: EdgeInsets.all(width * regularPadRate),
          height: height * 0.3,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                lightPrimaryColor,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Xin chào ",
                          style: TextStyle(
                            fontSize: width * regularFontRate,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: username + ",",
                          style: TextStyle(
                            fontSize: width * regularFontRate,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        "Bạn có   ",
                        style: TextStyle(
                          fontSize: width * regularFontRate,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: width * 0.02, horizontal: width * 0.04),
                        height: width * regularFontRate * 1.8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(right: 2),
                              height: width * smallFontRate * 1.4,
                              width: width * smallFontRate * 1.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text('2',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: lightPrimaryColor,
                                          fontWeight: FontWeight.w700))),
                            ),
                            Text(
                              " Lịch hẹn",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Text(
                    "trong hôm nay.",
                    style: TextStyle(
                      fontSize: width * regularFontRate,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                ],
              ),
              CircleAvatar(
                radius: width * 0.12,
                backgroundColor: Colors.white,
                backgroundImage: null,
              )
            ],
          ),
        ),
        Positioned(
          child: ElevatedContainer(
            height: height * 0.06,
            width: width * 0.7,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                hintText: "Tìm kiếm trung tâm thú cưng",
                hintStyle: TextStyle(
                    color: lightFontColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                border: InputBorder.none,
              ),
            ),
            elevation: width * 0.015,
          ),
          top: height * 0.27,
          left: width * 0.1,
          right: width * 0.1,
        ),
      ],
    );
  }
}
