import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';

import '../subscreens/cage_details_screen.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final double sellPrice;
  final double discountPrice;
  final Widget redirect;
  final int typeId;
  final String id;

  const ItemCard(
      {Key? key,
      required this.name,
      required this.sellPrice,
      required this.discountPrice,
      required this.redirect,
      required this.typeId,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // return BlocProvider(
    //     create: (context) => BookingBloc(),
    //     child:
    //         BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
    return InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<BookingBloc>(context),
                      child: redirect,
                    )))
            .then((value) =>
                context.findRootAncestorStateOfType()!.setState(() {})),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  (state is BookingUpdated) ?
                //   Text(
                //     'x' + name,
                //     style: TextStyle(
                //         fontSize: 15, fontWeight: FontWeight.w600),
                //   ):
                Text(
                  name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: '??', locale: 'vi_vn')
                          .format(
                              discountPrice == 0 ? sellPrice : discountPrice),
                      //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (discountPrice > 0)
                      Text(
                        NumberFormat.currency(
                                decimalDigits: 0, symbol: '??', locale: 'vi_vn')
                            .format(sellPrice),
                        style: TextStyle(
                            fontSize: 13,
                            color: lightFontColor,
                            decoration: TextDecoration.lineThrough),
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    if (discountPrice > 0)
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
                              '  Khuy???n m??i  ',
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
            ),
            Positioned(
              right: 5,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('lib/assets/cage.png'),
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
  // )
// );
  // }
}
