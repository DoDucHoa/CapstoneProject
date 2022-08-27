import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';

import '../../../models/pet.dart';

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
    for (SupplyOrder order in details.supplyOrders!) {
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
    print(pet.toJson());
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
              child: (pet.photos!.isEmpty)
                  ? CircleAvatar(
                      backgroundImage: AssetImage((pet.petTypeCode == 'DOG')
                        ? 'lib/assets/dog.png'
                        : 'lib/assets/black-cat.png'),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(pet.photos!.first.url!),
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
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    width: width * 0.6,
                    child: Text(
                      bookingSupplies[index].supply!.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    ),
                  ),
                  Text(
                    " x" + bookingSupplies[index].quantity.toString(),
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                  Expanded(child: SizedBox()),
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
                  Container(
                    width: width * 0.6,
                    child: Text(
                      bookingServices[index].service!.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    ),
                  ),
                  Text(
                    " x" + bookingServices[index].quantity.toString(),
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                  Expanded(child: SizedBox()),
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
