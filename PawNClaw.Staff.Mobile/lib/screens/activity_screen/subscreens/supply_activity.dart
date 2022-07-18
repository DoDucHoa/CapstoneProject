import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/activity_card.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/activity_detail.dart';

class SupplyActivity extends StatefulWidget {
  SupplyActivity({Key? key, required this.booking}) : super(key: key);
  final BookingDetail booking;
  @override
  State<SupplyActivity> createState() => _SupplyActivityState();
}

class _SupplyActivityState extends State<SupplyActivity> {
  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (cage) => cage.petBookingDetails!.forEach(
        (element) {
          pets.add(element.pet!);
        },
      ),
    );
    booking.supplyOrders!.forEach((supply) {
      pets.forEach((pet) {
        if (supply.petId == pet.id) {
          supply.pet = pet;
        }
      });
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Đồ dùng",
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
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ActivityDetail(
                      pet: booking.supplyOrders![index].pet!,
                      supply: booking.supplyOrders![index],
                    ))),
            child: ActivityCard(
              activityName: booking.supplyOrders![index].supply!.name!,
              note: booking.supplyOrders![index].note ?? "Không có ghi chú",
              remainCount:
                  booking.getRemainSupplyAct(booking.supplyOrders![index]),
              booking: booking,
              pet: booking.supplyOrders![index].pet!,
            ),
          ),
          itemCount: booking.supplyOrders!.length,
        ),
      ),
    );
  }
}
