import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pncstaff_mobile_application/blocs/activity/activity_bloc.dart';
import 'package:pncstaff_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pncstaff_mobile_application/common/components/loading_indicator.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';
import 'package:pncstaff_mobile_application/common/services/upload_service.dart';
import 'package:pncstaff_mobile_application/models/booking_detail.dart';
import 'package:pncstaff_mobile_application/models/pet.dart';
import 'package:pncstaff_mobile_application/repositories/booking/booking_repository.dart';
import 'package:intl/intl.dart';
import 'package:pncstaff_mobile_application/screens/activity_screen/subscreens/supply_activity.dart';
import 'package:pncstaff_mobile_application/screens/home_screen/subscreens/booking_cage.dart';

import 'subscreens/service_activity.dart';

class BookingActivityScreen extends StatefulWidget {
  const BookingActivityScreen({required this.booking, Key? key})
      : super(key: key);

  final BookingDetail? booking;

  @override
  State<BookingActivityScreen> createState() => _BookingActivityScreenState();
}

class _BookingActivityScreenState extends State<BookingActivityScreen> {
  List<Pet> pets = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var booking = widget.booking;
    return booking != null
        ? BlocProvider(
            create: (context) =>
                ActivityBloc()..add(InitActivity(booking: booking)),
            child: BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: Colors.white,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: width * mediumPadRate),
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
                              (booking.customer!.idNavigation!.photo == null)
                                  ? CircleAvatar(
                                      radius: height * 0.04,
                                      backgroundColor: primaryBackgroundColor,
                                      backgroundImage:
                                          AssetImage('lib/assets/cus0.png'),
                                    )
                                  : CircleAvatar(
                                      radius: height * 0.04,
                                      backgroundColor: frameColor,
                                      backgroundImage: NetworkImage(
                                        booking.customer!.idNavigation!.photo!
                                            .url!,
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.all(width * smallPadRate),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            text: booking.customer!
                                                .idNavigation!.phone!));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: width * mediumPadRate),
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
                                    DateFormat('HH:mm, dd/MM/yyyy')
                                        .format(booking.startBooking!),
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
                                    DateFormat('HH:mm, dd/MM/yyyy')
                                        .format(booking.endBooking!),
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
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: CircularPercentIndicator(
                            radius: height * 0.15,
                            percent: booking.getDoneActivites() /
                                booking.getTotalActivities(),
                            lineWidth: 18,
                            fillColor: Colors.white,
                            progressColor: primaryColor,
                            backgroundColor: Colors.white,
                            animation: true,
                            animationDuration: 2000,
                            curve: Curves.linear,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: (booking.getDoneActivites() /
                                            booking.getTotalActivities() *
                                            100)
                                        .toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: height * 0.075,
                                        color: primaryFontColor),
                                  ),
                                  TextSpan(
                                    text: "%",
                                    style: TextStyle(
                                      color: primaryFontColor,
                                      fontSize: height * 0.05,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        (booking.getTotalActivities() >
                                booking.getDoneActivites())
                            ? InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => showCupertinoDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      width: width * 0.7,
                                      padding:
                                          EdgeInsets.all(width * smallPadRate),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.all(width * 0.03),
                                            child: Text(
                                              "Nhiệm vụ còn lại",
                                              style: TextStyle(
                                                fontSize:
                                                    width * regularFontRate,
                                                fontWeight: FontWeight.bold,
                                                color: primaryFontColor,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              (booking
                                                          .getUndoneSupplyAct()
                                                          .length >
                                                      0)
                                                  ? Container(
                                                      width: width * 0.7,
                                                      padding: EdgeInsets.all(
                                                          width * 0.03),
                                                      margin: EdgeInsets.only(
                                                          top: width * 0.03),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Text(
                                                        "Cung cấp ${booking.getUndoneSupplyAct().length} vật dụng để hoàn thành",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              (booking
                                                          .getUndoneServiceAct()
                                                          .length >
                                                      0)
                                                  ? Container(
                                                      width: width * 0.7,
                                                      padding: EdgeInsets.all(
                                                          width * 0.03),
                                                      margin: EdgeInsets.only(
                                                          top: width * 0.03),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Text(
                                                        "Cung cấp ${booking.getUndoneServiceAct().length} dịch vụ để hoàn thành",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              (booking
                                                          .getUndoneFeedingAct()
                                                          .length >
                                                      0)
                                                  ? Container(
                                                      width: width * 0.7,
                                                      padding: EdgeInsets.all(
                                                          width * 0.03),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  width * 0.03),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Text(
                                                        "Cho ăn ${booking.getUndoneFeedingAct().length} lần để hoàn thành",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            )),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("Đóng"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: width * 0.7,
                                  padding: EdgeInsets.all(width * 0.03),
                                  margin: EdgeInsets.all(width * 0.03),
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Nhiệm vụ đã hoàn thành",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                          "${booking.getDoneActivites()}/${booking.getTotalActivities()}")
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: width * 0.7,
                                padding: EdgeInsets.all(width * 0.03),
                                margin: EdgeInsets.all(width * 0.03),
                                decoration: BoxDecoration(
                                    color: lightPrimaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Đã hoàn thành tất cả nhiệm vụ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: primaryColor),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          padding: EdgeInsets.only(
                              left: width * mediumPadRate,
                              top: width * smallPadRate,
                              bottom: width * mediumPadRate),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: width * smallPadRate,
                                ),
                                child: Text(
                                  "Nhiệm vụ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  (booking.getRemainFeedingAct() > 0)
                                      ? InkWell(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingCageScreen(
                                                          booking: booking,
                                                          bookingDetail: booking
                                                              .bookingDetails!
                                                              .first))),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: width * smallPadRate),
                                            constraints: BoxConstraints(
                                              minHeight: width * 0.35,
                                              minWidth: width * 0.35,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  width * smallPadRate * 0.7),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Icon(
                                                      Icons.fastfood_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                      // size: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    booking
                                                        .getRemainFeedingAct()
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: width * 0.085,
                                                      color: primaryFontColor,
                                                      // height: 1
                                                    ),
                                                  ),
                                                  Text(
                                                    "Cho ăn",
                                                    style: TextStyle(
                                                        color: primaryFontColor,
                                                        fontSize: width * 0.048,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<BookingBloc>(
                                              context),
                                          child:
                                              SupplyActivity(booking: booking)),
                                    )),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: width * smallPadRate),
                                      width: width * 0.3,
                                      height: width * 0.3,
                                      decoration: BoxDecoration(
                                        color: lightPrimaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            width * smallPadRate * 0.7),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.shopping_cart_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              booking
                                                  .getUndoneSupplyAct()
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25,
                                                  color: primaryFontColor),
                                            ),
                                            Text(
                                              "Đồ dùng",
                                              style: TextStyle(
                                                  color: primaryFontColor,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                                value: BlocProvider.of<
                                                    BookingBloc>(context),
                                                child: ServiceActivity(
                                                    booking: booking)))),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: width * smallPadRate),
                                      width: width * 0.3,
                                      height: width * 0.3,
                                      decoration: BoxDecoration(
                                        color: lightPrimaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            width * smallPadRate * 0.7),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.back_hand,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              booking
                                                  .getUndoneServiceAct()
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25,
                                                  color: primaryFontColor),
                                            ),
                                            Text(
                                              "Dịch vụ",
                                              style: TextStyle(
                                                  color: primaryFontColor,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(
                                  //       right: width * smallPadRate),
                                  //   width: width * 0.3,
                                  //   height: width * 0.3,
                                  //   decoration: BoxDecoration(
                                  //     color: lightPrimaryColor,
                                  //     borderRadius: BorderRadius.circular(20),
                                  //   ),
                                  // ),
                                ]),
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
              },
            ),
          )
        : LoadingIndicator(loadingText: "Vui lòng chờ...");
  }
}
