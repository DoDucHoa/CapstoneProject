import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking_create_model.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/booking.dart/booking_repository.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/components/booking_item_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/booking_success_screen.dart';

import 'components/booking_cage_card.dart';

class ConfirmBooking extends StatefulWidget {
  ConfirmBooking({required this.center, Key? key}) : super(key: key);

  final petCenter.Center center;
  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    petCenter.Center center = widget.center;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingUpdated) {
          List<Pet> pets = [];
          state.requests!.forEach(
            (element) => element.forEach((pet) {
              pets.add(pet);
            }),
          );
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                "Đặt lịch",
                style: TextStyle(
                  fontSize: width * largeFontRate,
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
                          backgroundImage: AssetImage('lib/assets/center0.jpg'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * smallPadRate),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                center.name ?? "",
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
                                        Icons.location_on,
                                        size: width * regularFontRate,
                                        color: primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: center.address ?? "",
                                      style: TextStyle(
                                        color: primaryColor,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: width * smallPadRate),
                    margin: EdgeInsets.symmetric(
                      horizontal: width * mediumPadRate,
                      vertical: width * smallPadRate,
                    ),
                    width: width,
                    height: height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THỜI GIAN",
                          style: TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: width * regularFontRate,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(width * smallPadRate * 0.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "CHECK IN",
                                    style: TextStyle(
                                      color: lightFontColor,
                                    ),
                                  ),
                                  Text(
                                    state.booking.bookingCreateParameter!
                                        .startBooking!,
                                    style: TextStyle(
                                      color: primaryFontColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * smallFontRate,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: 1.5,
                                height: height * 0.04,
                                color: lightFontColor,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "CHECK OUT",
                                    style: TextStyle(
                                      color: lightFontColor,
                                    ),
                                  ),
                                  Text(
                                    state.booking.bookingCreateParameter!
                                        .endBooking!,
                                    style: TextStyle(
                                      color: primaryFontColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * smallFontRate,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
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
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: state.requests!.length,
                            itemBuilder: (context, index) {
                              return BookingCageCard(
                                booking: state.booking,
                                request: state.requests![index],
                                center: center,
                              );
                            }),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              return BookingItemCard(
                                booking: state.booking,
                                pet: pets[index],
                                center: center,
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * smallPadRate,
                      vertical: width * smallPadRate * 0.5,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: width * mediumPadRate,
                      vertical: width * smallPadRate,
                    ),
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: primaryColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * smallPadRate),
                          child: Text(
                            "Áp dụng ưu đãi",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * smallPadRate,
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: width * mediumPadRate),
                    width: width,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "THÔNG TIN HÓA ĐƠN",
                          style: TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: width * regularFontRate,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dịch vụ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                    decimalDigits: 0,
                                    symbol: '',
                                  ).format(state.booking.getTotalService()) +
                                  "đ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Đồ dùng",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                    decimalDigits: 0,
                                    symbol: '',
                                  ).format(state.booking.getTotalSupply()) +
                                  "đ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chi phí khách sạn x " +
                                  state.booking.bookingDetailCreateParameters!
                                      .first.duration!
                                      .toStringAsFixed(0) +
                                  " giờ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                    decimalDigits: 0,
                                    symbol: '',
                                  ).format(state.booking.getTotalCage()) +
                                  "đ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Giảm giá",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            ),
                            Text(
                              "-0 đ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: width,
                          height: 1.5,
                          color: Colors.black12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tổng tiền",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontSize: width * regularFontRate * 0.8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                    decimalDigits: 0,
                                    symbol: '',
                                  ).format(state.booking.getTotal()) +
                                  "đ",
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w800,
                                fontSize: width * regularFontRate * 0.8,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * mediumPadRate,
                      vertical: width * smallPadRate,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        var state = BlocProvider.of<BookingBloc>(context).state;
                        BookingRequestModel request =
                            (state as BookingUpdated).booking;
                        var result =
                            await BookingRepository().createBooking(request);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookingSuccess()));
                        //booking button
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "ĐẶT LỊCH",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}