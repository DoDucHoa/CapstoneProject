import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/pet.dart';

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
              backgroundImage: AssetImage(pet.petTypeCode == "DOG"
                  ? 'lib/assets/dog.png'
                  : 'lib/assets/black-cat.png'),
            ),
          ),
          Text(
            pet.name!,
          ),
        ],
      ),
    );
  }
}
