import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/search/search_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/pet_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state is SearchFail) {
        return Center(
          child: Text(state.error),
        );
      }
      if (state is SearchDone) {
        var booking = state.booking;
        List<Pet> pets = [];
        booking.bookingDetails!.forEach(
          (element) {
            element.petBookingDetails?.forEach((pet) {
              pets.add(pet.pet ?? Pet());
            });
          },
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.cageCode,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(width * smallPadRate),
            child: Column(
              children: [
                Text(
                  "Thú cưng",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryFontColor,
                  ),
                ),
                ListView.builder(
                  itemBuilder: (context, index) => PetCard(pet: pets[index]),
                  itemCount: pets.length,
                ),
              ],
            ),
          ),
        );
      } else {
        return LoadingIndicator(loadingText: "Vui lòng chờ...");
      }
    });
  }
}
