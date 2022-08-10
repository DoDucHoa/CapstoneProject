import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/pet/pet_repository.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/components/pet_card.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/subscreens/add_pet_screen.dart';

class MyPetScreen extends StatefulWidget {
  const MyPetScreen({Key? key}) : super(key: key);

  @override
  State<MyPetScreen> createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  List<Pet>? pets;
  Account? account;

  @override
  void initState() {
    var authState = BlocProvider.of<AuthBloc>(context).state as Authenticated;
    account = authState.user;

    PetRepository().getPetsByCustomer(customerId: account!.id!).then((value) {
      setState(() {
        pets = value;
      });
    });

    super.initState();
  }

  Future<void> onRefreshPets() async {
    var authState = BlocProvider.of<AuthBloc>(context).state as Authenticated;
    account = authState.user;
    PetRepository().getPetsByCustomer(customerId: account!.id!).then((value) {
      setState(() {
        pets = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return (pets != null)
        ? RefreshIndicator(
            onRefresh: () => PetRepository()
                    .getPetsByCustomer(customerId: account!.id!)
                    .then((value) {
                  setState(() {
                    pets = value;
                  });
                }),
            child: Scaffold(
              backgroundColor: frameColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined,
                      color: Colors.black),
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
                title: Text(
                  'My Pet',
                  style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: width * regularFontRate),
                ),
                backgroundColor: frameColor,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: width * mediumPadRate, vertical: smallPadRate),
                child: Column(

                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: width * smallPadRate,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: width * smallPadRate),
                      itemBuilder: (context, index) {
                        return (index == pets!.length)
                            ? GestureDetector(
                                onTap: (() => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => AddPetScreen(
                                            customerId: account!.id!)))),
                                child: Container(
                                  width: width * 0.15,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: primaryBackgroundColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: DottedBorder(
                                      radius: Radius.circular(15),
                                      color: primaryColor,
                                      strokeWidth: 2,
                                      strokeCap: StrokeCap.round,
                                      borderType: BorderType.RRect,
                                      dashPattern: const <double>[5, 5],
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.add_circle_rounded,
                                              color: primaryColor,
                                              size: 18,
                                            ),
                                            Text(
                                              'Thêm thú cưng',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: width * smallFontRate,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            : PetCard(
                                size: MediaQuery.of(context).size,
                                pet: pets![index],
                              );
                      },
                      itemCount: pets!.length + 1,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                    ),
                    Container(height: height*0.5,)
                  ],
                ),
              ),
            ))
        : const LoadingIndicator(loadingText: 'Vui lòng đợi..');
  }
}
