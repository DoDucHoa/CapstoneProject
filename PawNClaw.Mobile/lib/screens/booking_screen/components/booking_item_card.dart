import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../search_screen.dart/subscreens/service_detail_screen.dart';
import '../../search_screen.dart/subscreens/supply_detail_screen.dart';

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
                  borderRadius: BorderRadius.circular(height),
                  image: (pet.photos!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(pet.photos!.first.url!),
                          fit: BoxFit.contain)
                      : null,
                  border: Border.all(
                      color: Colors.white,
                      width: 3,
                      /*strokeAlign: StrokeAlign.outside*/)),
              child: (pet.photos!.isEmpty)
                  ? CircleAvatar(
                      backgroundImage: AssetImage((pet.petTypeCode == 'DOG')
                          ? 'lib/assets/dog.png'
                          : 'lib/assets/black-cat.png'),
                    )
                  : null,
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
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<BookingBloc>(context),
                                child: SupplyDetails(
                                  supply: supplies[index],
                                  isUpdate: true,
                                  petId: pet.id,
                                  quantity: bookingSupplies
                                      .firstWhere((element) =>
                                          element.petId == pet.id &&
                                          element.supplyId ==
                                              supplies[index].id)
                                      .quantity,
                                ),
                              )))
                      .then((value) => context
                          .findRootAncestorStateOfType()!
                          .setState(() {}));
                },
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.SP,
                  children: [
                    Container(
                      width: width * 0.6,
                      child: Text(supplies[index].name!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: primaryFontColor,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            fontSize: width * regularFontRate * 0.8,
                          )),
                    ),
                    Text(
                      "x" +
                          bookingSupplies
                              .firstWhere((element) =>
                                  element.petId == pet.id &&
                                  element.supplyId == supplies[index].id)
                              .quantity
                              .toString(),
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    // Text.rich(TextSpan(
                    //     text: supplies[index].name!,
                    //     style: TextStyle(
                    //       color: primaryFontColor,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: width * regularFontRate * 0.8,
                    //     ),
                    //     children: <InlineSpan>[
                    //       TextSpan(
                    //         text: " x" +
                    //             bookingSupplies
                    //                 .firstWhere((element) =>
                    //                     element.petId == pet.id &&
                    //                     element.supplyId == supplies[index].id)
                    //                 .quantity
                    //                 .toString(),
                    //         style: TextStyle(
                    //           color: lightFontColor,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: width * regularFontRate * 0.8,
                    //         ),
                    //       )
                    //     ])),
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
                                  element.petId == pet.id &&
                                  element.supplyId == supplies[index].id)
                              .totalPrice),
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    )
                  ],
                ),
              );
            }),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<BookingBloc>(context),
                                child: ServiceDetails(
                                  service: services[index],
                                  isUpdate: true,
                                  petId: pet.id,
                                  quantity: bookingServices
                                      .firstWhere((element) =>
                                          element.petId == pet.id &&
                                          element.serviceId ==
                                              services[index].id)
                                      .quantity,
                                ),
                              )))
                      .then((value) => context
                          .findRootAncestorStateOfType()!
                          .setState(() {}));
                },
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.6,
                      child: Text(
                          services[index].name ?? services[index].description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: primaryFontColor,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            fontSize: width * regularFontRate * 0.8,
                          )),
                    ),
                    Text(
                      "x" +
                          bookingServices
                              .firstWhere((element) =>
                                  element.petId == pet.id &&
                                  element.serviceId == services[index].id)
                              .quantity
                              .toString(),
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    ),
                    Expanded(child: SizedBox()),

                    // Text.rich(TextSpan(
                    //     text: services[index].description!,
                    //     style: TextStyle(
                    //       color: primaryFontColor,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: width * regularFontRate * 0.8,
                    //     ),
                    //     children: <InlineSpan>[
                    //       TextSpan(
                    //         text: " x" +
                    //             bookingServices
                    //                 .firstWhere((element) =>
                    //                     element.petId == pet.id &&
                    //                     element.serviceId == services[index].id)
                    //                 .quantity
                    //                 .toString(),
                    //         style: TextStyle(
                    //           color: lightFontColor,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: width * regularFontRate * 0.8,
                    //         ),
                    //       )
                    //     ])),
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
                                  element.serviceId == services[index].id)
                              .totalPrice),
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate * 0.8,
                      ),
                    )
                  ],
                ),
              );
            }),
      ],
    );
  }
}
