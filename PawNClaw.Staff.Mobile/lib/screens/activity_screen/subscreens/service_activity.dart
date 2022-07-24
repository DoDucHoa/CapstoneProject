import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
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
  List<ServiceOrders> getPetForServices(
      BookingDetail booking, List<ServiceOrders> services) {
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (cage) => cage.petBookingDetails!.forEach(
        (pet) {
          pets.add(pet.pet!);
        },
      ),
    );
    services.forEach(
      (service) {
        pets.forEach((pet) {
          if (pet.id == service.petId) {
            service.pet = pet;
          }
        });
      },
    );
    return services;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final booking = widget.booking;
    List<ServiceOrders> services =
        getPetForServices(booking, booking.getUndoneServiceAct());
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
                      pet: services[index].pet!,
                      service: services[index],
                      booking: booking,
                    ))),
            child: Container(
              margin: EdgeInsets.only(
                right: width * smallPadRate,
                left: width * smallPadRate,
                top: width * smallPadRate,
              ),
              child: ActivityCard(
                activityName: services[index].service!.description!,
                note: services[index].note ?? "Không có ghi chú",
                remainCount: booking.getRemainServiceAct(services[index]),
                booking: booking,
                pet: services[index].pet!,
              ),
            ),
          ),
          itemCount: services.length,
        ),
      ),
    );
  }
}
