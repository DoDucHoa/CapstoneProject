import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/subscreens/pet_details_screen.dart';

import '../../../common/constants.dart';

class PetCard extends StatelessWidget {
  const PetCard({required this.pet, required this.size, Key? key})
      : super(key: key);
  final Pet pet;
  final Size size;
  @override
  Widget build(BuildContext context) {
    double width = size.width;
    double height = size.height;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PetDetailScreen(pet: pet)));
      },
      child: Container(
        // constraints: BoxConstraints.expand(height: height * 0.6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: width * 0.05),
                width: width * 0.15,
                height: width * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey[50],
                    image: pet.photos!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(pet.photos!.first.url!))
                        : DecorationImage(
                            image: AssetImage((pet.petTypeCode == 'DOG') ?'lib/assets/dog.png':'lib/assets/black-cat.png'))),
              ),
              Container(
                width: width * (0.35),
                child: Text(
                  pet.name!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * regularFontRate,
                      color: primaryFontColor,
                      height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width * (0.35),
                child: Text(
                  pet.breedName!,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width * smallFontRate,
                      color: lightFontColor,
                      height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
              //SizedBox(height: width * 0.025,)
            ]),
      ),
    );
    ;
  }
}
