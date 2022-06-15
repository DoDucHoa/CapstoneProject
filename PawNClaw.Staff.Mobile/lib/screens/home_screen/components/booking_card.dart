import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/booking_detail/booking_detail.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({Key? key, required this.booking}) : super(key: key);

  final Booking booking;

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
    print(booking.id);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookingDetailScreen(bookingId: booking.id!))),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // "07:30 AM, 9 tháng 2",
                DateFormat('HH:mm a, dd ').format(booking.startBooking!) +
                    "tháng " +
                    DateFormat('MM').format(booking.startBooking!),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('HH:mm a, dd ').format(booking.endBooking!) +
                    "tháng " +
                    DateFormat('MM').format(booking.startBooking!),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
