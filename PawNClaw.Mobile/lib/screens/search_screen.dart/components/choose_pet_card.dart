import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../../common/constants.dart';
import '../../../models/pet.dart';

class ChoosePetCard extends StatefulWidget {
  const ChoosePetCard({required this.requests, Key? key}) : super(key: key);

  final List<List<Pet>> requests;

  @override
  State<ChoosePetCard> createState() => _ChoosePetCardState();
}

class _ChoosePetCardState extends State<ChoosePetCard> {
  List<Pet> pets = [];
  int selectedIndex = 0;
  Pet? pet;
  @override
  Widget build(BuildContext context) {
    widget.requests.forEach((elements) {
      elements.forEach((element) {
        pets.add(element);
      });
    });
    pet = pets[0];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // pets = widget.requests[0];
    // List<int> result = [];
    // pets!.forEach(((element) => result.add(element.id!)));
    // print(result);
    // BlocProvider.of<BookingBloc>(context).add(SelectRequest(petId: result));

    return Container(
      height: height * 0.2,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * extraSmallPadRate),
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
                  setState(() {
                    selectedIndex = index;
                    pet = pets[index];
                  });
                  // List<int> result = [];
                  // pets!.forEach(((element) => result.add(element.id!)));
                  // print(result);
                  // BlocProvider.of<BookingBloc>(context)
                  //     .add(SelectPet(pet: pet!));
                  // print('pet id at choose ${pet!.id}');
                },
                child:
                    Stack(alignment: AlignmentDirectional.topCenter, children: [
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
                    child: PetCard(pets[index], context),
                  ),
                  Positioned(
                    bottom: width * regularPadRate,
                    //   left: width * 0.3 / 5,
                    child: Center(
                      child: Text(pets[index].name!,
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

  Widget PetCard(Pet pet, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: height * 0.05,
        width: height * 0.05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height),
            image: (pet.photos!.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(pet.photos!.first.url!),
                    fit: BoxFit.contain)
                : null,
            border: Border.all(
                color: Colors.white,
                width: 3,
                /*strokeAlign: StrokeAlign.outside*/)),
        child: (pet.photos!.isEmpty)
            ? CircleAvatar(
                backgroundImage: AssetImage((pet.petTypeCode == 'DOG')
                    ? 'lib/assets/dog.png'
                    : 'lib/assets/black-cat.png'),
              )
            : null,
      ),
    );
  }
}
