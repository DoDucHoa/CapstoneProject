import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/repositories/sponsor_banner/sponsor_repository.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/main_screen.dart';

import '../components/center_card.dart';

class AvailableCenterScreen extends StatefulWidget {
  const AvailableCenterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AvailableCenterScreen> createState() => _ShowAvailableCenterState();
}

class _ShowAvailableCenterState extends State<AvailableCenterScreen> {
  bool isSponsor = false;
  List<petCenter.Center>? centers;
  late Future<List<petCenter.Center>?> sponsors;
  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SearchBloc>(context).state as SearchCompleted;
    if (state.searchResponse.result!.contains('sponsors')) {
      var sponsorState =
          BlocProvider.of<SponsorBloc>(context).state as LoadedBanners;
      var banners = sponsorState.banners;

      List<int> sponsorBrandIds = banners.map((e) => e.brandId!).toList();
      centers = [];
      for (var brandId in sponsorBrandIds) {
        centers!.addAll(state.centers
            .where((element) => element.brandId == brandId)
            .toList());
      }
      isSponsor = true;
    } else {
      centers = state.centers;
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              isSponsor ? "Khuyến mãi" : "Khách sạn thú cưng",
              style: TextStyle(
                fontSize: width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: primaryFontColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => SearchScreen())),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.flag_circle_rounded,
                size: 65,
                color: lightFontColor,
              ),
              Container(
                width: width * (1 - 2 * mediumPadRate),
                child: Text(
                  'Rất tiếc! Trung tâm không còn\n phòng trống nào theo yêu cầu của bạn.\nBạn có thể tham khảo những khách sạn \n ở khu vực lân cận sau đây.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: lightFontColor,
                      height: 1.2),
                ),
              ),

              ListView.builder(
                itemCount: centers!.length,
                itemBuilder: ((context, index) {
                  return CenterCard(
                    center: centers![index],
                  );
                }),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
              //bloc
            ],
          ),
        );
      },
    );
  }

  // Future<List<petCenter.Center>?> buildSuggestions(state) async {
  //   try {
  //     int checkedCenterId =
  //         int.parse((state as SearchCompleted).searchResponse.result!.trim());
  //     var sponsorState =
  //         BlocProvider.of<SponsorBloc>(context).state as LoadedBanners;
  //     var banners = sponsorState.banners;

  //     List<int> sponsorBrandIds = banners.map((e) => e.brandId!).toList();
  //     print(sponsorBrandIds);

  //     List<petCenter.Center> centers = [];

  //     for (var id in sponsorBrandIds) {
  //       await SponsorRepository().getCentersByBrandId(id).then((value) {
  //         if (value != null) centers.add(value.first);
  //       });
  //     }
  //     print('im here');
  //     centers.forEach((element) {
  //       print(element.toJson());
  //     });
  //     centers.removeWhere((element) => element.id == checkedCenterId);
  //     return centers;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
