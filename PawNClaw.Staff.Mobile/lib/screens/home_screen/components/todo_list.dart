import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key? key,
  }) : super(key: key);

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
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * smallPadRate,
                                  vertical: width * extraSmallPadRate,
                                ),
                                margin: EdgeInsets.only(
                                    bottom: width * extraSmallPadRate),
                                width: width * 0.7,
                                height: height * 0.095,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Cho ăn #CAGECODE",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: primaryFontColor,
                                          ),
                                        ),
                                        Text(
                                          "#CAGETYPE NAME",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: lightFontColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
