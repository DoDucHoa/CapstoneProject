import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
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
  List<SupplyOrders> getPetForSupplies(
      BookingDetail booking, List<SupplyOrders> supplies) {
    List<Pet> pets = [];
    booking.bookingDetails!.forEach(
      (cage) => cage.petBookingDetails!.forEach(
        (pet) {
          pet.pet!.id = pet.petId;
          pets.add(pet.pet!);
        },
      ),
    );
    supplies.forEach(
      (supply) {
        pets.forEach((pet) {
          if (pet.id == supply.petId) {
            supply.pet = pet;
          }
        });
      },
    );
    return supplies;
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    List<SupplyOrders> supplies =
        getPetForSupplies(booking, booking.getUndoneSupplyAct());
    double width = MediaQuery.of(context).size.width;
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
                      pet: supplies[index].pet!,
                      supply: supplies[index],
                      booking: booking,
                    ))),
            child: Container(
              margin: EdgeInsets.only(
                right: width * smallPadRate,
                left: width * smallPadRate,
                top: width * smallPadRate,
              ),
              child: ActivityCard(
                photo: supplies[index].supply!.photos!.first.url,
                activityName: supplies[index].supply!.name!,
                note: supplies[index].note ?? "Không có ghi chú",
                remainCount: booking.getRemainSupplyAct(supplies[index]),
                booking: booking,
                pet: supplies[index].pet!,
              ),
            ),
          ),
          itemCount: supplies.length,
        ),
      ),
    );
  }
}
