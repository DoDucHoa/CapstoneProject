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
          child: Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
            color:  Colors.grey[200],
            image: (pet.photos!.isEmpty)
                  ? DecorationImage(
                      image: AssetImage((pet.petTypeCode == 'DOG')
                          ? 'lib/assets/dog.png'
                          : 'lib/assets/black-cat.png'),
                      fit: BoxFit.fitHeight,
                    )
                  : DecorationImage(
                      image: NetworkImage(pet.photos!.first.url!),
                      fit: BoxFit.fitHeight)
            ),
          ),
        ),
        Text(pet.name!, style: TextStyle(fontSize:12)),
      ],
    );
  }
}
