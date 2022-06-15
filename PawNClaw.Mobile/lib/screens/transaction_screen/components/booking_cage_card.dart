import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/cage_card.dart';

class BookingCageCard extends StatelessWidget {
  const BookingCageCard(
      {Key? key,
      required this.booking,
      required this.bookingDetails,
      required this.center})
      : super(key: key);

  final Booking booking;
  final BookingDetail bookingDetails;
  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    List<int> petsId = [];
   //CageTypes cageType = center.cageTypes!.firstWhere((e) => e.typeName == bookingDetails.cageCode);
    //Cages cage = cageType.cages!.first;
    // request.forEach(((element) => petsId.add(element.id!)));
    print("petsid : " + petsId.toString());
    //var bookingCage = bookingDetails.petBookingDetails.first.
    //  booking.bookingDetailCreateParameters!
    //     .firstWhere((element) => element.petId.toString() == petsId.toString());
    // print(bookingCage.toString());
    // CageTypes? cageType;
    // cageTypes.forEach((element) {
    //   element.cages!.forEach((cage) {
    //     if (cage.code == bookingDetails.cageCode) {
    //       cageType = element;
    //     }
    //   });
    // });
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
              height: height * 0.12,
              width: height * 0.12,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: CageCard(pets: bookingDetails.getPets(), context: context),
            ),
            SizedBox(
              height: height * 0.06,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                     'Chuồng ${bookingDetails.line!.toString()}',
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Text(
                    bookingDetails.petBookingDetails!.fold(
                        "",
                        (previousValue, element) =>
                            previousValue + "-" + element.pet!.name!),
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
              height: height * 0.12,
              width: height * 0.12,
              decoration: BoxDecoration(
                //color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                image:const DecorationImage(
                      image: AssetImage('lib/assets/cage.png'),
                      fit: BoxFit.cover),),
              
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bookingDetails.cage!.cageType!.typeName!,
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
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format(bookingDetails.price) ,
                    style: TextStyle(
                      fontSize: width * regularFontRate * 0.8 * 0.8,
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " (" + bookingDetails.duration!.toString() + " giờ)",
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
