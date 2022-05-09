import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

class WelcomePanel extends StatelessWidget {
  const WelcomePanel({
    Key? key,
    required this.height,
    required this.width,
    required this.username,
  }) : super(key: key);

  final double height;
  final double width;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: height * 0.35,
        ),
        Container(
          padding: EdgeInsets.all(28),
          height: height * 0.3,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.5),
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
                  Spacer(
                    flex: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Hi ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: username + ",",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        "You have   ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 8,
                            ),
                            Text(
                              " Bookings",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    "coming up today.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: null,
              )
            ],
          ),
        ),
        Positioned(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 4.0,
                left: 1,
                right: 1,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              height: height * 0.06,
              width: width * 0.7,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  hintText: "Search centers, clinics and stores",
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          top: height * 0.27,
          left: width * 0.1,
          right: width * 0.1,
        ),
      ],
    );
  }
}
