import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/nearby_center/nearby_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

import 'components/show_address_dialog.dart';
import 'subsreens/show_center_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NearbyBloc()..add(GetCurrentLocation()),
      child: BlocBuilder<NearbyBloc, NearbyState>(
        builder: (context, state) {
          if (state is LoadedCurrentPosition) {
            //print('Loaded position');
            return const ShowAddressDialog();
          }
          if (state is LoadCentersNearby) {
            //print('Loaded CENTERS');
            return const AvailableCenterScreen();
          }

          return const Scaffold(
              backgroundColor: Colors.white,
              body: LoadingIndicator(loadingText: "Vui lòng đợi"));
        },
      ),
    );
  }
}
