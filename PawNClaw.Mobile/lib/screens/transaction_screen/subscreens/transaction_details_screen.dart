import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pawnclaw_mobile_application/blocs/transaction/transaction_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/booking.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/booking_cage_card.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/booking_info_card.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/subscreens/activity_list_screen.dart';

import '../components/booking_item_card.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Booking booking;

  const TransactionDetailsScreen({required this.booking, Key? key})
      : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  int currentstatus = 0;
  int maxStep = 3;
  List<String> STATUSLIST = [
    'Đặt lịch thành công',
    'Đang tiến hành',
    'Hoàn thành',
    'Hủy'
  ];
  List<String> STATUSDESCRIPTIONS = [
    'Hãy đến trung tâm đúng giờ bạn nhé.',
    'Trung tâm đang chăm sóc thú cưng.',
    'Hãy để lại đánh giá cho trung tâm nhé!',
    'Đơn hàng đã bị Hủy'
  ];

  double lineLength = 50;

  int modifiedStatus(Booking booking) {
    int status = booking.statusId!;
    print(booking.checkIn);
    print('status $status');
    if (status == 1) return --status;
    if (status == 2) if (booking.checkIn == null)
      return 0;
    else
      return --status;
    return status;
  }

  @override
  Widget build(BuildContext context) {
    // TransactionDetails details = widget.details;
    var booking = widget.booking;
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    int statusId = booking.statusId! - 1; //modifiedStatus(booking);

    return BlocProvider(
        create: (context) =>
            TransactionBloc()..add(GetTransactionDetails(booking.id!)),
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          return state is TransactionDetailsLoaded
              ? Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            booking.status == 3
                                ? booking.rating != null
                                    ? "Đã đánh giá"
                                    : "Đánh giá"
                                : '',
                            style: TextStyle(
                                color: booking.rating != null
                                    ? lightFontColor
                                    : primaryColor),
                          ))
                    ],
                  ),
                  body: SingleChildScrollView(
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * smallPadRate),
                          height: height * 0.10,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //   bottomLeft: Radius.circular(25),
                            //   bottomRight: Radius.circular(25),
                            // ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: height * 0.04,
                                backgroundColor: lightPrimaryColor,
                                backgroundImage:
                                    AssetImage('lib/assets/vet-ava.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * smallPadRate),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: width * regularFontRate,
                                      child: Text(
                                        widget.booking.center!.name!,
                                        style: TextStyle(
                                            fontSize: width * regularFontRate,
                                            fontWeight: FontWeight.w500,
                                            color: primaryFontColor,
                                            height: 1),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.location_on_rounded,
                                              size: width * regularFontRate,
                                              color: primaryColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.booking.center!
                                                .shortAddress(),
                                            style: TextStyle(
                                              color: lightFontColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * smallFontRate,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: primaryColor),
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                    ),
                                                    padding: EdgeInsets.all(20),
                                                    width: width * 0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      disableColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            booking
                                                                .center!.phone!,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 10,
                                                        // ),

                                                        Container(
                                                          //padding: EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      primaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              final data =
                                                                  ClipboardData(
                                                                      text: booking
                                                                          .center!
                                                                          .phone!);
                                                              Clipboard.setData(
                                                                  data);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              final getdata =
                                                                  await Clipboard
                                                                      .getData(
                                                                          'text/plain');
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(SnackBar(
                                                                      content: Text('Đã sao chép: ' +
                                                                          getdata!
                                                                              .text
                                                                              .toString())));
                                                            },
                                                            icon: Icon(Iconsax
                                                                .document_copy),
                                                            color: primaryColor,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                      },
                                      icon: Icon(
                                        Iconsax.call5,
                                        color: Colors.white,
                                        size: 18,
                                      ))),
                            ],
                          ),
                        ),
                        BookingInfoCard(
                          booking: booking,
                          details: state.transactionDetails,
                        ),
                        Container(
                            height: width * (1 - regularPadRate),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                        EdgeInsets.only(top: lineLength - 20),
                                    child: IconStepper(
                                      icons: buildIcon(statusId),
                                      // onStepReached: (index) => setState(() {
                                      //   currentstatus = index;
                                      // }),
                                      activeStep: statusId, // - 1,
                                      direction: Axis.vertical,
                                      lineLength: lineLength,
                                      scrollingDisabled: true,
                                      alignment: Alignment.topLeft,
                                      stepPadding: 0,
                                      stepRadius: 18,
                                      activeStepBorderPadding: 0,
                                      lineColor: lightFontColor,
                                      enableNextPreviousButtons: false,
                                      activeStepColor: primaryBackgroundColor,
                                      stepColor: Colors.white,
                                      activeStepBorderColor: Colors.white,
                                      lineDotRadius: 0.7,
                                      stepReachedAnimationEffect: Curves.easeIn,
                                    )),
                                buildStatusCard(statusId, width,
                                    state.transactionDetails, booking),
                                //     Stepper(
                                //       onStepTapped: (value) => setState(() {
                                //         currentstatus = value;
                                //       }),

                                //       currentStep: currentstatus,
                                //   steps: [
                                //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus >= 0)? StepState.complete:StepState.indexed, isActive: (currentstatus >= 0)?true:false),
                                //     Step(title: Text(''), content: Text('Đặt lich thành công'),state:(currentstatus > 0)? StepState.complete:StepState.indexed, isActive: (currentstatus > 0)?true:false),
                                //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus > 1)? StepState.complete:StepState.indexed, isActive: (currentstatus > 1)?true:false),
                                //     Step(title: Text(''), content: Text('Đặt lich thành công'),state: (currentstatus > 2)? StepState.complete:StepState.indexed, isActive: (currentstatus > 2)?true:false)
                                //   ],
                                // )
                              ],
                            )),
                        buildSeperator(size),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: height * extraSmallPadRate),
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
                                ListView.separated(
                                  itemBuilder: (context, index) =>
                                      BookingCageCard(
                                          booking: booking,
                                          bookingDetails: state
                                              .transactionDetails
                                              .bookingDetails![index],
                                          center: booking.center!),
                                  itemCount: state.transactionDetails
                                      .bookingDetails!.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    height: 8,
                                  ),
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                )
                              ]),
                        ),
                        buildPetCards(state, size, booking),
                        buildSeperator(size)
                      ])))
              : Center(
                  child: LoadingIndicator(loadingText: 'Vui lòng đợi'),
                );
        }));
  }

  Widget buildPetCards(
      TransactionDetailsLoaded state, Size size, Booking booking) {
    double height = size.height;
    double width = size.width;
    List<Pet> pets = state.transactionDetails.getPets();
    bool ifAnyPetHaveItems = false;
    for (var pet in pets) {
      if (state.transactionDetails.haveItems(pet)) {
        ifAnyPetHaveItems = true;
        break;
      }
    }
    return (ifAnyPetHaveItems)
        ? Column(
            children: [
              buildSeperator(size),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: height * extraSmallPadRate),
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
                      ListView.separated(
                        itemBuilder: (context, index) {
                          Pet pet = state.transactionDetails.getPets()[index];
                          if (state.transactionDetails.haveItems(pet))
                            return BookingItemCard(
                                booking: booking,
                                pet: pet,
                                details: state.transactionDetails);
                          return Container();
                        },
                        itemCount: state.transactionDetails.getPets().length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 8,
                        ),
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                      )
                    ]),
              ),
            ],
          )
        : Container();
  }

  List<Icon> buildIcon(int activeIndex) {
    List<Icon> iconList = [];
    for (var i = 0; i < maxStep; i++) {
      if (activeIndex < 3) {
        if (i == activeIndex)
          iconList.add(Icon(
            Icons.check_circle,
            color: primaryColor,
          ));
        else if (i < activeIndex)
          iconList.add(Icon(
            Icons.circle,
            color: primaryColor,
          ));
        else
          iconList.add(Icon(Icons.circle, color: lightFontColor));
      } else
        iconList.add(Icon(Icons.circle, color: lightFontColor));
    }
    return iconList;
  }

  Widget buildStatusCard(int activeIndex, double width,
      TransactionDetails transaction, Booking booking) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (activeIndex > 0 && activeIndex < 3)
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildPreStatusCard(0, activeIndex, width)),
      Container(
        padding: EdgeInsets.only(top: 10),
        //margin: EdgeInsets.only(top: lineLength),
        child: Container(
            height: width / 3.3,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: frameColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(STATUSLIST[activeIndex],
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: width * (1 - mediumPadRate * 3 - regularPadRate),
                    child: Text(STATUSDESCRIPTIONS[activeIndex],
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: lightFontColor,
                            fontSize: 13))),
                SizedBox(
                  height: 7,
                ),
                Container(
                    width: width * (1 - mediumPadRate * 3 - regularPadRate),
                    height: width * (1 / 3.5 / 3 - extraSmallPadRate),
                    child: Row(
                      children: [
                        Expanded(child: SizedBox()),
                        if (activeIndex > 0)
                          ElevatedButton(
                              onPressed: () {
                                // print(transaction.bookingActivities);
                                // print(booking);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ActivityListScreen(
                                          transaction: transaction,
                                          booking: booking,
                                        )));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Text(
                                'Xem hoạt động',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ))
                        else
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Text(
                                'Liên hệ trung tâm',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ))
                      ],
                    ))
              ],
            )),
      ),
      if (activeIndex >= 0 && activeIndex < 3)
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildPreStatusCard(activeIndex + 1, 3, width)),
    ]);
  }

  List<Widget> buildPreStatusCard(int fromIndex, int toIndex, double width) {
    List<Widget> list = [];
    for (var i = fromIndex; i < toIndex; i++) {
      double top = lineLength - 5/2;
      double bottom =  lineLength - 20 - width * extraSmallPadRate;
      // if (i == toIndex - 1) {
      //   bottom = top;
      // }
      if (i == fromIndex && i > 0) {
        top = bottom;
      }
      list.add(Container(
        width: width * (1 - mediumPadRate * 3 - regularPadRate),
        padding: EdgeInsets.only(
            top: top,
            bottom: bottom),
        //margin: EdgeInsets.only(bottom:(lineLength*currentstatus)/2 - 18 - width*smallPadRate),
        child: Text(STATUSLIST[i],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: lightFontColor,
                fontSize: 13)),
      ));
    }
    return list;
  }

  Widget buildSeperator(Size size) {
    return Column(
      children: [
        Container(
          color: frameColor,
          height: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: size.height * extraSmallPadRate,
          color: frameColor,
        ),
        Container(
          color: frameColor,
          height: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
