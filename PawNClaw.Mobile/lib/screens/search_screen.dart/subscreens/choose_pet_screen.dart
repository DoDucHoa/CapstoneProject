import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
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
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: const Text(
              "Chọn pet",
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
                          builder: (context) {
                            return PetRequestsDialog(
                                requests: state is UpdatePetSelected
                                    ? state.requests
                                    : []);
                          });
                    },
                    icon: Icon(
                      Icons.pets,
                      color: primaryFontColor,
                      size: width * largeFontRate,
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
              onPressed: () => Navigator.of(context).pop(),
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
                  horizontal: width * 0.1,
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
                        fontSize: width * largeFontRate,
                        fontWeight: FontWeight.bold,
                        color: primaryFontColor,
                      ),
                    ),
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
                  height: width * 0.35,
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
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<SearchBloc>(context)
                                    .add(AddPetRequest(state.pets));
                                setState(() {});
                              },
                              child: const Text(
                                "Tạo yêu cầu",
                                style: TextStyle(color: Colors.white),
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
                            horizontal: width * regularPadRate,
                            vertical: width * smallPadRate,
                          ),
                          child: Text(
                            state is PetsLoaded
                                ? "Thú cưng của bạn (" +
                                    state.pets.length.toString() +
                                    ")"
                                : "Thú cưng của bạn (0)",
                            style: TextStyle(
                              fontSize: width * largeFontRate,
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
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
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
                          .add(ConfirmRequest(state.requests));
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
