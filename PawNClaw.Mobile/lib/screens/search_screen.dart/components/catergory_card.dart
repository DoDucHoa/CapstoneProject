import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';

import 'cage_card.dart';

class CatergoryCard extends StatelessWidget {
  final int id;
  final String name;
  final Size size;
  const CatergoryCard(
      {Key? key, required this.id, required this.name, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Cage> cageslist = buildCageList(id);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                name.toUpperCase(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 15,
              ),
              DottedLine(
                dashColor: lightFontColor.withOpacity(0.3),
              ),
              SizedBox(height: 10,),
              ListView.separated(
                  itemBuilder: (context, index) {
                    return CageCard(cage: cageslist[index]);
                  },
                  itemCount: cageslist.length,
                  separatorBuilder: (context, index) => const Divider(
                        color: lightFontColor,
                      ),
                  
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),)
              // Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: buildCageList(id)),
            ])));
  }

  List<Cage> buildCageList(int cagetypeid) {
    List<Cage> cagetypesWidgets = [];
    for (var i = 0; i < FAKE_CAGES.length; i++) {
      if (FAKE_CAGES[i].cagetype == cagetypeid)
        cagetypesWidgets.add(FAKE_CAGES[i]);
    }
    return cagetypesWidgets;
  }
}
