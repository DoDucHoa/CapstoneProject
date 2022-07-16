import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pncstaff_mobile_application/blocs/activity/activity_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/supply_activity.dart';

class BookingCageScreen extends StatefulWidget {
  const BookingCageScreen(
      {required this.bookings, required this.bookingDetail, Key? key})
      : super(key: key);

  final List<BookingDetail?> bookings;
  final BookingDetails bookingDetail;

  @override
  State<BookingCageScreen> createState() => _BookingCageScreenState();
}

class _BookingCageScreenState extends State<BookingCageScreen> {
  List<Pet> pets = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookings = widget.bookings;
    var bookingDetail = widget.bookingDetail;
    BookingDetail booking = BookingDetail();
    bookings.forEach((element) {
      if (element!.id == bookingDetail.bookingId) booking = element;
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          bookingDetail.cageCode ?? "",
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * mediumPadRate),
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
                          booking.customer!.name ?? "",
                          style: TextStyle(
                            fontSize: width * largeFontRate,
                            fontWeight: FontWeight.w500,
                            color: primaryFontColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: booking.customer!.idNavigation!.phone!));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    );
  }
}
