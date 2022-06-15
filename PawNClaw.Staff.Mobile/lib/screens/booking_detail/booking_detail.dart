import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';

import 'components/booking_cage_card.dart';
import 'components/booking_item_card.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({required this.bookingId, Key? key})
      : super(key: key);

  final int bookingId;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingDetail? booking;
  List<Pet> pets = [];

  @override
  void initState() {
    // TODO: implement initState

    BookingRepository()
        .getBookingDetail(bookingId: widget.bookingId)
        .then((value) {
      value.bookingDetails!.forEach(
        (element) => element.petBookingDetails!.forEach((element) {
          pets.add(element.pet!);
        }),
      );
      setState(
        () {
          booking = value;
          pets = pets;
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return booking != null
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                "Thông tin đơn hàng",
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
                                booking!.customer!.name ?? "",
                                style: TextStyle(
                                  fontSize: width * largeFontRate,
                                  fontWeight: FontWeight.w500,
                                  color: primaryFontColor,
                                ),
                              ),
                              RichText(
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
                                      text: booking!
                                              .customer!.idNavigation!.phone ??
                                          "",
                                      style: TextStyle(
                                        color: lightFontColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: width * smallFontRate,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(width * mediumPadRate),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THÔNG TIN CHUỒNG",
                          style: TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: width * regularFontRate,
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: booking!.bookingDetails!.length,
                            itemBuilder: (context, index) {
                              return BookingCageCard(
                                booking: booking!,
                                request: booking!.bookingDetails![index],
                              );
                            }),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     physics: ClampingScrollPhysics(),
                        //     itemCount: pets.length,
                        //     itemBuilder: (context, index) {
                        //       return BookingItemCard(
                        //         booking: state.booking,
                        //         pet: pets[index],
                        //         center: center,
                        //       );
                        //     }),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(width * mediumPadRate),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THÚ CƯNG",
                          style: TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: width * regularFontRate,
                          ),
                        ),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     physics: ClampingScrollPhysics(),
                        //     itemCount: state.requests!.length,
                        //     itemBuilder: (context, index) {
                        //       return BookingCageCard(
                        //         booking: state.booking,
                        //         request: state.requests![index],
                        //         center: center,
                        //       );
                        //     }),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              return BookingItemCard(
                                booking: booking!,
                                pet: pets[index],
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () =>
                  FirebaseUpload().pickFile("booking/${booking!.id}"),
              label: Text("Update acivity"),
              icon: Icon(Icons.add),
            ),
          )
        : LoadingIndicator(loadingText: "Vui lòng chờ...");
  }
}
