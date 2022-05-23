import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

class SelectedPetBubble extends StatelessWidget {
  const SelectedPetBubble({
    Key? key,
    required this.width,
    required this.pet,
  }) : super(key: key);

  final double width;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
          ),
        ),
        Text(pet.name!),
      ],
    );
  }
}
