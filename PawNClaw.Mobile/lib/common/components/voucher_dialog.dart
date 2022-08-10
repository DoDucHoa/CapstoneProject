import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/components/primary_button.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';

class VoucherDialog extends StatelessWidget {
  const VoucherDialog(
      {required this.voucher,
      required this.onPressed,
      required this.isEnabled,
      Key? key})
      : super(key: key);
  final Voucher voucher;
  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //Size size = MediaQuery.of(context).size;
    return Container(
        height: height * 0.55,
        width: width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              width * smallPadRate,
              width * mediumPadRate,
              width * smallPadRate,
              width * smallPadRate),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                child: Text(
                  'Giảm ' +
                      NumberFormat.currency(
                              decimalDigits: 0,
                              symbol:
                                  (voucher.voucherTypeName!.contains('Tiền'))
                                      ? 'đ'
                                      : '%',
                              locale: 'vi_vn')
                          .format((voucher.value)) +
                      ' giá trị đơn hàng',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: width * extraSmallPadRate,
              ),
              Divider(
                color: frameColor,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn tối thiểu:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format((voucher.minCondition)),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    width: 1.5,
                    height: height * 0.04,
                    color: lightFontColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hiệu lực:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(
                          voucher.formatStartDate() +
                              ' - ' +
                              voucher.formatExpiredDate(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
              Divider(
                color: frameColor,
                thickness: 2,
              ),
              SizedBox(
                height: width * extraSmallPadRate,
              ),
              RichText(
                  text: TextSpan(
                text: (voucher.description ?? '') + ' khi áp dụng mã ',
                style: TextStyle(
                    fontSize: 15,
                    //fontWeight: FontWeight.w500,
                    //height: 1,
                    color: primaryFontColor),
                children: [
                  TextSpan(
                      text: voucher.code,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          // height: 1,
                          color: primaryFontColor)),
                ],
              )),
              Text(
                'Mỗi khách hàng chỉ được sử dụng mã 1 lần.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
              Text(
                'Mã khuyến mãi có thời hạn đến ngày ' +
                    DateFormat('dd/MM/yyyy').format(voucher.expireDate!),
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
              Text(
                'Áp dụng cho khách hàng nhận được thông tin này.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: width * smallPadRate,
              ),
              PrimaryButton(
                text: isEnabled ? 'Áp dụng' : 'Đóng',
                onPressed: onPressed,
                contextWidth: width,
              ),
            ],
          ),
        ));
  }
}
