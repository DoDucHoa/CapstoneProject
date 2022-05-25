import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

import 'pet_bubble.dart';

class ChooseRequestDialog extends StatefulWidget {
  const ChooseRequestDialog({
    Key? key,
    required this.requests,
  }) : super(key: key);

  final List<List<Pet>>? requests;

  @override
  State<ChooseRequestDialog> createState() => _ChooseRequestDialogState();
}

class _ChooseRequestDialogState extends State<ChooseRequestDialog> {
  List<Pet>? pets;
  @override
  Widget build(BuildContext context) {
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
                "Chọn thú cưng để gửi",
                style: TextStyle(
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.bold,
                  color: primaryFontColor,
                ),
              ),
              SizedBox(
                width: width * 0.5,
                child: DropdownButton<List<Pet>>(
                  itemHeight: height * 0.1,
                  isExpanded: true,
                  value: pets,
                  items: widget.requests!.map((e) {
                    return DropdownMenuItem(
                      child: SizedBox(
                        height: height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: e.length,
                          itemBuilder: (context, index) {
                            return SelectedPetBubble(
                                width: width, pet: e[index]);
                          },
                        ),
                      ),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      pets = value;
                    });
                  },
                  hint: const Text("pet"),
                ),
              ),
              Opacity(
                opacity: (pets != null) ? 1 : 0.3,
                child: ElevatedButton(
                  onPressed: (pets != null)
                      ? () {
                          List<int> result = [];
                          pets!.forEach(((element) => result.add(element.id!)));
                          Navigator.pop(context, result);
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
