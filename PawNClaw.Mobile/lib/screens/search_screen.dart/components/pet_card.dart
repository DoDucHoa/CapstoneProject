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
  var isLock = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool isExistInRequests(List<List<Pet>> requests, Pet pet) {
    for (var pets in requests) {
      if (pets.contains(pet)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var state = BlocProvider.of<SearchBloc>(context).state;
    bool isUpdate = false;
    if (state is UpdatePetSelected) {
      //for back (save process)
      if (state.requests.isNotEmpty) {
        if (isExistInRequests(state.requests, widget.pet)) {
          isLock = true;
        } else {
          isLock = false;
          if (!isExistInRequests([state.pets], widget.pet)) {
            isSelected = false;
          } else {
            isSelected = true;
          }
        }
      } else {
        isLock = false;
        if (!isExistInRequests([state.pets], widget.pet)) {
          isSelected = false;
        }
      }
    }

    // print('pet name ${widget.pet.name}');
    // print(state);
    // print('lock: $isLock');
    // print('selected: $isSelected');
    // print('----------------------------------------------------');
    return Stack(
      children: [
        // SizedBox(
        //   width: width,
        //   height: height * 0.2,
        // ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * smallPadRate,
            vertical: width * extraSmallPadRate,
          ),
          padding: EdgeInsets.only(
            left: width * smallPadRate * 2 + width * 0.2,
            top: width * smallPadRate,
            bottom: width * 0.015,
          ),
          height: width * 0.47,
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
                widget.pet.breedName!,
                style: TextStyle(
                  fontSize: width * smallFontRate,
                  fontWeight: FontWeight.w300,
                  color: lightFontColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cake,
                    size: width * smallFontRate,
                    color: primaryColor,
                  ),
                  Container(
                    height: width * smallFontRate,
                    child: Text(
                      " " + DateFormat.yMd().format(widget.pet.birth!),
                      style: TextStyle(
                          color: lightFontColor,
                          fontWeight: FontWeight.w400,
                          fontSize: width * smallFontRate,
                          height: 1.2),
                    ),
                  ),
                ],
              )

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
          top: width * mediumPadRate,
          child: Container(
            height: width * 0.2,
            width: width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.2),
              color: Colors.white,
              image: (widget.pet.photos!.isEmpty)
                  ? DecorationImage(
                      image: AssetImage((widget.pet.petTypeCode == 'DOG')
                          ? 'lib/assets/dog.png'
                          : 'lib/assets/black-cat.png'),
                      fit: BoxFit.fitHeight,
                    )
                  : DecorationImage(
                      image: NetworkImage(widget.pet.photos!.first.url!),
                      fit: BoxFit.fitHeight),
            ),
          ),
        ),
        Positioned(
            top: width * (smallPadRate * 2 + 0.2),
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
                  Row(
                    children: [
                      Image.asset(
                        'lib/assets/weight-icon.png',
                        height: width * smallFontRate,
                        //color: primaryColor,
                      ),
                      Container(
                        height: width * smallFontRate,
                        child: Text(
                          " " + widget.pet.weight!.toStringAsFixed(1) + " kg",
                          style: TextStyle(
                              color: lightFontColor,
                              fontWeight: FontWeight.w400,
                              fontSize: width * smallFontRate,
                              height: 1.2),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.square_foot,
                        size: width * smallFontRate,
                        color: primaryColor,
                      ),
                      Container(
                        height: width * smallFontRate,
                        child: Text(
                          " H: " +
                              widget.pet.height!.toString() +
                              "cm - L: " +
                              widget.pet.length!.toString() +
                              " cm",
                          style: TextStyle(
                              color: lightFontColor,
                              fontWeight: FontWeight.w400,
                              fontSize: width * smallFontRate,
                              height: 1.2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),

        Positioned(
          right: width * smallPadRate,
          top: width * smallPadRate,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: (isSelected || isLock) ? primaryColor : disableColor,
                shape: CircleBorder(
                    side: BorderSide(
                  width: 1,
                  /*strokeAlign: StrokeAlign.outside*/
                  color: (isSelected || isLock) ? primaryColor : disableColor,
                )),
              ),
              onPressed: isSelected
                  ? (isLock)
                      ? () {}
                      : () {
                          var state =
                              BlocProvider.of<SearchBloc>(context).state;
                          if (state is UpdatePetSelected &&
                              state.requests.isNotEmpty) {
                            for (var pets in state.requests) {
                              for (var pet in pets) {
                                if (pet.id == widget.pet.id) {
                                  setState(() {
                                    isLock = true;
                                  });
                                  break;
                                }
                              }
                            }
                          }
                          if (!isLock) {
                            setState(() {
                              isSelected = false;
                            });
                            widget.onPressed();
                          }
                        }
                  : (isLock)
                      ? () {}
                      : () {
                          var state =
                              BlocProvider.of<SearchBloc>(context).state;
                          if (isExistInRequests(
                              (state as UpdatePetSelected).requests,
                              widget.pet)) {
                            setState(() {
                              isLock = true;
                            });
                          } else {
                            if (state is UpdatePetSelected &&
                                state.pets.isNotEmpty) {
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
                              print('add' + widget.pet.id.toString());
                              widget.onPressed();
                              setState(() {
                                isSelected = true;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Không thể chọn 2 thú cưng khác loài trong cùng một yêu cầu.")));
                            }
                          }
                          //  state = BlocProvider.of<SearchBloc>(context).state;
                        },
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 15,
              )),
        ),
      ],
    );
  }
}
