import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/activity_request_model.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/activity/activity_repository.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/booking_activity.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/components/pet_card.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/home_screen.dart';

class ActivityDetail extends StatefulWidget {
  const ActivityDetail(
      {required this.pet, this.service, this.supply, this.cage, Key? key})
      : super(key: key);

  final SupplyOrders? supply;
  final ServiceOrders? service;
  final BookingDetails? cage;
  final Pet pet;

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  String? imageUrl;

  int getActivityId(
      SupplyOrders? supply, ServiceOrders? service, BookingDetails? cage) {
    int result;
    if (supply != null) {
      BookingDetail booking =
          (BlocProvider.of<BookingBloc>(context).state as BookingLoaded)
              .bookings
              .firstWhere((element) => element.id == supply.bookingId);
      result = booking.bookingActivities!
          .firstWhere((element) =>
              element.supplyId == supply.supply!.id &&
              element.provideTime == null)
          .id!;
    } else if (service != null) {
      BookingDetail booking =
          (BlocProvider.of<BookingBloc>(context).state as BookingLoaded)
              .bookings
              .firstWhere((element) => element.id == service.bookingId);
      result = booking.bookingActivities!
          .firstWhere((element) =>
              element.serviceId == service.service!.id &&
              element.provideTime == null)
          .id!;
    } else {
      BookingDetail booking =
          (BlocProvider.of<BookingBloc>(context).state as BookingLoaded)
              .bookings
              .firstWhere((element) => element.id == cage!.bookingId);
      result = booking.bookingActivities!
          .firstWhere((element) =>
              element.bookingDetailId == cage!.id &&
              element.provideTime == null)
          .id!;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var supply = widget.supply;
    var service = widget.service;
    var cage = widget.cage;
    var pet = widget.pet;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "C???p nh???t ho???t ?????ng",
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
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Text(
                "Th?? c??ng",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: lightFontColor,
                ),
              ),
            ),
            PetCard(pet: widget.pet),
            (widget.cage == null)
                ? Padding(
                    padding: EdgeInsets.all(width * smallPadRate),
                    child: Text(
                      "${widget.supply != null ? "????? d??ng" : "D???ch v???"}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: lightFontColor,
                      ),
                    ),
                  )
                : Container(),
            (widget.cage == null)
                ? Container(
                    margin: EdgeInsets.only(
                      right: width * smallPadRate,
                      left: width * smallPadRate,
                    ),
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
                            "${widget.supply?.supply?.name ?? widget.service?.service?.description}",
                            style: TextStyle(
                                color: primaryFontColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "${widget.supply?.note ?? widget.service?.note ?? "kh??ng c?? ch?? th??ch"}",
                            style: TextStyle(
                                color: lightFontColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ]),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(width * smallPadRate),
              child: Text(
                "B???ng ch???ng",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: lightFontColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    var resultUrl = await FirebaseUpload().pickFile(
                        "booking/${supply != null ? supply.bookingId : service!.bookingId}",
                        true);
                    setState(() {
                      imageUrl = resultUrl;
                    });
                  },
                  child: Container(
                    height: height * 0.18,
                    width: height * 0.18,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: width * 0.05),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: width * 0.15,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            "M??? m??y ???nh",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: width * regularFontRate,
                              color: lightFontColor,
                            ),
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var resultUrl = await FirebaseUpload().pickFile(
                        "booking/${supply != null ? supply.bookingId : service != null ? service.bookingId : widget.cage?.id}",
                        false);
                    setState(() {
                      imageUrl = resultUrl;
                    });
                  },
                  child: Container(
                    height: height * 0.18,
                    width: height * 0.18,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: width * 0.05),
                            child: Icon(
                              Icons.file_upload_outlined,
                              size: width * 0.15,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            "T???i ???nh l??n",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: width * regularFontRate,
                              color: lightFontColor,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(width * mediumPadRate),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      imageUrl == null
                          ? "*T???i ???nh l??n tr?????c khi g???i b???ng ch???ng"
                          : "???nh ???? ???????c t???i l??n!",
                      style: TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: imageUrl == null ? 0.5 : 1,
                    child: ElevatedButton(
                      onPressed: imageUrl != null
                          ? () async {
                              ActivityRequestModel activity =
                                  ActivityRequestModel(
                                id: getActivityId(supply, service, cage),
                                description: widget.cage == null
                                    ? "Cung c???p ${supply?.supply?.name ?? service?.service?.description}"
                                    : "Cho ??n",
                                provideTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(DateTime.now()),
                                createPhotoParameter: CreatePhotoParameter(
                                  photoTypeId: 11,
                                  url: imageUrl,
                                ),
                              );
                              String? result = await ActivityRepository()
                                  .updateActivity(activity);
                              print(result);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                            }
                          : () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: width * extraSmallPadRate,
                          horizontal: width * regularPadRate,
                        ),
                        child: Text(
                          "G???i b???ng ch???ng",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
