import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../../models/pet.dart';

class ChooseRequestCard extends StatefulWidget {
  const ChooseRequestCard(
      {required this.requests, required this.refresh, Key? key})
      : super(key: key);

  final List<List<Pet>> requests;
  final VoidCallback refresh;
  @override
  State<ChooseRequestCard> createState() => _ChooseRequestCardState();
}

class _ChooseRequestCardState extends State<ChooseRequestCard> {
  List<Pet>? pets;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // pets = widget.requests[0];
    // List<int> result = [];
    // pets!.forEach(((element) => result.add(element.id!)));
    // print(result);
    // BlocProvider.of<BookingBloc>(context).add(SelectRequest(petId: result));

    return Container(
      height: height * 0.25,
      width: width,
      color: Colors.white,
      child: SizedBox(
        height: width,
        child:
            //  SingleChildScrollView(
            //   scrollDirection: Axis.horizontal, child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  pets = widget.requests[index];
                  List<int> result = [];
                  pets!.forEach(((element) => result.add(element.id!)));
                  BlocProvider.of<BookingBloc>(context)
                      .add(SelectRequest(petId: result));

                  var state = BlocProvider.of<BookingBloc>(context).state;
                  print((state as BookingUpdated).selectedPetIds);
                  setState(() {
                    selectedIndex = index;
                    pets = widget.requests[index];

                    //var state = BlocProvider.of<BookingBloc>(context).state;
                  });

                  widget.refresh();
                },
                child: Stack(children: [
                  selectedIndex == index
                      ? Positioned(
                          child: Icon(Icons.check_circle,
                              color: primaryColor, size: 20),
                          top: 5,
                          right: 5)
                      : Container(),
                  Container(
                      height: width * 0.32,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                          color: index == selectedIndex
                              ? primaryColor.withOpacity(0.15)
                              : frameColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: PetRequestCard(widget.requests[index], context)),
                  Positioned(
                    bottom: width * regularPadRate,
                    left: width * 0.3 / 5,
                    child: Center(
                      child: Text('Chuồng ${index + 1}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: index == selectedIndex
                                  ? primaryColor
                                  : lightFontColor)),
                    ),
                  )
                ]));
          },
          separatorBuilder: (context, index) => SizedBox(
            width: 12,
          ),
          itemCount: widget.requests.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
        ),
        // ],
      ),
      // ),
    );
  }

  Widget PetRequestCard(List<Pet> pets, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    switch (pets.length) {
      case 2:
        return Stack(
          children: [
            Positioned(
                right: width * smallPadRate,
                bottom: width * smallPadRate * 1.5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          strokeAlign: StrokeAlign.outside)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                  ),
                )),
            Positioned(
                top: width * smallPadRate * 1.5,
                left: width * smallPadRate,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            strokeAlign: StrokeAlign.outside)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                    ))),
          ],
        );

      case 1:
        return Center(
          child: Container(
              height: height * 0.05,
              width: height * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height),
                  border: Border.all(
                      color: Colors.white,
                      width: 3,
                      strokeAlign: StrokeAlign.outside)),
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
              )),
        );
      case 3:
        return Stack(
          children: [
            Positioned(
                left: width * smallPadRate,
                bottom: width * smallPadRate,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          strokeAlign: StrokeAlign.outside)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                  ),
                )),
            Positioned(
                top: width * regularPadRate,
                right: width * smallPadRate,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            strokeAlign: StrokeAlign.outside)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                    ))),
            Positioned(
                top: width * smallPadRate,
                left: width * smallPadRate,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            strokeAlign: StrokeAlign.outside)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                    ))),
          ],
        );
      default:
        return Stack(
          children: [
            Positioned(
                right: width * smallPadRate,
                bottom: width * smallPadRate,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          strokeAlign: StrokeAlign.outside)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                  ),
                )),
            Positioned(
                left: width * smallPadRate,
                bottom: width * smallPadRate,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          strokeAlign: StrokeAlign.outside)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                  ),
                )),
            Positioned(
                top: width * smallPadRate,
                right: width * smallPadRate,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        color: pets.length > 4
                            ? lightFontColor
                            : Colors.transparent,
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            strokeAlign: StrokeAlign.outside)),
                    child: pets.length == 4
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/cat_avatar0.png'),
                          )
                        : SizedBox(
                            height: height * 0.05,
                            width: height * 0.05,
                            child: Center(
                                child: Text(
                              (pets.length - 3).toString() + '+',
                              style: TextStyle(color: Colors.white),
                            ))))),
            Positioned(
                top: width * smallPadRate,
                left: width * smallPadRate,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            strokeAlign: StrokeAlign.outside)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/assets/cat_avatar0.png'),
                    ))),
          ],
        );
    }
    //  return Container(
    //           margin: EdgeInsets.only(
    //               bottom: width * extraSmallPadRate,
    //               top: width * mediumPadRate,
    //               right: width * extraSmallPadRate,
    //               left: 0),
    //           padding: EdgeInsets.all(width * smallPadRate * 0.25),
    //           height: height * 0.1,
    //           width: height * 0.1,
    //           // decoration: BoxDecoration(
    //           //   color: primaryColor.withOpacity(0.15),
    //           //   borderRadius: BorderRadius.circular(15),
    //           // ),
    //           child: pets.length > 1
    //               ?

    //       : ,
    // );
  }
}
