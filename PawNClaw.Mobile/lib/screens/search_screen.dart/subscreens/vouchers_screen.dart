import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/voucher_card.dart';

class Vouchers extends StatefulWidget {
  const Vouchers({Key? key}) : super(key: key);

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
            padding: EdgeInsets.all(10),
            // child: ListView.separated(
            //   itemBuilder: ((context, index) {
            //     return VoucherCard(
            //       voucher: FAKE_VOUCHERS[index],
            //       size: 180,
            //     );
            //   }),
            //   itemCount: FAKE_VOUCHERS.length,
            //   separatorBuilder: (context, index) => const SizedBox(
            //     height: 8,
            //   ),
            //   shrinkWrap: true,
            //   physics: ClampingScrollPhysics(),
            // ),
          ),
        ));
  }
}
