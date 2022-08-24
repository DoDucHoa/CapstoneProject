import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pncstaff_mobile_application/blocs/search/search_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/pet_card.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/service_activity.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/supply_activity.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/subscreens/booking_cage.dart';

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
              onPressed: () {
                BlocProvider.of<SearchBloc>(context).add(ClearSearch());
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * smallPadRate),
                child: Text(
                  "Thú cưng",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryFontColor,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => PetCard(pet: pets[index]),
                  itemCount: pets.length,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * smallPadRate),
                child: Text(
                  "Hoạt động",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryFontColor,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * smallPadRate),
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  (booking.getRemainFeedingAct() > 0)
                      ? InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BookingCageScreen(
                                      booking: booking,
                                      bookingDetail:
                                          booking.bookingDetails!.first))),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: width * smallPadRate),
                            constraints: BoxConstraints(
                              minHeight: width * 0.35,
                              minWidth: width * 0.35,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(width * smallPadRate * 0.7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.fastfood_rounded,
                                      color: Colors.white,
                                      size: 20,
                                      // size: 20,
                                    ),
                                  ),
                                  Text(
                                    booking.getRemainFeedingAct().toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.085,
                                        color: primaryFontColor,
                                        // height: 1
                                        ),
                                  ),
                                  Text(
                                    "Cho ăn",
                                    style: TextStyle(
                                        color: primaryFontColor,
                                        fontSize: width * 0.048,
                                        height: 1
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (booking.getUndoneSupplyAct().isNotEmpty)
                      ? InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SupplyActivity(booking: booking))),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: width * smallPadRate),
                            constraints: BoxConstraints(
                              minHeight: width * 0.35,
                              minWidth: width * 0.35,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(width * smallPadRate * 0.7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.shopping_cart_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    booking
                                        .getUndoneSupplyAct()
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.085,
                                        color: primaryFontColor),
                                  ),
                                  Text(
                                    "Đồ dùng",
                                    style: TextStyle(
                                        color: primaryFontColor,
                                        fontSize: width * 0.048,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (booking.getUndoneServiceAct().isNotEmpty)
                      ? InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceActivity(booking: booking))),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: width * smallPadRate),
                            constraints: BoxConstraints(
                              minHeight: width * 0.35,
                              minWidth: width * 0.35,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(width * smallPadRate * 0.7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.back_hand_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    booking
                                        .getUndoneServiceAct()
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.085,
                                        color: primaryFontColor),
                                  ),
                                  Text(
                                    "Dịch vụ",
                                    style: TextStyle(
                                        color: primaryFontColor,
                                        fontSize: width * 0.048,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       right: width * smallPadRate),
                  //   width: width * 0.3,
                  //   height: width * 0.3,
                  //   decoration: BoxDecoration(
                  //     color: lightPrimaryColor,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  // ),
                ]),
              ),
            ],
          ),
        );
      } else {
        return LoadingIndicator(loadingText: "Vui lòng chờ...");
      }
    });
  }
}
