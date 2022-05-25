import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

class BookingInfoCard extends StatelessWidget {
  const BookingInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            padding: EdgeInsets.all(width*smallPadRate),
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
                                  "03:00 PM, 11/05/2022",
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
                                  "03:00 PM, 11/05/2022",
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
                  height: height * 0.3,
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
                      Text(
                        "THÔNG TIN HÓA ĐƠN",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: width * regularFontRate,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dịch vụ",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            "200.000 đ",
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
                            "Đồ dùng",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            "200.000 đ",
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
                            "Chi phí khách sạn x 2 giờ",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                            ),
                          ),
                          Text(
                            "200.000 đ",
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
                            "Tổng tiền",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * regularFontRate * 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "400.000 đ",
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
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
