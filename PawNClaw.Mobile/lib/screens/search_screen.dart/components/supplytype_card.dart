import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/item_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/supply_detail_screen.dart';

class SupplyTypeCard extends StatelessWidget {
  final String supplyType;
  final Size size;
  final List<Supplies> supplies;
  const SupplyTypeCard(
      {Key? key,
      required this.supplyType,
      required this.size,
      required this.supplies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Supplies> suppliesByType = supplies
        .where(
          (supply) => supply.supplyTypeCode == supplyType,
        )
        .toList();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            supplyType.toUpperCase(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 15,
          ),
          DottedLine(
            dashColor: lightFontColor.withOpacity(0.3),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
            itemBuilder: (context, index) {
              var supply = suppliesByType[index];
              return ItemCard(
                name: supply.name!,
                sellPrice: supply.sellPrice!,
                discountPrice: supply.discountPrice!,
                redirect: SupplyDetails(
                  supply: supply,
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: lightFontColor,
            ),
            itemCount: suppliesByType.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          )
          // Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: buildCageList(id)),
        ]),
      ),
    );
  }
}
