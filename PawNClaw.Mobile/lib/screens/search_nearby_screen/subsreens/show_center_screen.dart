import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawnclaw_mobile_application/common/components/elevated_container.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/screens/search_by_name_screen/components/search_bar.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

import '../../../blocs/nearby_center/nearby_bloc.dart';
import '../components/center_card.dart';

class AvailableCenterScreen extends StatefulWidget {
  const AvailableCenterScreen({Key? key}) : super(key: key);

  @override
  State<AvailableCenterScreen> createState() => _AvailableCenterScreenState();
}

class _AvailableCenterScreenState extends State<AvailableCenterScreen> {
  @override
  void initState() {}

  TextEditingController controller = TextEditingController();
  List<petCenter.Center>? centers = [];
  int isFound = -1; // -1:init, 1: found, 0: finding, 2: not found
  String query = '';
  List<String>? suggestions = [];
  late List<String> centersName;
  late List<petCenter.Center> allCenters;
  double longitude = 0;
  double latitude = 0;
  String address = '';
  // late StreamSubscription<Position> streamSubscription;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var query = controller.text;

    return BlocBuilder<NearbyBloc, NearbyState>(builder: (context, state) {
      return (state is LoadCentersNearby)
          ? Scaffold(
              backgroundColor: frameColor,
              appBar: AppBar(
                backgroundColor: frameColor,
                elevation: 1,
                toolbarHeight: height * 0.1,
                bottom: PreferredSize(
                  preferredSize: Size(width, height * 0.07),
                  child: Container(
                    width: width,
                    padding: EdgeInsets.fromLTRB(
                        width * smallPadRate, 0, 0, width * smallPadRate),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gần tôi',
                          style: TextStyle(
                              color: primaryFontColor,
                              fontSize: width * largeFontRate,
                              height: 1,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                          Container(
                            height: 15,
                            child: Text(
                              state.address,
                              style: TextStyle(
                                  color: primaryFontColor,
                                  fontSize: 15,
                                  height: 1, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                //titleSpacing: 10,
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    )),
                leadingWidth: width * regularPadRate,
                //title:
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: width * smallPadRate),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //centers found

                      ListView.builder(
                        itemBuilder: ((context, index) {
                          return CenterCard(location: state.response[index]);
                        }),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: state.response.length,
                      )
                    ]),
              ),
            )
          : LoadingIndicator(loadingText: 'Đang tìm kiếm..');
    });
  }
}
