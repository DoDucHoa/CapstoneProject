import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';

class BookingCageCard extends StatelessWidget {
  const BookingCageCard(
      {Key? key,
      required this.booking,
      required this.request,
      required this.center})
      : super(key: key);

  final BookingRequestModel booking;
  final List<Pet> request;
  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    List<int> petsId = [];
    List<CageTypes> cageTypes = center.cageTypes!;
    List<Cages> cages = [];
    request.forEach(((element) => petsId.add(element.id!)));
    print("petsid : " + petsId.toString());
    var bookingCage = booking.bookingDetailCreateParameters!
        .firstWhere((element) => element.petId.toString() == petsId.toString());
    print(bookingCage.toString());
    CageTypes? cageType;
    Cages? cage;
    cageTypes.forEach((element) {
      element.cages!.forEach((c) {
        if (c.code == bookingCage.cageCode) {
          cageType = element;
          cage = c;
        }
      });
    });
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
              child: request.length > 1
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
                    cageType!.typeName!,
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Text(
                    request.fold(
                        "",
                        (previousValue, element) =>
                            previousValue + "-" + element.name!),
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
              cage!.name!,
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
                        .format(bookingCage.price),
                    style: TextStyle(
                      fontSize: width * regularFontRate * 0.8 * 0.8,
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " (" + bookingCage.duration!.toString() + " ngày)",
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
