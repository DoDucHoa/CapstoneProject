import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';

class ServiceCard extends StatefulWidget {
  final Services service;
  final Widget redirect;

  const ServiceCard({required this.redirect, required this.service, Key? key})
      : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    Services service = widget.service;
    Widget redirect = widget.redirect;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var updateState =
        BlocProvider.of<BookingBloc>(context).state as BookingUpdated;
    var booking = updateState.booking;
    int quantity = 0;
    if (booking.serviceOrderCreateParameters!.isNotEmpty){
      booking.serviceOrderCreateParameters!.forEach((element) {
        if (element.serviceId.toString() == service.id.toString()) {
          quantity = quantity + element.quantity!;
        }
      });
    }

    return InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<BookingBloc>(context),
                  child: redirect,
                ))).then((value) =>
                context.findRootAncestorStateOfType()!.setState(() {})),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Stack(children: [
             (quantity > 0)
                ? Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
                      height: 85,
                      width: 3,
                    ))
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: (quantity > 0) ? width * 0.03 : 0),
              child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                    TextSpan(
                      text: (quantity > 0 ? quantity.toString() + 'x ' : ''),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                      children: [
                        TextSpan(
                          text: service.name ?? service.description ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryFontColor),
                        ),
                      ],
                    ),
                  ),
                // Container(
                //   width: width*0.6,
                //   child: Text(
                //     service.name ?? service.description ?? "",
                //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                  
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                                  decimalDigits: 0, symbol: '', locale: 'vi_vn')
                              .format((service.servicePrices![0].price ?? 0)) +
                          " ~ " +
                          NumberFormat.currency(
                                  decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                              .format((service
                                      .servicePrices![
                                          service.servicePrices!.length - 1]
                                      .price ??
                                  0)),
                      //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if ((service.discountPrice ?? 0) > 0)
                      Text(
                        NumberFormat.currency(
                                decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                            .format(service.discountPrice ?? 0),
                        style: TextStyle(
                            fontSize: 13,
                            color: lightFontColor,
                            decoration: TextDecoration.lineThrough),
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    if ((service.discountPrice ?? 0) > 0)
                      Padding(
                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                          child: Container(
                            padding: EdgeInsets.all(11 * 0.4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(15),
                              //border: Border.all(width: 1),
                            ),
                            child: Text(
                              '  Khuyến mãi  ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          )),
                  ],
                ),
                // cage.discount! > 0 ?
                SizedBox(
                  height: 30,
                ),
              ],
            )),
            Positioned(
              right: 5,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  image: (service.photo?.url == null)? DecorationImage(
                      image: AssetImage('lib/assets/cage.png'),
                      fit: BoxFit.cover): DecorationImage(
                          image: NetworkImage(service.photo!.url!),
                          fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 10,
            //   child: Divider(color: lightFontColor.withOpacity(0.1),thickness: 1.5,),)
          ]),
        ));
  }
}
