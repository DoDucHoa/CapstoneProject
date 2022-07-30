import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pncstaff_mobile_application/blocs/activity/activity_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/activity_detail.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/supply_activity.dart';

class BookingCageScreen extends StatefulWidget {
  const BookingCageScreen(
      {required this.booking, required this.bookingDetail, Key? key})
      : super(key: key);

  final BookingDetail booking;
  final BookingDetails bookingDetail;

  @override
  State<BookingCageScreen> createState() => _BookingCageScreenState();
}

class _BookingCageScreenState extends State<BookingCageScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var booking = widget.booking;
    var bookingDetail = widget.bookingDetail;
    List<Pet> pets = [];
    bookingDetail.petBookingDetails!.forEach((element) {
      pets.add(element.pet!);
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Cho ăn",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryFontColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: primaryFontColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (booking.customer != null)
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: width * mediumPadRate),
                    height: height * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: height * 0.04,
                          backgroundColor: lightPrimaryColor,
                          backgroundImage: AssetImage('lib/assets/cus0.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * smallPadRate),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.customer?.name ?? "",
                                style: TextStyle(
                                  fontSize: width * largeFontRate,
                                  fontWeight: FontWeight.w500,
                                  color: primaryFontColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: booking
                                          .customer!.idNavigation!.phone!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Số điện thoại khách hàng đã được sao chép vào bộ nhớ tạm.")));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.phone,
                                          size: width * regularFontRate,
                                          color: primaryColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${booking.customer!.idNavigation!.phone!.replaceFirst("+84", "0")}",
                                        style: TextStyle(
                                          color: lightFontColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: width * smallFontRate,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.all(width * smallPadRate),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.all(width * extraSmallPadRate + 5),
                  height: 55,
                  child: ClipRRect(
                    child: Image.asset("lib/assets/vet-ava.png"),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${bookingDetail.cageCode} (${bookingDetail.cageType})",
                      style: TextStyle(
                          color: primaryFontColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${booking.customerNote ?? "không có chú thích"}",
                      style: TextStyle(
                          color: lightFontColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ]),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => setState(() {
                    selectedIndex = index;
                  }),
                  child: Container(
                    padding: EdgeInsets.only(right: width * smallPadRate),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * smallPadRate),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("lib/assets/cat_avatar0.png"),
                            radius: width * 0.08,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pets[index].name!,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: primaryFontColor),
                              ),
                              Text(
                                pets[index].breedName!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: lightFontColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: pets.length,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   // () => Navigator.of(context).push(MaterialPageRoute(
      //   //     builder: (context) => ActivityScreen(booking: booking!))),
      //   label: Text("Ghi chép hoạt động"),
      //   icon: Icon(Icons.assignment_sharp),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ActivityDetail(
                  booking: booking,
                  pet: pets[selectedIndex],
                  cage: bookingDetail,
                ))),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Cập nhật hoạt động"),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
