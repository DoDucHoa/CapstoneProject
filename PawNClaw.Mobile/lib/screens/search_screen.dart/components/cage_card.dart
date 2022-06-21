import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';

import '../subscreens/cage_details_screen.dart';

class CageCard extends StatelessWidget {
  final Cages cage;
  final CageTypes cageType;
  const CageCard({Key? key, required this.cage, required this.cageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => CageDetails(cage: cage,cageType: cageType,),
        //   ));
        // },
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cage.name!,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  NumberFormat.currency(
                    decimalDigits: 0,
                    symbol: 'đ',
                  ).format(cageType.totalPrice),
                  //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  width: 5,
                ),
                // if (cage.discount! > 0)
                //   Text(
                //     NumberFormat.currency(
                //       decimalDigits: 0,
                //       symbol: '',
                //     ).format(cage.price),
                //     style: TextStyle(
                //         fontSize: 13,
                //         color: lightFontColor,
                //         decoration: TextDecoration.lineThrough),
                //   ),
                // SizedBox(
                //   width: 5,
                // ),
                // if (cage.discount! > 0)
                //   Padding(
                //       padding: const EdgeInsets.only(right: 5, bottom: 5),
                //       child: Container(
                //         padding: EdgeInsets.all(11 * 0.4),
                //         decoration: BoxDecoration(
                //           color: primaryColor,
                //           borderRadius: BorderRadius.circular(15),
                //           //border: Border.all(width: 1),
                //         ),
                //         child: Text(
                //           '  Khuyến mãi  ',
                //           style: TextStyle(
                //               fontSize: 11,
                //               color: Colors.white,
                //               fontWeight: FontWeight.w700),
                //         ),
                //       )),
              ],
            ),
            // cage.discount! > 0 ?
            SizedBox(
              height: 20,
            ),
          ],
        ),
        Positioned(
          right: 5,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('lib/assets/cage.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   child: Divider(color: lightFontColor.withOpacity(0.1),thickness: 1.5,),)
      ]),
    ));
  }
}
