import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/components/search_fail_dialog.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/subscreens/choose_pet_screen.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/subscreens/fill_information_screen.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/subscreens/show_center.dart';
import 'package:pawnclaw_mobile_application/screens/home_screen/HomeScreen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/center_details_screen.dart';


class SearchScreen extends StatefulWidget {
  final int centerId;
  final bool isSponsor;
  const SearchScreen({required this.centerId, required this.isSponsor,Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    var authState = BlocProvider.of<AuthBloc>(context).state as Authenticated;
    var account = authState.user;
    BlocProvider.of<PetBloc>(context).add(
      GetPets(account),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(InitCheck(widget.centerId)),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is FillingInformation) {
            return FillInformationScreen(isSponsor:widget.isSponsor);
          }
          if (state is CheckCenterInitial || state is UpdatePetSelected) {
            return  ChoosePetScreen(centerId:widget.centerId);
          }
          if (state is SearchCompleted) {
            
            return const AvailableCenterScreen();
          }
          if (state is SearchFail) {
            // if (widget.isSponsor){
            //   return const AvailableCenterScreen();
            // }
            var statusMessage = state.errorMessage;
            return SearchFailDialog(
                errorMessage: statusMessage,
                );
          }
          if (state is CheckedCenter){
            return CenterDetails(petCenterId: widget.centerId, requests: state.requests, bookingDate: state.bookingDate, endDate: DateTime.parse(state.center.endBooking!), due: state.due);
          }
          return const Scaffold(
              backgroundColor: Colors.white,
              body: LoadingIndicator(
                  loadingText: "Vui lòng đợi"));
        },
      ),
    );
  }
}
