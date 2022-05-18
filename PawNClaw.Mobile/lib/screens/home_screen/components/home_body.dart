import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
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
                fontSize: width * smallFontRate,
                color: lightFontColor,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: width * 0.05),
              width: width * 0.85,
              height: height * 0.18,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15)),
            ),
            Text(
              "Tính năng",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: width * smallFontRate,
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
