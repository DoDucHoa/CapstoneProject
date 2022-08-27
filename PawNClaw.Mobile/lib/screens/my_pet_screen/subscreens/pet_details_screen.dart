import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/pet_repository.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/subscreens/add_pet_screen.dart';

import '../my_pet_screen.dart';

class PetDetailScreen extends StatefulWidget {
  PetDetailScreen({required this.pet, Key? key}) : super(key: key);
  final Pet pet;

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    double appbarSize = height * 0.4;

    Pet pet = widget.pet;

    return  Scaffold(
      backgroundColor: frameColor,
      body: NestedScrollView(
        headerSliverBuilder: ((context, value) {
          return [
            SliverAppBar(
              centerTitle: true,
              //title: Text(pet.name.toString()),
              expandedHeight: appbarSize,
              pinned: true,
              floating: true,
              backgroundColor: lightPrimaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPetScreen())),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(children: [
                  Container(
                    width: width,
                    child: pet.photos!.isNotEmpty
                        ? Image.network(
                            pet.photos!.first.url!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            (pet.petTypeCode == 'DOG') ?'lib/assets/dog.png':'lib/assets/black-cat.png',
                            fit: BoxFit.cover,
                          ),
                    //child: FadeInImage.assetNetwork(placeholder: 'lib/assets/new-paw.gif', image:pet.photo),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: width * mediumPadRate,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white),
                    ),
                  )
                ]),
              ),
            )
          ];
        }),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              padding: EdgeInsets.fromLTRB(width * mediumPadRate, 0,
                  width * mediumPadRate, width * mediumPadRate),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            pet.name!,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: primaryColor),
                                margin: EdgeInsets.only(right: 5),
                                child: IconButton(
                                    onPressed: () {
                                      //update pet
                                      var customer = (context
                                              .read<AuthBloc>()
                                              .state as Authenticated)
                                          .user;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddPetScreen(
                                            customerId: customer.id!,
                                            pet: pet,
                                            isEdit: true,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Iconsax.edit_2,
                                      color: Colors.white,
                                      size: 18,
                                    ))),
                            Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red),
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        title: Text('Xóa thú cưng'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        content: Text('Bạn có chắc chắn muốn xóa thú cưng này không?'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text('Hủy'),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey[200],
                                                onPrimary: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                ),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                          ElevatedButton(
                                            child: Text('Xóa'),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                ),
                                            onPressed: () async {
                                              var isdeleted =  await PetRepository().delete(pet);
                                              if(isdeleted) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet profile deleted successfully')));
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              }
                                              else{
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pet profile not deleted')));
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          )
                                        ],
                                      ));
                                    },
                                    icon: Icon(
                                      Iconsax.profile_delete,
                                      color: Colors.white,
                                      size: 18,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      pet.breedName!,
                      style: TextStyle(
                          fontSize: width * smallFontRate,
                          fontWeight: FontWeight.w300,
                          color: lightFontColor),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(pet.birth!),
                      style: TextStyle(
                          fontSize: width * smallFontRate,
                          fontWeight: FontWeight.w700,
                          color: lightFontColor,
                          height: 1.5),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        //horizontal: width * smallPadRate * 2,
                        vertical: width * extraSmallPadRate,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * mediumPadRate),
                      height: width * regularPadRate,
                      width: width * (1 - 2 * mediumPadRate),
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
                                height: width * smallFontRate + 5,
                                child: Text(
                                  " " + pet.weight!.toStringAsFixed(1) + " kg",
                                  style: TextStyle(
                                      color: lightFontColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: width * smallFontRate,
                                      height: 1.5),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.square_foot_rounded,
                                size: width * regularFontRate,
                                color: primaryColor,
                              ),
                              Container(
                                height: width * smallFontRate,
                                child: Text(
                                  " H: " +
                                      pet.height!.toString() +
                                      " cm - L: " +
                                      pet.length!.toString() +
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
                    ),
                  ]),
            ),
            buildSmallSpacing(width),
            Container(
              width: width,
              padding: EdgeInsets.all(width * smallPadRate),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Text(
                "Lich sử kiểm tra sức khỏe",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            ListView.separated(
              separatorBuilder: (context, index) => buildSmallSpacing(width),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: ((context, index) {
                var petHealth = pet.petHealthHistories?[index];
                return Container(
                  padding: EdgeInsets.all(width * smallPadRate),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${DateFormat('dd/MM/yyyy').format(petHealth!.checkedDate!)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "By ${petHealth.centerName!}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "\n${petHealth.description!}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            //horizontal: width * smallPadRate * 2,
                            vertical: width * extraSmallPadRate,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * mediumPadRate),
                          height: width * regularPadRate,
                          width: width * (1 - 2 * mediumPadRate),
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
                                    height: width * smallFontRate + 5,
                                    child: Text(
                                      " " +
                                          petHealth.weight!.toStringAsFixed(1) +
                                          " kg",
                                      style: TextStyle(
                                          color: lightFontColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: width * smallFontRate,
                                          height: 1.5),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.square_foot_rounded,
                                    size: width * regularFontRate,
                                    color: primaryColor,
                                  ),
                                  Container(
                                    height: width * smallFontRate,
                                    child: Text(
                                      " H: " +
                                          petHealth.height!.toString() +
                                          " cm - L: " +
                                          petHealth.length!.toString() +
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
                        ),
                      ]),
                );
              }),
              itemCount: pet.petHealthHistories != null
                  ? pet.petHealthHistories!.length
                  : 0,
            )
          ],
        )),
      ),
    );
  }

  Widget buildSpacing(width) {
    return SizedBox(
      height: width * smallPadRate,
    );
  }

  Widget buildSmallSpacing(width) {
    return SizedBox(
      height: width * extraSmallPadRate,
    );
  }
}
