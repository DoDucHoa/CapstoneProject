import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';

class BookingCageCard extends StatelessWidget {
  const BookingCageCard(
      {Key? key, required this.booking, required this.request})
      : super(key: key);

  final BookingDetail booking;
  final BookingDetails request;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: width * extraSmallPadRate,
                  top: width * mediumPadRate,
                  right: width * extraSmallPadRate,
                  left: 0),
              padding: EdgeInsets.all(width * smallPadRate * 0.25),
              height: height * 0.1,
              width: height * 0.1,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: request.petBookingDetails!.length > 1
                  ? Stack(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                          width: height * 0.1,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/cat_avatar0.png'),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('lib/assets/cat_avatar0.png'),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                          height: height * 0.05,
                          width: height * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(height),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                  strokeAlign: StrokeAlign.outside)),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/cat_avatar0.png'),
                          )),
                    ),
            ),
            SizedBox(
              height: height * 0.06,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chuồng " +
                        (booking.bookingDetails!.indexOf(request) + 1)
                            .toString(),
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Text(
                    request.petBookingDetails!.fold(
                        "",
                        (previousValue, element) =>
                            previousValue +
                            (previousValue == "" ? "" : "-") +
                            element.pet!.name!),
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(
                  bottom: width * extraSmallPadRate,
                  top: width * mediumPadRate,
                  right: 0,
                  left: width * extraSmallPadRate),
              padding: EdgeInsets.all(width * smallPadRate * 0.25),
              height: height * 0.1,
              width: height * 0.1,
              decoration: BoxDecoration(
                //color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    image: AssetImage('lib/assets/cage.png'),
                    fit: BoxFit.cover),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              request.cageCode!,
              style: TextStyle(
                color: primaryFontColor,
                fontWeight: FontWeight.w500,
                fontSize: width * regularFontRate * 0.8,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: NumberFormat.currency(
                            decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                        .format(request.price),
                    style: TextStyle(
                      fontSize: width * regularFontRate * 0.8 * 0.8,
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " (" + request.duration!.toStringAsFixed(0) + " giờ)",
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
