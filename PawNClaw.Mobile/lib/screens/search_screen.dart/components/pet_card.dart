import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:intl/intl.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key, required this.pet, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;
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
        SizedBox(
          width: width,
          height: height * 0.2,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.1,
            vertical: width * 0.1,
          ),
          padding: EdgeInsets.only(
            left: width * 0.415,
            top: width * 0.015,
            bottom: width * 0.015,
          ),
          height: width * 0.3,
          width: width,
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
                  fontSize: width * regularFontRate,
                  fontWeight: FontWeight.w800,
                  color: primaryFontColor,
                ),
              ),
              Text(
                widget.pet.breedName!,
                style: TextStyle(
                  fontSize: width * smallFontRate,
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
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.balance,
                        size: width * smallFontRate,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: " " + widget.pet.weight!.toStringAsFixed(1) + " kg",
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
        ),
        Positioned(
          left: width * 0.1,
          top: width * 0.05,
          child: Container(
            height: width * 0.4,
            width: width * 0.4,
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
          right: width * 0.1 - height * 0.042,
          top: height * 0.085,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<CircleBorder>(
                CircleBorder(
                  side: BorderSide(
                    color: primaryColor,
                    width: height * 0.04,
                  ),
                ),
              ),
            ),
            onPressed: isSelected
                ? () {}
                : () {
                    var state = BlocProvider.of<SearchBloc>(context).state;
                    if (state is UpdatePetSelected && state.pets.isNotEmpty) {
                      for (var pet in state.pets) {
                        if (pet.petTypeCode != widget.pet.petTypeCode) {
                          setState(() {
                            isValid = false;
                          });
                          break;
                        }
                      }
                    } else if (state is UpdatePetSelected &&
                        state.pets.isEmpty) {
                      setState(() {
                        isValid = true;
                      });
                    }
                    if (isValid) {
                      widget.onPressed();
                      setState(() {
                        isSelected = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Không thể chọn 2 thú cưng khác loài trong cùng một yêu cầu.")));
                    }
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
