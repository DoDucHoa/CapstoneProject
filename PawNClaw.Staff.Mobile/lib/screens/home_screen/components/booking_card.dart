import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/auth/auth_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/elevated_container.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/booking_activity.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({Key? key, required this.booking}) : super(key: key);

  final BookingDetail booking;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (element) => element.petBookingDetails!.forEach((element) {
        pets.add(element.pet!);
      }),
    );
    var user = (BlocProvider.of<AuthBloc>(context).state as Authenticated).user;
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => BookingActivityScreen(booking: booking)))
          .then((_) => BlocProvider.of<BookingBloc>(context)
            ..add(GetProcessingBooking(user: user))),
      child: Container(
        margin: EdgeInsets.only(
            right: width * 0.05, left: width * 0.05, bottom: width * 0.05),
        padding: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: width * 0.05),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/cus0.png"),
                    backgroundColor: Colors.white,
                    radius: height * 0.05,
                  ),
                ),
                Container(
                  height: height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customer!.name ?? "",
                        style: TextStyle(
                          color: primaryFontColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        width: width * 0.5,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Container(
                                  height: 18,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: lightPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      pets.length.toString(),
                                      style: TextStyle(
                                          fontSize: 15, color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: " " +
                                    pets.fold(
                                        "",
                                        (previousValue, element) =>
                                            previousValue +
                                            (previousValue == "" ? "" : ", ") +
                                            element.name! +
                                            " " +
                                            "(" +
                                            element.breedName! +
                                            ")"),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
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
            Container(
              padding: EdgeInsets.only(top: width * smallPadRate),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "07:30 AM, 9 tháng 2",
                    "${DateFormat('HH:mm a, dd ').format(booking.startBooking!)}tháng ${DateFormat('MM').format(booking.startBooking!)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width * smallFontRate,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: width * smallFontRate,
                  ),
                  Text(
                    "${DateFormat('HH:mm a, dd ').format(booking.endBooking!)}tháng ${DateFormat('MM').format(booking.endBooking!)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width * smallFontRate,
                    ),
                  )
                ],
              ),
            ),
            (booking.totalService != null || booking.totalSupply != null)
                ? Row(
                    children: [
                      (booking.totalService != null)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.only(right: 10, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: lightPrimaryColor,
                              ),
                              child: Text(
                                "Dịch vụ",
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                      (booking.totalSupply != null)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.only(right: 10, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: lightPrimaryColor,
                              ),
                              child: Text(
                                "Đồ dùng",
                                style: TextStyle(
                                  color: primaryColor,
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
    );
  }
}
