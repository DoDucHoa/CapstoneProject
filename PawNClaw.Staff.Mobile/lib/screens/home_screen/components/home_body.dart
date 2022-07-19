import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:intl/intl.dart';

import 'booking_card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key, required this.bookings}) : super(key: key);

  final List<BookingDetail> bookings;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    var bookings = widget.bookings;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemBuilder: (context, index) => BookingCard(booking: bookings[index]),
      itemCount: bookings.length,
    );
  }
}
