import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';

class BookingInfoCard extends StatelessWidget {
  const BookingInfoCard({required this.booking, Key? key}) : super(key: key);

  final BookingRequestModel booking;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool haveDiscount = false;
    return Container(
      child: Column(children: [
        Container(
          color: primaryBackgroundColor,
          height: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        Container(
            color: primaryBackgroundColor,
            padding: EdgeInsets.all(width * smallPadRate),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: width * smallPadRate),
                  width: width,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "TH???I GIAN",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w600,
                              fontSize: width * regularFontRate,
                            ),
                          ),
                          IconButton(
                              //color: Colors.white,
                              // padding: EdgeInsets.all(0),

                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            padding: EdgeInsets.all(20),
                                            width: width * 0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Th???i gian Checkout d??? ki???n ???????c d???a theo quy ?????nh c???a trung t??m. Trung t??m s??? thu th??m ph?? n???u b???n ?????n ????n c??c b?? sau th???i gian n??y nh??!',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('????ng'))
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: Icon(
                                Icons.info_rounded,
                                color: primaryColor,
                                size: 18,
                              ),
                            )
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
                                      DateTime.parse(booking
                                          .bookingCreateParameter!
                                          .startBooking!)),
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
                                      DateTime.parse(booking
                                          .bookingCreateParameter!
                                          .endBooking!)),
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
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: primaryBackgroundColor,
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
                                      height: 1,
                                      width: 5,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: primaryBackgroundColor)),
                                    )),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: primaryBackgroundColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)))),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * smallPadRate,
                  ),
                  // margin:
                  //     EdgeInsets.symmetric(horizontal: width * mediumPadRate),
                  width: width,
                  height: height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white,
                    //border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "CHI PH?? D??? KI???N",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w600,
                              fontSize: width * regularFontRate,
                            ),
                          ),
                          IconButton(
                              //color: Colors.white,
                              // padding: EdgeInsets.all(0),

                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            padding: EdgeInsets.all(20),
                                            width: width * 0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Chi ph?? tr??n ???????c t??nh theo d??? ki???n, c?? th??? thay ?????i trong qu?? tr??nh trung t??m cung c???p d???ch v???.',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('????ng'))
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: Icon(
                                Icons.info_rounded,
                                color: primaryColor,
                                size: 18,
                              ),
                            )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "D???ch v???",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(booking.getTotalService()) +
                                "??",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "????? d??ng",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(booking.getTotalSupply()) +
                                "??",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chi ph?? kh??ch s???n x " +
                                booking.bookingDetailCreateParameters!.first
                                    .duration!
                                    .toStringAsFixed(0) +
                                " gi???",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(booking.getTotalCage()) +
                                "??",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          )
                        ],
                      ),
                      (haveDiscount)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gi???m gi??",
                                  style: TextStyle(
                                    color: primaryFontColor,
                                    fontSize: width * regularFontRate * 0.8,
                                  ),
                                ),
                                Text(
                                  "-200.000 ??",
                                  style: TextStyle(
                                    color: primaryFontColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * regularFontRate * 0.8,
                                  ),
                                )
                              ],
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      Container(
                        width: width,
                        height: 1.5,
                        color: Colors.black12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "T???ng ti???n",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(booking.getTotal()) +
                                "??",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w800,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Container(
          color: primaryBackgroundColor,
          height: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
