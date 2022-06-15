import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';

class BookingItemCard extends StatelessWidget {
  const BookingItemCard({
    Key? key,
    required this.booking,
    required this.pet,
    required this.details,
  }) : super(key: key);

  final Booking booking;
  final Pet pet;
  final TransactionDetails details;

  @override
  Widget build(BuildContext context) {
    var bookingSupplies = details.supplyOrders!
        .where((element) => element.petId == pet.id)
        .toList();
    for (SupplyOrder order in details.supplyOrders!){
      print(order.toJson());
    }
    //List<petCenter.Supplies> supplies = [];
    // bookingSupplies.forEach((element) {
    //   center.supplies!.forEach((supply) {
    //     if (supply.id == element.supplyId) {
    //       supplies.add(supply);
    //     }
    //   });
    // });
    print(bookingSupplies);
    var bookingServices = details.serviceOrders!
        .where((element) => element.petId == pet.id)
        .toList();
    // List<petCenter.Services> services = [];
    // bookingServices.forEach((element) {
    //   center.services!.forEach((service) {
    //     if (service.id == element.serviceId) {
    //       services.add(service);
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
            itemCount: bookingSupplies.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(
                      text: bookingSupplies[index].supply!.name!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text:
                              " x" + bookingSupplies[index].quantity.toString(),
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
                        .format(bookingSupplies[index].totalPrice),
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
            itemCount: bookingServices.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(
                      text: bookingServices[index].service!.description!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text:
                              " x" + bookingServices[index].quantity.toString(),
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
                        .format(bookingServices[index].totalPrice),
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
