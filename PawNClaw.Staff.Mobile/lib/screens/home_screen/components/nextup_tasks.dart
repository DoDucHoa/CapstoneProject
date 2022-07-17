import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/activity_card.dart';

class NextUpTasks extends StatefulWidget {
  const NextUpTasks({required this.bookings, Key? key}) : super(key: key);
  final List<BookingDetail> bookings;
  @override
  State<NextUpTasks> createState() => _NextUpTasksState();
}

class _NextUpTasksState extends State<NextUpTasks> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var bookings = widget.bookings;
    return SingleChildScrollView(
      padding: EdgeInsets.all(0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: width * smallPadRate),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("lib/assets/cus0.png"),
                        backgroundColor: Colors.white,
                        radius: height * 0.03,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        bookings[index].customer!.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: lightFontColor,
                        height: 1,
                      ),
                    )
                  ],
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookings[index].getUndoneSupplyAct().length,
                    itemBuilder: (context, supIndex) {
                      List<SupplyOrders> supplies =
                          bookings[index].getUndoneSupplyAct();
                      return Padding(
                        padding: EdgeInsets.only(left: width * regularPadRate),
                        child: ActivityCard(
                            activityName: "${supplies[supIndex].supply!.name}",
                            note: "${supplies[supIndex].note}",
                            pet: supplies[supIndex].pet!,
                            // Pet(
                            //     breedName: "Scottish Straight Cat",
                            //     name: "Alice"),
                            booking: bookings[index],
                            remainCount: 1),
                      );
                    }),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookings[index].getUndoneServiceAct(),
                    itemBuilder: (context, index) => Padding(
                          padding:
                              EdgeInsets.only(left: width * regularPadRate),
                          child: ActivityCard(
                              activityName: "Pate mèo vị cá ngừ",
                              note: "không có ghi chú",
                              pet: Pet(
                                  breedName: "Scottish Straight Cat",
                                  name: "Alice"),
                              booking: BookingDetail(),
                              remainCount: 1),
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}
