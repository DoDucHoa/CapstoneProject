import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/booking_activity.dart';
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

  List<BookingDetails>? getRemainFoodByTime(
      String time, List<BookingDetails> details) {
    List<BookingDetails> result = [];
    details.forEach((detail) {
      var booking = widget.bookings
          .firstWhere((element) => element.id == detail.bookingId);
      booking.getUndoneActivities().forEach((element) {
        if ((DateFormat('HH:mm').format(element.activityTimeFrom!) ==
                time.substring(0, 5)) &&
            (element.provideTime == null)) {
          result.add(detail);
        }
      });
    });
    result = [
      ...{...result}
    ];
    return result;
  }

  List<String> getAllTimeMarks(List<BookingDetail> bookings) {
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
    return times;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var bookings = widget.bookings;
    List<String> times = getAllTimeMarks(bookings);
    List<BookingDetails> remainFeedingActivites = [];
    bookings.forEach(
      (element) {
        remainFeedingActivites.addAll(element.getUndoneFeedingAct());
      },
    );
    remainFeedingActivites = [
      ...{...remainFeedingActivites}
    ];
    print(remainFeedingActivites);
    return SingleChildScrollView(
      padding: EdgeInsets.all(width * smallPadRate),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${Localization().convertWeekDay(DateFormat('EEEE').format(DateTime.now()))}, ${DateFormat('d').format(DateTime.now())} th??ng ${DateFormat('M').format(DateTime.now())}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: primaryFontColor,
            ),
          ),
          (remainFeedingActivites.isNotEmpty)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: times.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, timeIdx) {
                    return getRemainFoodByTime(
                                times[timeIdx], remainFeedingActivites)!
                            .isNotEmpty
                        ? Padding(
                            padding:
                                EdgeInsets.only(bottom: width * smallPadRate),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: width * smallPadRate),
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
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => BlocProvider.value(
                                                      value: BlocProvider.of<
                                                          BookingBloc>(context),
                                                      child: BookingCageScreen(
                                                          bookings: bookings,
                                                          bookingDetail:
                                                              getRemainFoodByTime(
                                                                  times[
                                                                      timeIdx],
                                                                  remainFeedingActivites)![index])))),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * smallPadRate,
                                              vertical:
                                                  width * extraSmallPadRate,
                                            ),
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    width * extraSmallPadRate),
                                            width: width * 0.7,
                                            height: height * 0.095,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Cho ??n ${getRemainFoodByTime(times[timeIdx], remainFeedingActivites)![index].cageCode}",
                                                      // "Cho ??n Cagecode",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: primaryFontColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${getRemainFoodByTime(times[timeIdx], remainFeedingActivites)![index].cageType}",
                                                      // "cagetype",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                )
              : Padding(
                  padding: EdgeInsets.only(top: width * smallPadRate),
                  child: Center(
                    child: Text(
                      "Kh??ng c??n chu???ng n??o c???n cho ??n.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
