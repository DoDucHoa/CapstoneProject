import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';

class BookingItemCard extends StatelessWidget {
  const BookingItemCard({
    Key? key,
    required this.booking,
    required this.pet,
  }) : super(key: key);

  final BookingDetail booking;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    var bookingSupplies =
        booking.supplyOrders!.where((element) => element.pet!.name == pet.name);
    List<Supply> supplies = [];
    bookingSupplies.forEach((element) {
      supplies.add(element.supply!);
    });
    var bookingServices = booking.serviceOrders!
        .where((element) => element.pet!.name == pet.name)
        .toList();
    List<Service> services = [];
    bookingServices.forEach((element) {
      services.add(element.service!);
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
                  Text.rich(TextSpan(
                      text: supplies[index].name!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: " x" +
                              bookingSupplies
                                  .firstWhere((element) =>
                                      element.pet!.name == pet.name &&
                                      element.supply!.id == supplies[index].id)
                                  .quantity
                                  .toString(),
                          style: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: width * regularFontRate * 0.8,
                          ),
                        )
                      ])),
                  // Text(
                  //   supplies[index].name! +
                  //       " x" +
                  //       bookingSupplies
                  //           .firstWhere((element) =>
                  //               element.petId == pet.id &&
                  //               element.supplyId == supplies[index].id)
                  //           .quantity
                  //           .toString(),
                  //   style: TextStyle(
                  //     color: primaryFontColor,
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: width * regularFontRate * 0.8,
                  //   ),
                  // ),
                  Text(
                    NumberFormat.currency(
                            decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                        .format(bookingSupplies
                            .firstWhere((element) =>
                                element.pet!.name == pet.name &&
                                element.supply!.id == supplies[index].id)
                            .totalPrice),
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
                  Text.rich(TextSpan(
                      text: services[index].description!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: " x" +
                              bookingServices
                                  .firstWhere((element) =>
                                      element.pet!.name == pet.name &&
                                      element.service!.id == services[index].id)
                                  .quantity
                                  .toString(),
                          style: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w500,
                            fontSize: width * regularFontRate * 0.8,
                          ),
                        )
                      ])),
                  // Text(
                  //   services[index].description!
                  //   +
                  //       " x" +
                  //       bookingServices
                  //           .firstWhere((element) =>
                  //               element.petId == pet.id &&
                  //               element.serviceId == services[index].id)
                  //           .quantity
                  //           .toString(),
                  //   style: TextStyle(
                  //     color: primaryFontColor,
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: width * regularFontRate * 0.8,
                  //   ),
                  // ),
                  Text(
                    NumberFormat.currency(
                            decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                        .format(bookingServices
                            .firstWhere((element) =>
                                element.service!.id == services[index].id)
                            .totalPrice),
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
