import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

import 'components/pet_bubble.dart';
import 'components/pet_card.dart';

class ChoosePetScreen extends StatefulWidget {
  const ChoosePetScreen({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  State<ChoosePetScreen> createState() => _ChoosePetScreenState();
}

class _ChoosePetScreenState extends State<ChoosePetScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              "Choose Pet",
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
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide.none,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(widget.width * 0.05),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                ),
                                height: widget.height * 0.7,
                                width: widget.width * 0.7,
                                child: state is UpdatePetSelected
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Pet Requests",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.requests.length,
                                            itemBuilder:
                                                (context, requestIndex) {
                                              return Container(
                                                width: widget.width * 0.5,
                                                height: widget.width * 0.2,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemCount: state
                                                      .requests[requestIndex]
                                                      .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return SelectedPetBubble(
                                                        width: widget.width,
                                                        pet: state.requests[
                                                                requestIndex]
                                                            [index]);
                                                  }),
                                                ),
                                              );
                                            },
                                          ),
                                          Spacer(),
                                          Text(
                                            "*Notice: Pets in the same request will be placed in the same cage.",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.pets,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(250),
                      ),
                      child: Center(
                        child: Text(
                          state is UpdatePetSelected
                              ? state.requests.length.toString()
                              : "0",
                          style: TextStyle(color: Colors.white),
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
                color: Colors.black87,
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
                  horizontal: widget.width * 0.1,
                  vertical: widget.width * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state is UpdatePetSelected
                          ? "Selected pets " +
                              '(' +
                              state.pets.length.toString() +
                              ')'
                          : "Selected pets (0)",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                    horizontal: widget.width * 0.1,
                  ),
                  height: widget.width * 0.35,
                  child: state is UpdatePetSelected
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.pets.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    SelectedPetBubble(
                                  width: widget.width,
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
                              child: Text(
                                "Create Request",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
              BlocBuilder<PetBloc, PetState>(
                builder: (context, state) {
                  return Container(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.width * 0.1,
                              vertical: widget.width * 0.03,
                            ),
                            child: Text(
                              state is PetsLoaded
                                  ? "Your pets (" +
                                      state.pets.length.toString() +
                                      ")"
                                  : "Your pets (0)",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
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
                                            width: widget.width,
                                            height: widget.height,
                                            onPressed: () {
                                              BlocProvider.of<SearchBloc>(
                                                      context)
                                                  .add(SelectPet(
                                                      state.pets[index]));
                                              setState(() {});
                                            },
                                          );
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
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
                      BlocProvider.of<SearchBloc>(context).add(ConfirmRequest(
                          (state as UpdatePetSelected).requests));
                    }
                  : () {},
              child: Icon(
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
