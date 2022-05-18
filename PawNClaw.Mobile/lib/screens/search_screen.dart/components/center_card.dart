import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

class CenterCard extends StatelessWidget {
  const CenterCard({
    required this.center,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  final petCenter.Center center;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: width,
        height: height * 0.25,
        margin: EdgeInsets.symmetric(
          horizontal: width * regularPadRate,
          vertical: width * smallPadRate,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              backgroundColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                height: height * 0.15,
                width: width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('lib/assets/center0.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: width * smallPadRate * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    center.name!,
                    style: TextStyle(
                        fontSize: width * largeFontRate,
                        fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.location_on,
                            size: width * regularFontRate,
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: center.address,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: width * smallFontRate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        child: const Icon(Icons.star_border_outlined, size: 18),
        bottom: width * 0.1,
        right: width * 0.15,
      )
    ]);
  }
}
