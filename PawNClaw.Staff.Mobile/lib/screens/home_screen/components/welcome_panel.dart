import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/components/elevated_container.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';

class WelcomePanel extends StatelessWidget {
  const WelcomePanel({Key? key, required this.username, required this.bookings})
      : super(key: key);

  final String username;
  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: height * 0.1,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: height * 0.08,
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
                ElevatedContainer(
                  height: height * 0.06,
                  width: width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      hintText: "Tìm kiếm thú cưng hay khách hàng",
                      hintStyle: TextStyle(
                          color: lightFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                  elevation: width * 0.015,
                ),
                CircleAvatar(
                  radius: height * 0.03,
                  backgroundColor: Colors.white,
                  backgroundImage: null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
