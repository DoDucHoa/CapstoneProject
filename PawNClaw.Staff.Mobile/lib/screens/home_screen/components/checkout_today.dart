import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/vn_locale.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';

class CheckoutToday extends StatelessWidget {
  const CheckoutToday({required this.bookings, Key? key}) : super(key: key);

  final List<BookingDetail> bookings;

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
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: width * smallPadRate),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width * smallPadRate),
                      child: Text(
                        "07:30",
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
                          itemCount: bookings.length,
                          itemBuilder: (context, index) =>
                              BookingCard(booking: bookings[index])),
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

class BookingCard extends StatelessWidget {
  const BookingCard({
    Key? key,
    required this.booking,
  }) : super(key: key);

  final BookingDetail booking;

  @override
  Widget build(BuildContext context) {
    List<Pet> pets = [];
    booking.bookingDetails!.forEach((element) {
      element.petBookingDetails!.forEach((element) {
        pets.add(element.pet!);
      });
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.05),
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: width * extraSmallPadRate,
                  bottom: width * extraSmallPadRate,
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/cus0.png"),
                  backgroundColor: Colors.white,
                  radius: height * 0.04,
                ),
              ),
              Container(
                height: height * 0.08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customer!.name!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      width: width * 0.43,
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
                                    // "3",
                                    style: TextStyle(
                                        fontSize: 15, color: primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  // "Abby (Golden Retriever), Alice (Scottish Cat)",
                                  " " +
                                      pets.fold(
                                          "",
                                          (previousValue, element) =>
                                              previousValue +
                                              (previousValue == ""
                                                  ? ""
                                                  : ", ") +
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
          Divider(
            color: frameColor,
            thickness: 2,
          ),
          Container(
            padding: EdgeInsets.only(top: width * extraSmallPadRate),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // "07:30 AM, 9 tháng 2",
                  DateFormat('HH:mm aa').format(booking.endBooking!),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                (booking.totalService != null || booking.totalSupply != null)
                    // (true)
                    ? Row(
                        children: [
                          (booking.totalService != null)
                              // (true)
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.only(right: 10),
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
                              // (true)
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
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
        ],
      ),
    );
  }
}
