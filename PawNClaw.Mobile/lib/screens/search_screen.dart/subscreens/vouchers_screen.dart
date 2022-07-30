import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/voucher_card.dart';

import '../../../blocs/booking/booking_bloc.dart';

class Vouchers extends StatefulWidget {
  final List<Voucher> vouchers;
  const Vouchers({required this.vouchers,Key? key}) : super(key: key);

  @override
  State<Vouchers> createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: frameColor,
        appBar: AppBar(
          foregroundColor: primaryFontColor,
          shadowColor: Colors.white,
          title: Text(
            'Ưu đãi dành cho bạn',
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView.separated(
              itemBuilder: ((context, index) {
                var state = BlocProvider.of<BookingBloc>(context).state;
                var total = (state as BookingUpdated).booking.getTotal();
                bool avaiable = false;
                if (total >= widget.vouchers[index].minCondition!) avaiable = true;
                //prin'voucher screen' + total.toString());
                return VoucherCard(
                    voucher: widget.vouchers[index],
                    size: 180,
                    avaiable: avaiable,
                    callback: (val) {
                      print(val);
                      BlocProvider.of<BookingBloc>(context)
                          .add(AddVoucher(voucherCode: val));
                    });
              }),
              itemCount: widget.vouchers.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          ),
        ));
  }
}
