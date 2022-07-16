import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.bookings}) : super(key: key);

  final List<BookingDetail> bookings;
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<BookingDetails> getFeedByTime(
      List<BookingDetails> bookings, String time) {
    List<BookingDetails> result = [];
    bookings.forEach((element) {
      element.remainFoodSchedules()!.forEach((food) {
        if (food.fromTime == time) {
          result.add(element);
        }
      });
    });
    result = [
      ...{...result}
    ];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var bookings = widget.bookings;
    List<String> times = [];
    bookings.forEach((element) {
      times.addAll(element.getAllStartTime());
    });
    times = [
      ...{...times}
    ];
    List<BookingDetails> remainFeedingActivites = [];
    times.forEach(
      (element) {
        bookings.forEach((booking) {
          booking.bookingDetails!.forEach((detail) {
            detail.remainFoodSchedules()?.forEach((food) {
              if (food.fromTime == element) {
                remainFeedingActivites.add(detail);
              }
            });
          });
        });
      },
    );
    print(remainFeedingActivites);
    print(getFeedByTime(remainFeedingActivites, times[1]));
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
            itemCount: times.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: width * smallPadRate),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width * smallPadRate),
                      child: Text(
                        times[index].substring(0, 5),
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
                          physics: ClampingScrollPhysics(),
                          itemCount: getFeedByTime(
                                  remainFeedingActivites, times[index])
                              .length,
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
                                          // "Cho ăn ${getFeedByTime(remainFeedingActivites, times[index])[index].cageCode}",
                                          "Cho ăn Cagecode",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: primaryFontColor,
                                          ),
                                        ),
                                        Text(
                                          // "${getFeedByTime(remainFeedingActivites, times[index])[index].cageCode}",
                                          "cagetype",
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
