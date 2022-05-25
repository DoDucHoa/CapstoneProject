
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

class PetBubbleCard extends StatelessWidget {
  const PetBubbleCard({
    Key? key,
    required this.width,
    required this.pet,
  }) : super(key: key);

  final double width;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.15,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
            ),
          ),
          Text(
            pet.name!,
            style: TextStyle(fontSize: 1),
          ),
        ],
      ),
    );
  }
}
