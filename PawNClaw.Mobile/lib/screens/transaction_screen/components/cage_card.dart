import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../common/constants.dart';
import '../../../models/transaction_details.dart';

class CageCard extends StatelessWidget {
  final List<Pet> pets;
  final BuildContext context;
  const CageCard({required this.pets, required this.context,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    switch (pets.length) {
      case 2:
        return Stack(
          children: [
            Positioned(
                right: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate * 1.5,
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
                  ),
                )),
            Positioned(
                top: width * extraSmallPadRate * 1.5,
                left: width * extraSmallPadRate,
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
                left: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
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
                right: width * extraSmallPadRate,
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
                top: width * extraSmallPadRate,
                left: width * extraSmallPadRate,
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
                right: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
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
                left: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
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
                top: width * extraSmallPadRate,
                right: width * extraSmallPadRate,
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
                top: width * extraSmallPadRate,
                left: width * extraSmallPadRate,
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
}}