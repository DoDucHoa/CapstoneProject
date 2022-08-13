import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../common/constants.dart';
import '../../../models/pet.dart';
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
                height: height *0.05,
                width: height *0.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height),
                    image: (pets[0].photos!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(pets[0].photos!.first.url!),
                            fit: BoxFit.contain)
                        : null,
                    border: Border.all(
                        color: Colors.white,
                        width: 3,
                        /*strokeAlign: StrokeAlign.outside*/)),
                child: (pets[0].photos!.isEmpty)
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                            (pets[0].petTypeCode == 'DOG')
                                ? 'lib/assets/dog.png'
                                : 'lib/assets/black-cat.png'),
                      )
                    : null,
              ),
            ),
            Positioned(
                top: width * extraSmallPadRate * 1.5,
                left: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[1].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[1].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[1].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[1].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
          ],
        );

      case 1:
        return Center(
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                image: (pets[0].photos!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(pets[0].photos!.first.url!),
                        fit: BoxFit.contain)
                    : null,
                border: Border.all(
                    color: Colors.white,
                    width: 3,
                    /*strokeAlign: StrokeAlign.outside*/)),
            child: (pets[0].photos!.isEmpty)
                ? CircleAvatar(
                    backgroundImage: AssetImage((pets[0].petTypeCode == 'DOG')
                        ? 'lib/assets/dog.png'
                        : 'lib/assets/black-cat.png'),
                  )
                : null,
          ),
        );
      case 3:
        return Stack(
          children: [
            Positioned(
                left: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[0].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[0].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[0].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[0].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
            Positioned(
                top: width * mediumPadRate,
                right: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[1].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[1].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[1].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[1].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
            Positioned(
                top: width * extraSmallPadRate,
                left: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[2].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[2].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[2].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[2].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
          ],
        );
      default:
        return Stack(
          children: [
            Positioned(
                right: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[0].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[0].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[0].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[0].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
            Positioned(
                left: width * extraSmallPadRate,
                bottom: width * extraSmallPadRate,
                child: Container(
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[1].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[1].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/)),
                  child: (pets[1].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[1].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
            Positioned(
                top: width * extraSmallPadRate,
                right: width * extraSmallPadRate,
                child: Container(
                    width: height *0.05,
                    height: height *0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height),
                        image: pets.length == 4
                            ? (pets[3].photos!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                        pets[3].photos!.first.url!),
                                    fit: BoxFit.contain)
                                : null
                            : null,
                        color: pets.length > 4
                            ? lightFontColor
                            : Colors.transparent,
                        border: Border.all(
                            color: Colors.white,
                            width: 3,
                            /*strokeAlign: StrokeAlign.outside*/)),
                    child: pets.length == 4
                        ? (pets[3].photos!.isEmpty)
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                    (pets[3].petTypeCode == 'DOG')
                                        ? 'lib/assets/dog.png'
                                        : 'lib/assets/black-cat.png'),
                              )
                            : null
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
                  height: height *0.05,
                  width: height *0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height),
                      image: (pets[2].photos!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(pets[2].photos!.first.url!),
                              fit: BoxFit.contain)
                          : null,
                      border: Border.all(
                          color: Colors.white,
                          width: 3,
                          /*strokeAlign: StrokeAlign.outside*/
                          )),
                  child: (pets[2].photos!.isEmpty)
                      ? CircleAvatar(
                          backgroundImage: AssetImage(
                              (pets[2].petTypeCode == 'DOG')
                                  ? 'lib/assets/dog.png'
                                  : 'lib/assets/black-cat.png'),
                        )
                      : null,
                )),
          ],
        );
    }
  }
}