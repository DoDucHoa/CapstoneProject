import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

import '../components/pet_bubble.dart';
import '../components/pet_card.dart';

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
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide.none,
                              ),
                              child: Container(
                                padding:
                                    EdgeInsets.all(widget.width * smallPadRate),
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
                                            "Yêu cầu của bạn",
                                            style: TextStyle(
                                              fontSize: widget.width *
                                                  regularFontRate,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.requests.length,
                                            itemBuilder:
                                                (context, requestIndex) {
                                              return SizedBox(
                                                width: widget.width * 0.5,
                                                height: widget.width * 0.2,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ScrollPhysics(),
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
                                          const Spacer(),
                                          Text(
                                            "*Lưu ý: những em thú cưng thuộc về cùng yêu cầu sẽ được xếp chung một chuồng.",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.pets,
                      color: primaryFontColor,
                      size: widget.width * largeFontRate,
                    ),
                  ),
                  Positioned(
                    right: widget.width * 0.00875,
                    top: widget.width * 0.00875,
                    child: Container(
                      height: widget.width * regularFontRate,
                      width: widget.width * regularFontRate,
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
              icon: const Icon(
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
                          ? "Thú cưng đã chọn (" +
                              state.pets.length.toString() +
                              ')'
                          : "Thú cưng đã chọn (0)",
                      style: const TextStyle(
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
                            horizontal: widget.width * 0.1,
                            vertical: widget.width * 0.03,
                          ),
                          child: Text(
                            state is PetsLoaded
                                ? "Thú cưng của bạn (" +
                                    state.pets.length.toString() +
                                    ")"
                                : "Thú cưng của bạn (0)",
                            style: const TextStyle(
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
