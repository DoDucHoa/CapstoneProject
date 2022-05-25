import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/horizontal_pet_bubble.dart';

import 'pet_bubble.dart';

class ChoosePetDialog extends StatefulWidget {
  const ChoosePetDialog({
    Key? key,
    required this.requests,
  }) : super(key: key);

  final List<List<Pet>> requests;

  @override
  State<ChoosePetDialog> createState() => _ChoosePetDialogState();
}

class _ChoosePetDialogState extends State<ChoosePetDialog> {
  Pet? pet;
  @override
  Widget build(BuildContext context) {
    List<Pet> pets = [];
    widget.requests.forEach((elements) {
      elements.forEach((element) {
        pets.add(element);
      });
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          height: height * 0.3,
          width: width * 0.7,
          padding: EdgeInsets.all(width * smallPadRate),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Chọn thú cưng để đặt",
                style: TextStyle(
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.bold,
                  color: primaryFontColor,
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: DropdownButton<Pet>(
                  itemHeight: height * 0.1,
                  isExpanded: true,
                  value: pet,
                  items: pets.map((e) {
                    return DropdownMenuItem(
                      child: SizedBox(
                        height: height * 0.3,
                        child: PetBubbleCard(width: width, pet: e),
                      ),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      pet = value;
                    });
                  },
                  hint: const Text("pet"),
                ),
              ),
              Opacity(
                opacity: (pet != null) ? 1 : 0.3,
                child: ElevatedButton(
                  onPressed: (pet != null)
                      ? () {
                          Navigator.pop(context, pet!.id);
                        }
                      : () {},
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
