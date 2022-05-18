import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/pet/pet_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/area.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/show_center.dart';
import 'subscreens/choose_pet_screen.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => SearchBloc()..add(InitSearch()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is FillingInformation) {
            return FillInformationScreen(height: height, width: width);
          }
          if (state is SearchInitial || state is UpdatePetSelected) {
            return ChoosePetScreen(width: width, height: height);
          }
          if (state is SearchCompleted) {
            return AvailableCenterScreen(height: height, width: width);
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
