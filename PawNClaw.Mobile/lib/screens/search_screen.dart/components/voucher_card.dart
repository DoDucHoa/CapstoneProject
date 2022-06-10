import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';

import '../../../blocs/booking/booking_bloc.dart';

class VoucherCard extends StatefulWidget {
  final Voucher voucher;
  final int size;
  final VoucherCallBack callback;
  final bool avaiable;
  const VoucherCard({ required this.voucher, required this.size, required this.callback,required this.avaiable,Key? key}) : super(key: key);

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

typedef void VoucherCallBack(String voucherCode);

class _VoucherCardState extends State<VoucherCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var size = widget.size;
    // return ClipRRect(
    //     borderRadius: BorderRadius.all(Radius.circular(15)),
    // 
    //    child:
    return (widget.avaiable) ?
     InkWell(
      //enableFeedback: widget.avaiable,
      onTap: (() {
        widget.callback(widget.voucher.code);
        //BlocProvider.of<BookingBloc>(context).add(AddVoucher(voucherCode: widget.voucher.code));
        // var state = BlocProvider.of<BookingBloc>(context).state;
        //var voucherCode  = (state as BookingUpdated).booking.voucherCode;
        ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Chọn voucher thành công!"), duration: Duration(seconds: 1),),);
        
      }),
      child: Column(
      children: [
        Container(
            height: size * 0.45,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giảm ' +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format((widget.voucher.value)) +
                          ' đơn hàng',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '    ●  Đặt tối thiểu ' +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format((widget.voucher.minCondition)),
                      style: TextStyle(fontSize: 13, color: lightFontColor),
                    ),
                  ]),
            )),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)))),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        (constraints.constrainWidth() / 10).floor(),
                        (index) => SizedBox(
                              height: 1,
                              width: 5,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.45))),
                            )),
                  );
                }),
              ),
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)))),
              ),
            ],
          ),
        ),
        Container(
            height: size * 0.25,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: primaryColor,
                    size: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Hiệu lực từ: ' +
                      widget.voucher.startDate +
                      ' - ' +
                      widget.voucher.expireDate),
                ])))
      ],
    )):Opacity(opacity: 0.5, child: Column(
      children: [
        Container(
            height: size * 0.45,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giảm ' +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format((widget.voucher.value)) +
                          ' đơn hàng',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '    ●  Đặt tối thiểu ' +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format((widget.voucher.minCondition)),
                      style: TextStyle(fontSize: 13, color: lightFontColor),
                    ),
                  ]),
            )),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)))),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        (constraints.constrainWidth() / 10).floor(),
                        (index) => SizedBox(
                              height: 1,
                              width: 5,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.45))),
                            )),
                  );
                }),
              ),
              SizedBox(
                height: 20,
                width: 10,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)))),
              ),
            ],
          ),
        ),
        Container(
            height: size * 0.25,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: primaryColor,
                    size: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Hiệu lực từ: ' +
                      widget.voucher.startDate +
                      ' - ' +
                      widget.voucher.expireDate),
                ]))),
                Text('* Đơn hàng chưa đạt giá trị tối thiểu của Voucher', style: TextStyle(fontStyle: FontStyle.italic),)
      ],
    ),);
  }
}

//draw circle for ticket widget
