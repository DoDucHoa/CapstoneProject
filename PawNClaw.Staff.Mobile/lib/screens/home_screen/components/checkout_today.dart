import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';

class CheckoutToday extends StatelessWidget {
  const CheckoutToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${Localization().convertWeekDay(DateFormat('EEEE').format(DateTime.now()))}, ${DateFormat('d').format(DateTime.now())} tháng ${DateFormat('M').format(DateTime.now())}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: primaryFontColor,
            ),
          ),
          ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: width * smallPadRate),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width * smallPadRate),
                      child: Text(
                        "09:00",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: lightFontColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.only(bottom: width * 0.05),
                                padding: EdgeInsets.all(width * 0.05),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: width * extraSmallPadRate,
                                            bottom: width * extraSmallPadRate,
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "lib/assets/cus0.png"),
                                            backgroundColor: Colors.white,
                                            radius: height * 0.04,
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.08,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Alice Smith",
                                                style: TextStyle(
                                                  color: primaryFontColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.45,
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Container(
                                                          height: 18,
                                                          width: 15,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                lightPrimaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              // pets.length.toString(),
                                                              "3",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "Abby (Golden Retriever), Alice (Scottish Cat)",
                                                        // " " +
                                                        //     pets.fold(
                                                        //         "",
                                                        //         (previousValue, element) =>
                                                        //             previousValue +
                                                        //             (previousValue == "" ? "" : ", ") +
                                                        //             element.name! +
                                                        //             " " +
                                                        //             "(" +
                                                        //             element.breedName! +
                                                        //             ")"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: lightFontColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: frameColor,
                                      thickness: 2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: width * extraSmallPadRate),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            // "07:30 AM, 9 tháng 2",
                                            "09:30 AM",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          // (booking.totalService != null || booking.totalSupply != null)
                                          (true)
                                              ? Row(
                                                  children: [
                                                    // (booking.totalService != null)
                                                    (true)
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  lightPrimaryColor,
                                                            ),
                                                            child: Text(
                                                              "Dịch vụ",
                                                              style: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    // (booking.totalSupply != null)
                                                    (true)
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  lightPrimaryColor,
                                                            ),
                                                            child: Text(
                                                              "Đồ dùng",
                                                              style: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
