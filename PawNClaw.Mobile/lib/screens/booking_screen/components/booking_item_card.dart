import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';

class BookingItemCard extends StatelessWidget {
  const BookingItemCard({
    Key? key,
    required this.booking,
    required this.pet,
    required this.center,
  }) : super(key: key);

  final BookingRequestModel booking;
  final Pet pet;
  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    var bookingSupplies = booking.supplyOrderCreateParameters!
        .where((element) => element.petId == pet.id)
        .toList();
    List<petCenter.Supplies> supplies = [];
    bookingSupplies.forEach((element) {
      center.supplies!.forEach((supply) {
        if (supply.id == element.supplyId) {
          supplies.add(supply);
        }
      });
    });
    var bookingServices = booking.serviceOrderCreateParameters!
        .where((element) => element.petId == pet.id)
        .toList();
    List<petCenter.Services> services = [];
    bookingServices.forEach((element) {
      center.services!.forEach((service) {
        if (service.id == element.serviceId) {
          services.add(service);
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
                  top: width * extraSmallPadRate,
                  right: width * extraSmallPadRate,
                  left: 0),
              padding: EdgeInsets.all(width * smallPadRate * 0.5),
              height: height * 0.1,
              width: height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
              ),
            ),
            SizedBox(
              height: height * 0.06,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name!,
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate,
                    ),
                  ),
                  Text(
                    pet.weight!.toStringAsFixed(1) + " kg",
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: supplies.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    supplies[index].name!,
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                          decimalDigits: 0,
                          symbol: '',
                        ).format(supplies[index].sellPrice) +
                        "đ",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  )
                ],
              );
            }),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    services[index].description!,
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                          decimalDigits: 0,
                          symbol: '',
                        ).format(bookingServices
                            .firstWhere((element) =>
                                element.serviceId == services[index].id)
                            .totalPrice) +
                        "đ",
                    style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  )
                ],
              );
            }),
      ],
    );
  }
}
