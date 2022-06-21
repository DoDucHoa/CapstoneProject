import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';

class BookingInfoCard extends StatelessWidget {
  const BookingInfoCard({required this.booking, required this.details, Key? key}) : super(key: key);

  final Booking booking;
  final TransactionDetails details;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool haveDiscount = booking.discount != 0;
    bool haveSupplyOrder = details.getTotalSupplies() != 0;
    bool haveServiceOrder = details.getTotalServices() != 0;

    int lines = 3;
    if (haveDiscount) lines++;
    if (haveServiceOrder) lines++;
    if (haveSupplyOrder) lines++;

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "THỜI GIAN",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: width * regularFontRate,
                        ),
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
                                      DateTime.parse(booking.startBooking!.toString())),
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
                                      DateTime.parse(booking.endBooking!.toString())),
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
                  height: height * lines*smallPadRate + 20,
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
                              "CHI PHÍ DỰ KIẾN",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w600,
                                fontSize: width * regularFontRate,
                              ),
                            ),
                            // SizedBox(
                            //   width: 5,
                            // ),
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
                                                  'Chi phí trên được tính theo dự kiến, có thể thay đổi trong quá trình trung tâm cung cấp dịch vụ.',
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
                                                    child: Container(width: width*(0.5 - 2*extraSmallPadRate),child: Center(child: Text('Đóng'))))
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
                           if (haveServiceOrder) Text(
                            "Dịch vụ",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          if (haveServiceOrder)Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(details.getTotalServices()) +
                                "đ",
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
                          if (haveSupplyOrder) Text(
                            "Đồ dùng",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                           if (haveSupplyOrder)Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(details.getTotalSupplies()) +
                                "đ",
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
                            "Chi phí khách sạn x " +
                                details.bookingDetails!.first.duration!
                                    .toStringAsFixed(0) +
                                " giờ",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: '',
                                ).format(details.getTotalCages()) +
                                "đ",
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
                                  "Giảm giá",
                                  style: TextStyle(
                                    color: primaryFontColor,
                                    fontSize: width * regularFontRate * 0.8,
                                  ),
                                ),
                                Text(
                                  "-200.000 đ",
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
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tổng tiền",
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
                                ).format(booking.total) +
                                "đ",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.w800,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
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
