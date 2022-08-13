import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/screens/center_overview_screen/components/item_card.dart';
import 'package:pawnclaw_mobile_application/screens/center_overview_screen/subscreens/cage_details_screen.dart';


class CatergoryCard extends StatelessWidget {
  final CageTypes cageType;
  final Size size;
  const CatergoryCard({Key? key, required this.cageType, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            cageType.typeName!.toUpperCase(),
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
              var cage = cageType.cages?[index];
              return ItemCard(
                name: cage?.name ?? "",
                sellPrice: (cageType.totalPrice == null) ? [cageType.minPrice!, cageType.maxPrice!] : [cageType.totalPrice!],
                discountPrice: 0,
                id: cage!.code!,
                typeId: 0,
                imgURL: cageType.photo?.url?? null,
                redirect: CageDetails(
                  cageType: cageType,
                  cage: cage,
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: lightFontColor,
            ),
            itemCount: cageType.cages!.length,
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
