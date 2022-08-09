import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/pet_bubble.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/pet_requests_dialog.dart';

import '../components/pet_card.dart';

class ChoosePetScreen extends StatefulWidget {
  const ChoosePetScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChoosePetScreen> createState() => _ChoosePetScreenState();
}

class _ChoosePetScreenState extends State<ChoosePetScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: frameColor,
          appBar: AppBar(
            title: const Text(
              "Chọn thú cưng",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<SearchBloc>(context),
                                child: PetRequestsDialog(
                                    requests: state is UpdatePetSelected
                                        ? state.requests
                                        : []),
                              )).then((value) => context
                          .findRootAncestorStateOfType()!
                          .setState(() {}));

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => BlocProvider.value(
                      //           value: BlocProvider.of<SearchBloc>(context),
                      //           child: PetRequestsDialog(
                      //           requests: state is UpdatePetSelected
                      //               ? state.requests
                      //               : []),
                      //         )));
                    },
                    icon: Image.asset('lib/assets/black-paw.png'
                        // color: primaryFontColor,
                        // size: width * largeFontRate,
                        ),
                  ),
                  Positioned(
                    right: width * 0.00875,
                    top: width * 0.00875,
                    child: Container(
                      height: width * regularFontRate,
                      width: width * regularFontRate,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(250),
                      ),
                      child: Center(
                        child: Text(
                          state is UpdatePetSelected
                              ? state.requests.length.toString()
                              : "0",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
            leading: IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * smallPadRate,
                  vertical: width * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state is UpdatePetSelected
                          ? "Thú cưng đã chọn (" +
                              state.pets.length.toString() +
                              ')'
                          : "Thú cưng đã chọn (0)",
                      style: TextStyle(
                        fontSize: width * regularFontRate,
                        fontWeight: FontWeight.bold,
                        color: primaryFontColor,
                      ),
                    ),
                    Visibility(
                        visible: state is UpdatePetSelected
                            ? (state.pets.isNotEmpty ? true : false)
                            : false,
                        child: Container(
                            height: width * (largeFontRate + extraSmallPadRate),
                            child: state is UpdatePetSelected
                                ? ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<SearchBloc>(context)
                                          .add(AddPetRequest(state.pets));
                                      setState(() {});
                                    },
                                    child: const Text(
                                      "Tạo phòng",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  )
                                : Text('')))
                  ],
                ),
              ),
              Visibility(
                visible: state is UpdatePetSelected
                    ? (state.pets.isNotEmpty ? true : false)
                    : false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * regularPadRate,
                  ),
                  height: height * 0.1,
                  child: state is UpdatePetSelected
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.pets.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    SelectedPetBubble(
                                  width: width,
                                  pet: state.pets[index],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              BlocBuilder<PetBloc, PetState>(
                builder: (context, state) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * smallPadRate,
                            vertical: width * smallPadRate,
                          ),
                          child: Text(
                            state is PetsLoaded
                                ? "Thú cưng của bạn (" +
                                    state.pets.length.toString() +
                                    ")"
                                : "Thú cưng của bạn (0)",
                            style: TextStyle(
                              fontSize: width * regularFontRate,
                              fontWeight: FontWeight.bold,
                              color: primaryFontColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<PetBloc, PetState>(
                            builder: (context, state) {
                              return state is PetsLoaded
                                  ? ListView.builder(
                                      itemCount: state.pets.length,
                                      itemBuilder: (context, index) {
                                        return PetCard(
                                          pet: state.pets[index],
                                          onPressed: () {
                                            BlocProvider.of<SearchBloc>(context)
                                                .add(SelectPet(
                                                    state.pets[index]));
                                            setState(() {});
                                          },
                                        );
                                      },
                                    )
                                  : const LoadingIndicator(
                                      loadingText: 'Vui lòng đợi');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                  margin: EdgeInsets.all(width * smallPadRate),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryBackgroundColor,
                    // border: Border.all(
                    //     width: 1.5,
                    //     style: BorderStyle.solid,
                    //     color: primaryColor)
                  ),
                  child: DottedBorder(
                      color: primaryColor,
                      radius: Radius.circular(15),
                      borderType: BorderType.RRect,
                      strokeWidth: 2,
                      dashPattern: [5, 2],
                      child: TextButton(
                        onPressed: () {
                          //create pet
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: primaryColor),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: width * smallPadRate,
                              ),
                              Text(
                                'Thêm thú cưng',
                                style: TextStyle(
                                    fontSize: width * regularFontRate),
                              ),
                            ]),
                      )))
            ],
          ),
          floatingActionButton: Opacity(
            opacity: state is UpdatePetSelected && state.requests.isNotEmpty
                ? 1
                : 0.3,
            child: FloatingActionButton(
              onPressed: state is UpdatePetSelected && state.requests.isNotEmpty
                  ? () {
                      BlocProvider.of<SearchBloc>(context)
                          .add(ConfirmRequest(state.requests, -1));
                    }
                  : () {},
              child: const Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
