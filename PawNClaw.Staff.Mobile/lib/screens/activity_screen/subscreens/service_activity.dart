import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/activity_card.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/activity_detail.dart';

class ServiceActivity extends StatefulWidget {
  const ServiceActivity({super.key, required this.booking});
  final BookingDetail booking;
  @override
  State<ServiceActivity> createState() => _ServiceActivityState();
}

class _ServiceActivityState extends State<ServiceActivity> {
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
    booking.serviceOrders!.forEach((service) {
      pets.forEach((pet) {
        if (service.petId == pet.id) {
          service.pet = pet;
        }
      });
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Dich vụ",
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
                      pet: booking.serviceOrders![index].pet!,
                      service: booking.serviceOrders![index],
                    ))),
            child: ActivityCard(
              activityName: booking.serviceOrders![index].service!.description!,
              note: booking.serviceOrders![index].note ?? "Không có ghi chú",
              remainCount:
                  booking.getRemainServiceAct(booking.serviceOrders![index]),
              booking: booking,
              pet: booking.serviceOrders![index].pet!,
            ),
          ),
          itemCount: booking.serviceOrders!.length,
        ),
      ),
    );
  }
}
