import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:intl/intl.dart';

class PetCard extends StatefulWidget {
  const PetCard(
      {Key? key,
      required this.width,
      required this.height,
      required this.pet,
      required this.onPressed})
      : super(key: key);

  final double width;
  final double height;
  final VoidCallback onPressed;
  final Pet pet;

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height * 0.2,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: widget.width * 0.1,
            vertical: widget.width * 0.1,
          ),
          padding: EdgeInsets.only(
            left: widget.width * 0.415,
            top: widget.width * 0.015,
            bottom: widget.width * 0.015,
          ),
          height: widget.width * 0.3,
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pet.name!,
                style: TextStyle(
                  fontSize: widget.width * regularFontRate,
                  fontWeight: FontWeight.w800,
                  color: primaryFontColor,
                ),
              ),
              Text(
                widget.pet.breedName!,
                style: TextStyle(
                  fontSize: widget.width * smallFontRate,
                  fontWeight: FontWeight.w300,
                  color: lightFontColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.cake,
                        size: widget.width * smallFontRate,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: " " + DateFormat.yMd().format(widget.pet.birth!),
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: widget.width * smallFontRate,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.balance,
                        size: widget.width * smallFontRate,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: " " + widget.pet.weight!.toStringAsFixed(1) + " kg",
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: widget.width * smallFontRate,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.square_foot,
                        size: widget.width * smallFontRate,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: " H: " +
                          widget.pet.height!.toString() +
                          "cm - L: " +
                          widget.pet.length!.toString() +
                          " cm",
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: widget.width * smallFontRate,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: widget.width * 0.1,
          top: widget.width * 0.05,
          child: Container(
            height: widget.width * 0.4,
            width: widget.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('lib/assets/cat_avatar0.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Positioned(
          right: widget.width * 0.1 - widget.height * 0.042,
          top: widget.height * 0.085,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<CircleBorder>(
                CircleBorder(
                  side: BorderSide(
                    color: primaryColor,
                    width: widget.height * 0.04,
                  ),
                ),
              ),
            ),
            onPressed: isSelected
                ? () {}
                : () {
                    widget.onPressed();
                    setState(() {
                      isSelected = true;
                    });
                  },
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
          ),
        ),
      ],
    );
  }
}
