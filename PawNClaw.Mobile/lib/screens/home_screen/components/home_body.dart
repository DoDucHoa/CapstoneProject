import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/confirm_booking.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.075),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Khuyến mãi",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: width * regularFontRate,
                color: lightFontColor,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: width * 0.05),
                width: width * 0.85,
                height: height * 0.18,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            Text(
              "Tính năng",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: width * regularFontRate,
                color: lightFontColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: width * smallPadRate),
                width: width * 0.85,
                height: height * 0.18,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
