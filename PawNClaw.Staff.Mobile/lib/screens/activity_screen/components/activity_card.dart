import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';

// import '../../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final String activityName;
  final String note;
  final BookingDetail booking;
  final Pet pet;
  final int remainCount;
  final String? photo;

  const ActivityCard(
      {required this.activityName,
      required this.note,
      required this.pet,
      required this.booking,
      required this.remainCount,
      this.photo,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: remainCount == 0 ? false : true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              margin: EdgeInsets.all(width * extraSmallPadRate + 5),
              height: 55,
              child: ClipRRect(
                child: photo != null
                    ? Image.network(photo!)
                    : Image.asset("lib/assets/vet-ava.png"),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${activityName} x${remainCount}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    note != "null" ? note : "Không có chú thích",
                    style: TextStyle(
                        color: lightFontColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ]),
          SizedBox(
            height: 2,
            width: width,
            child: DecoratedBox(decoration: BoxDecoration(color: frameColor)),
          ),
          Row(children: [
            Container(
                margin: EdgeInsets.all(width * extraSmallPadRate + 5),
                height: 35,
                child: pet.photos!.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(pet.photos!.first.url!),
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(pet.petTypeCode == "DOG"
                            ? 'lib/assets/dog.png'
                            : 'lib/assets/black-cat.png'),
                      )
                // borderRadius: BorderRadius.circular(35),),
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                Text(pet.breedName ?? "Pet breed is here",
                    style: TextStyle(color: lightFontColor, fontSize: 13)),
              ],
            )
          ]),
        ]),
      ),
    );
  }
}
