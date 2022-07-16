import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/activity_card.dart';

class NextUpTasks extends StatelessWidget {
  const NextUpTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.all(0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
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
                        "Alice Smith",
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
                    itemCount: 2,
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
                        )
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: width * smallPadRate,
                    //     vertical: width * extraSmallPadRate,
                    //   ),
                    //   margin: EdgeInsets.only(
                    //       bottom: width * extraSmallPadRate),
                    //   width: width * 0.7,
                    //   height: height * 0.095,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //     color: Colors.white,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment:
                    //             CrossAxisAlignment.start,
                    //         mainAxisAlignment:
                    //             MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           Text(
                    //             "Cho ăn #CAGECODE",
                    //             style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.w600,
                    //               color: primaryFontColor,
                    //             ),
                    //           ),
                    //           Text(
                    //             "#CAGETYPE NAME",
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.w600,
                    //               color: lightFontColor,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
