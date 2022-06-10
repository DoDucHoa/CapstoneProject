import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../common/constants.dart';
import '../../../models/fake_data.dart';
import '../../../models/voucher.dart';

class ShowVouchers extends StatelessWidget {
  final List<Voucher> vouchers;
  const ShowVouchers({required this.vouchers, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                return VoucherCard(vouchers[index],180, size);
              }),
              itemCount: FAKE_VOUCHERS.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          ),
        ));
  }

  Widget VoucherCard(Voucher voucher, int size, Size contextSize) {
    double width = contextSize.width;
    return Column(
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
                              .format((voucher.value)) +
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
                              .format((voucher.minCondition)),
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
                      voucher.startDate +
                      ' - ' +
                      voucher.expireDate),
                ])))
      ],
    );

  }
}
