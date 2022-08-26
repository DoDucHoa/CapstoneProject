import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key, required this.pet}) : super(key: key);

  final Pet pet;

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  var isSelected = false;
  var isValid = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // SizedBox(
        //   width: width,
        //   height: height * 0.2,
        // ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * smallPadRate,
          ),
          padding: EdgeInsets.only(
            left: width * smallPadRate * 2 + width * 0.2,
            top: width * smallPadRate,
            bottom: width * 0.005,
          ),
          height: width * 0.45,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.pet.name!,
                style: TextStyle(
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.w800,
                  color: primaryFontColor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.pet.breedName?? '',
                style: TextStyle(
                  fontSize: width * smallFontRate,
                  fontWeight: FontWeight.w300,
                  color: lightFontColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.cake,
                        size: width * smallFontRate,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: " " + DateFormat.yMd().format(widget.pet.birth!),
                      style: TextStyle(
                        color: lightFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: width * smallFontRate,
                      ),
                    ),
                  ],
                ),
              ),

              // RichText(
              //   text: TextSpan(
              //     children: [
              //       WidgetSpan(
              //         child: Icon(
              //           Icons.balance,
              //           size: width * smallFontRate,
              //           color: primaryColor,
              //         ),
              //       ),
              //       TextSpan(
              //         text: " " + widget.pet.weight!.toStringAsFixed(1) + " kg",
              //         style: TextStyle(
              //           color: lightFontColor,
              //           fontWeight: FontWeight.w400,
              //           fontSize: width * smallFontRate,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       WidgetSpan(
              //         child: Icon(
              //           Icons.square_foot,
              //           size: width * smallFontRate,
              //           color: primaryColor,
              //         ),
              //       ),
              //       TextSpan(
              //         text: " H: " +
              //             widget.pet.height!.toString() +
              //             "cm - L: " +
              //             widget.pet.length!.toString() +
              //             " cm",
              //         style: TextStyle(
              //           color: lightFontColor,
              //           fontWeight: FontWeight.w400,
              //           fontSize: width * smallFontRate,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        Positioned(
          left: width * regularPadRate,
          top: width * smallPadRate,
          child: Container(
            height: width * 0.2,
            width: width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.2),
              color: Colors.white,
              image: (widget.pet.photos!.isEmpty) ? DecorationImage(
                image: AssetImage(widget.pet.petTypeCode == "DOG" ? 'lib/assets/dog.png' : 'lib/assets/black-cat.png'),
                fit: BoxFit.fitHeight,
              ):DecorationImage(
                image: NetworkImage(widget.pet.photos!.first.url!),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Positioned(  
            bottom: width * (extraSmallPadRate),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * smallPadRate * 2,
                vertical: width * extraSmallPadRate,
              ),
              padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
              height: width * regularPadRate,
              width: width * (1 - regularPadRate * 2),
              decoration: BoxDecoration(
                color: frameColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Image.asset(
                            'lib/assets/weight-icon.png',
                            height: width * smallFontRate,
                            //color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: " " +
                              widget.pet.weight!.toStringAsFixed(1) +
                              " kg",
                          style: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w400,
                            fontSize: width * smallFontRate,
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
                            size: width * smallFontRate,
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
                            fontSize: width * smallFontRate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
