import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/transaction/transaction_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/transaction_details_screen.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/transaction_list_screen.dart';

import '../../../models/booking.dart';

var statusColors = [
  primaryColor.withOpacity(0.45),
  primaryColor,
  primaryColor.withOpacity(0.45),
  Colors.red
];

class TransactionCard extends StatelessWidget {
  final Booking booking;
  final double size;
  const TransactionCard({required this.booking, required this.size, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print('status: ' + booking.status!.id.toString());

   
    return InkWell(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetailsScreen(
                      booking: booking,
                      redirect:  TransactionList()
                    )));
      }),
      child: Column(
        children: [
          Container(
              height: size * 0.6,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('HH:mm a, dd/MM/yyyy').format(
                                DateTime.parse(booking.createTime!.toString())),
                            style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(booking.status!.name!,
                              style: TextStyle(
                                  color: statusColors[booking.statusId! - 1],
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(width * smallPadRate * 0.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "CHECK IN",
                                  style: TextStyle(
                                    color: lightFontColor,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm, dd/MM/yyyy').format(
                                      DateTime.parse(
                                        (booking.checkIn == null)?
                                          booking.startBooking!.toString() 
                                          : booking.checkIn!.toString(),)),
                                  style: TextStyle(
                                    color: primaryFontColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * smallFontRate,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 1.5,
                              height: height * 0.04,
                              color: lightFontColor,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "CHECK OUT",
                                  style: TextStyle(
                                    color: lightFontColor,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm, dd/MM/yyyy').format(
                                      DateTime.parse(
                                        (booking.checkOut == null)?
                                          booking.endBooking!.toString() : 
                                          booking.checkOut!.toString(),)),
                                  style: TextStyle(
                                    color: primaryFontColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * smallFontRate,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              )),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: frameColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)))),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          (constraints.constrainWidth() / 10).floor(),
                          (index) => SizedBox(
                                height: 2,
                                width: 5,
                                child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: frameColor)),
                              )),
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: frameColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)))),
                ),
              ],
            ),
          ),
          Container(
              height: size * 0.35,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [
                    Container(
                      height: 30,
                      width: 30,
                      child: (booking.center!.getThumbnail() == null) ? CircleAvatar(
                          backgroundImage:
                              AssetImage('lib/assets/vet-ava.png')):CircleAvatar(
                          backgroundImage:
                              NetworkImage(booking.center!.getThumbnail()!.url!)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 15,
                      child: Text(
                        booking.center!.name!,
                        style: TextStyle(fontSize: 15, height: 1),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                          .format(booking.total),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    )
                  ])))
        ],
      ),
    );
  }
}
