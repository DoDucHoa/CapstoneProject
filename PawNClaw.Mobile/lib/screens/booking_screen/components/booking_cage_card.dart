import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';

class BookingCageCard extends StatelessWidget {
  const BookingCageCard(
      {Key? key,
      required this.booking,
      required this.request,
      required this.center})
      : super(key: key);

  final BookingRequestModel booking;
  final List<Pet> request;
  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    List<int> petsId = [];
    List<CageTypes> cageTypes = center.cageTypes!;
    List<Cages> cages = [];
    request.forEach(((element) => petsId.add(element.id!)));
    print("petsid : " + petsId.toString());
    var bookingCage = booking.bookingDetailCreateParameters!
        .firstWhere((element) => element.petId.toString() == petsId.toString());
    
    print(bookingCage.petId.toString());
    CageTypes? cageType;
    Cages? cage;
    cageTypes.forEach((element) {
      element.cages!.forEach((c) {
        if (c.code == bookingCage.cageCode) {
          cageType = element;
          cage = c;
        }
      });
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(
                    bottom: width * extraSmallPadRate,
                    top: width * mediumPadRate,
                    right: width * extraSmallPadRate,
                    left: 0),
                padding: EdgeInsets.all(width * smallPadRate * 0.25),
                height: height * 0.1,
                width: height * 0.1,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: PetRequestCard(request, context)),
            SizedBox(
              height: height * 0.06,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.3,
                    child: Text(
                      cageType!.typeName!,
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: width * regularFontRate,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    request.fold(
                        "",
                        (previousValue, element) =>
                            previousValue + "-" + element.name!),
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate * 0.8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(
                  bottom: width * extraSmallPadRate,
                  top: width * mediumPadRate,
                  right: 0,
                  left: width * extraSmallPadRate),
              padding: EdgeInsets.all(width * smallPadRate * 0.25),
              height: height * 0.1,
              width: height * 0.1,
              decoration: BoxDecoration(
                //color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                image: (cageType!.photo?.url == null)
                    ? DecorationImage(
                        image: AssetImage('lib/assets/cage.png'),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(cageType!.photo!.url!),
                        fit: BoxFit.cover),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cage!.name!,
              style: TextStyle(
                color: primaryFontColor,
                fontWeight: FontWeight.w500,
                fontSize: width * regularFontRate * 0.8,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: NumberFormat.currency(
                            decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                        .format(bookingCage.price),
                    style: TextStyle(
                      fontSize: width * regularFontRate * 0.8 * 0.8,
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " (" + bookingCage.duration!.toString() + " ngày)",
                    style: TextStyle(
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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
                        strokeAlign: StrokeAlign.outside)),
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
                top: width * smallPadRate * 1.5,
                left: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                    strokeAlign: StrokeAlign.outside)),
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
                left: width * smallPadRate,
                bottom: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                top: width * regularPadRate,
                right: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                top: width * smallPadRate,
                left: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                right: width * smallPadRate,
                bottom: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                left: width * smallPadRate,
                bottom: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
                top: width * smallPadRate,
                right: width * smallPadRate,
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
                            strokeAlign: StrokeAlign.outside)),
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
                top: width * smallPadRate,
                left: width * smallPadRate,
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
                          strokeAlign: StrokeAlign.outside)),
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
