import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/subscreens/booking_cage.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.bookings}) : super(key: key);

  final List<BookingDetail> bookings;
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    var user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;
    BlocProvider.of<BookingBloc>(context).add(GetProcessingBooking(user: user));
    super.initState();
  }

  List<FoodSchedules>? getRemainFood(BookingDetails detail) {
    List<FoodSchedules> result = detail.foodSchedules!;
    if (detail.bookingActivities != null &&
        detail.bookingActivities!.length > 0) {
      int length = detail.bookingActivities!.length;
      for (var i = 0; i < length; i++) {
        result.removeAt(0);
        detail.bookingActivities!.removeAt(0);
      }
      return result;
    }
    return result;
  }

  List<BookingDetails>? getRemainFoodByTime(
      String time, List<BookingDetails> details) {
    List<BookingDetails>? result = [];
    details.forEach((detail) {
      getRemainFood(detail)?.forEach((element) {
        if (element.fromTime == time) {
          result!.add(detail);
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
    times.sort(
      (a, b) => a.compareTo(b),
    );
    print(times);
    List<BookingDetails> remainFeedingActivites = [];
    times.forEach(
      (time) {
        bookings.forEach((booking) {
          booking.bookingDetails!.forEach((detail) {
            var remain = getRemainFood(detail);
            remain!.forEach((remain) {
              if (remain.fromTime == time) {
                remainFeedingActivites.add(detail);
              }
            });
          });
        });
      },
    );
    print(remainFeedingActivites.toSet().toList());
    print(bookings[0].bookingDetails![0].foodSchedules);
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
            itemBuilder: (context, timeIdx) {
              return getRemainFoodByTime(
                          times[timeIdx], remainFeedingActivites)!
                      .isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: width * smallPadRate),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: width * smallPadRate),
                            child: Text(
                              times[timeIdx].substring(0, 5),
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
                                itemCount: getRemainFoodByTime(
                                  times[timeIdx],
                                  remainFeedingActivites,
                                )!
                                    .length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => BookingCageScreen(
                                                bookings: bookings,
                                                bookingDetail: getRemainFoodByTime(
                                                        times[timeIdx],
                                                        remainFeedingActivites)![
                                                    index]))),
                                    child: Container(
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
                                                "Cho ăn ${getRemainFoodByTime(times[timeIdx], remainFeedingActivites)![index].cageCode}",
                                                // "Cho ăn Cagecode",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryFontColor,
                                                ),
                                              ),
                                              Text(
                                                "${getRemainFoodByTime(times[timeIdx], remainFeedingActivites)![index].cageType}",
                                                // "cagetype",
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
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
