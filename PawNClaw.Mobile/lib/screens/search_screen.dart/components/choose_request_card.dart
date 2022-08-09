import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../../models/cage_type.dart';

class ChooseRequestCard extends StatefulWidget {
  const ChooseRequestCard(
      {required this.requests,
      required this.cageType,
      required this.callback,
      Key? key})
      : super(key: key);

  final List<List<Pet>> requests;
  final CageTypes cageType;
  final PetsCallback callback;
  @override
  State<ChooseRequestCard> createState() => _ChooseRequestCardState();
}

typedef void PetsCallback(List<int> val);

class _ChooseRequestCardState extends State<ChooseRequestCard> {
  List<Pet>? pets;
  int selectedIndex = 0;
  bool haveAvailableRequests = false;
  bool isSuitable(List<Pet> request, CageTypes cageTypes) {
    if (cageTypes.isSingle!) return request.length == 1;
    return true;
  }

  @override
  void initState() {
    for (var i = 0; i < widget.requests.length; i++) {
      if (isSuitable(widget.requests[i], widget.cageType)) {
        haveAvailableRequests = true;
        pets = widget.requests[i];
        selectedIndex = i;
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<BookingBloc>(context).state;
    var booking = (state as BookingUpdated).booking;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.2,
      width: width,
      color: Colors.white,
      child: SizedBox(
        height: width,
        child: (haveAvailableRequests)
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return isSuitable(widget.requests[index], widget.cageType)
                      ? InkWell(
                          onTap: () {
                            pets = widget.requests[index];
                            List<int> result = [];
                            pets!.forEach(
                                ((element) => result.add(element.id!)));
                            setState(() {
                              selectedIndex = index;
                              pets = widget.requests[index];
                            });
                            print('selectedindex ' + selectedIndex.toString());
                            print(index);
                            print(result);
                            widget.callback(result);
                            //print(context.read<BookingBloc>().state);
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
                                child: PetRequestCard(
                                    widget.requests[index], context)),
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
                          ]))
                      : Container();
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 12,
                ),
                itemCount: widget.requests.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
              )
            : Container(
                padding: EdgeInsets.all(width * regularPadRate),
                margin: EdgeInsets.fromLTRB(width * smallPadRate, 0,
                    width * smallPadRate, width * smallPadRate),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  'Bạn không có thú cưng nào phù hợp với chuồng này!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: width * regularFontRate),
                  textAlign: TextAlign.center,
                ),
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
                height: 43,
                width: 43,
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
                  height: 43,
                  width: 43,
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
                  height: 43,
                  width: 43,
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
                  height: 43,
                  width: 43,
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
                  height: 43,
                  width: 43,
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
                  height: 43,
                  width: 43,
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
                  height: 43,
                  width: 43,
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
                    width: 43,
                    height: 43,
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
                  height: 43,
                  width: 43,
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
