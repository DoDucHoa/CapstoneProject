import 'package:flutter/material.dart';

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
              "Promotion",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black45,
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
              "Feature",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black45,
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
          ],
        ),
      ),
    );
  }
}
