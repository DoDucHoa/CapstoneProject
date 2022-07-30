import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/center_slider.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/confirm_booking.dart';
import 'package:pawnclaw_mobile_application/screens/my_pet_screen/my_pet_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_nearby_screen/SearchScreen.dart' as SearchNearby;
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/SearchScreen.dart' as mainSearch;
import 'package:pawnclaw_mobile_application/screens/sponsor_screen/screens/show_center.dart';

import '../../transaction_screen/subscreens/transaction_list_screen.dart';

var FeatureIcons = [
  Iconsax.building_3,
  Iconsax.money_change,
  Iconsax.map_1,
  FontAwesomeIcons.paw
];
var FeatureNames = [
  'Khách sạn',
  'Đơn hàng',
  'Gần bạn',
  'My Pet',
];

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.075),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Khuyến mãi",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: width * regularFontRate,
                color: lightFontColor,
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     margin: EdgeInsets.symmetric(vertical: width * 0.05),
            //     width: width * 0.85,
            //     height: height * 0.18,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(15)),
            //   ),
            // ),

            BlocBuilder<SponsorBloc, SponsorState>(
              builder: (context, state) {
                return (state is LoadedBanners)
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            vertical: width * smallPadRate),
                        child: CenterSlider(
                            size: Size(width, height * 0.7),
                            photoUrls: state.photoURLs,
                            durations: state.durations,
                            callback: ((index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableCenterScreen(banner: state.banners[index]),
                                ),
                              );
                            })))
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: width * 0.05),
                        margin: EdgeInsets.symmetric(vertical: width * 0.05),
                        width: width * 0.85,
                        height: height * 0.7*0.35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "lib/assets/new-paw.gif",
                          fit: BoxFit.contain,
                        ),
                      );
              },
            ),
            Text(
              "Tính năng",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: width * regularFontRate,
                color: lightFontColor,
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: width * 0.075,
                  crossAxisSpacing: width * 0.075),
              itemBuilder: ((context, index) =>
                  BuildFeatureCard(index, context)),
              itemCount: 4,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildFeatureCard(int index, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const mainSearch.SearchScreen(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TransactionList(),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchNearby.SearchScreen(),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPetScreen(),
              ),
            );
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: width * 0.05),
            child: Icon(
              FeatureIcons[index],
              size: width * 0.15,
              color: primaryColor,
            ),
          ),
          Text(
            FeatureNames[index],
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: width * smallFontRate,
              color: lightFontColor,
            ),
          ),
        ]),
      ),
    );
  }
}
