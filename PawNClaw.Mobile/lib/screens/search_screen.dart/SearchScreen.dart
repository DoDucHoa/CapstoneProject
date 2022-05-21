import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/choose_pet_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/show_center.dart';
import 'subscreens/fill_information_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
      create: (context) => SearchBloc()..add(InitSearch()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is FillingInformation) {
            return const FillInformationScreen();
          }
          if (state is SearchInitial || state is UpdatePetSelected) {
            return const ChoosePetScreen();
          }
          if (state is SearchCompleted) {
            return const AvailableCenterScreen();
          }
          return const Scaffold(
              backgroundColor: Colors.white,
              body: LoadingIndicator(
                  loadingText: "Đang tìm kiếm trung tâm cho bạn"));
        },
      ),
    );
  }
}
