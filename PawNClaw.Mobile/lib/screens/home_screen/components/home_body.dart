import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/confirm_booking.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart';

import '../../transaction_screen/subscreens/transaction_list_screen.dart';

var FeatureIcons = [
  Icons.location_city_rounded,
  FontAwesomeIcons.moneyBillWave,
  Icons.person,
  Icons.settings,
];
var FeatureNames = [
  'Khách sạn',
  'Đơn hàng',
  'Profile',
  'Settings',
];

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
          mainAxisSize: MainAxisSize.max,
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
                    color: Colors.white,
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
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const SearchScreen(),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     margin: EdgeInsets.symmetric(vertical: width * smallPadRate),
            //     width: width * 0.85,
            //     height: height * 0.18,
            //     decoration: BoxDecoration(
            //         color: Colors.black26,
            //         borderRadius: BorderRadius.circular(15)),
            //   ),
            // ),
            GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing:  width * 0.075, crossAxisSpacing: width * 0.075),
              itemBuilder: ((context, index) =>BuildFeatureCard(index, context)),
              itemCount: 4,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,

            ),
          ],
        ),
      ),
    );
  }

  Widget BuildFeatureCard(int index, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionList(),
              ),
            );
            break;
        }
      },
      child: Container(
        
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: width * 0.05),
                child: Icon(
                  FeatureIcons[index],
                  size: width * 0.15,
                  color: primaryColor,
                ),
              ),
              Text(
                FeatureNames[index],
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: width * smallFontRate,
                  color: lightFontColor,
                ),
              ),
            ]),
        ),
    );
  }
}
