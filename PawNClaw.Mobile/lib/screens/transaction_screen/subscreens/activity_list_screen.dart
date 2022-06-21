import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/transaction/transaction_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/transaction_details.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/activity_card.dart';

import '../../../models/activity.dart';
import '../../../models/booking.dart';

class ActivityListScreen extends StatefulWidget {
  final TransactionDetails transaction;
  final Booking booking;
  const ActivityListScreen(
      {required this.transaction, required this.booking, Key? key})
      : super(key: key);

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  int currentSelected = 1;
  int activeIndex = 0;
  var ACTIVITYLIST = ['Cho ăn', 'Đồ Dùng', 'Dịch vụ'];
  int feedCountADay = 3;
  List<Activity> CURRENT_ACTS = [];
  var transaction;

  @override
  void initState() {
    // BlocProvider(
    // create: (context) => TransactionBloc()..add(GetTransactionDetails(widget.booking.id!)),
    // child: BlocBuilder<TransactionBloc, TransactionState>(
    //               builder: (context, state) {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //var transaction = widget.transaction;
    var booking = widget.booking;
    double height = size.height;
    double width = size.width;
    int filterCount = 0;

    List<Activity> ALL_ACTIVITIES = [];

    //LOAD ALL FEED ACTIVITY
    // for (var bookedCage in transaction.bookingDetails!) {
    //   for (var pet in bookedCage.getPets()) {
    //     for (var i = 0; i < feedCountADay * (bookedCage.duration! / 24); i++) {
    //       FEED_ACTS.add(Activity(
    //           id: i,
    //           time: booking.startBooking!.add(new Duration(
    //               hours: (i * 24 / feedCountADay - i * 3).toInt())),
    //           type: ActivityType(0),
    //           product: Product(
    //               id: 0,
    //               name: bookedCage.cage!.cageType!.typeName!,
    //               imgUrl: "lib/assets/cage.png",
    //               note: 'Cho ${pet.name} ăn'),
    //           pet: pet));
    //     }
    //   }
    // }
    // for (var act in transaction.bookingActivities!) {
    //   if (act.line != null) {
    //     for (var pet in transaction.getPets()) {
    //       if (pet.id == act.petId) {
    //         FEED_ACTS.add(Activity(
    //             id: 0,
    //             time: DateTime.parse(act.provideTime!),
    //             type: ActivityType(0),
    //             product: Product(
    //                 id: 0,
    //                 name: transaction.bookingDetails!
    //                     .where((e) => e.line == act.line)
    //                     .first
    //                     .cage!
    //                     .cageType!
    //                     .typeName!,
    //                 imgUrl: "lib/assets/cage.png",
    //                 note: act.description != null
    //                     ? act.description!
    //                     : 'Cho ${pet.name} ăn'),
    //             pet: pet, imgUrl:  act.photo!.isNotEmpty ? act.photo!.first.url:null));
    //       }
    //     }
    //   }
    // }

    //LOAD ALL SUPPLY ACTIVITY
    // if (haveSupply) {
    //   for (var pet in transaction.getPets()) {
    //     if (transaction.haveItems(pet)) {
    //       for (var order in transaction.supplyOrders!) {
    //         if (order.petId == pet.id) {
    //           SUPPLY_ACTS.add(Activity(
    //               id: 0,
    //               time: booking.startBooking!.add(new Duration(hours: 2)),
    //               product: Product(
    //                   id: 0,
    //                   name: order.supply!.name!,
    //                   imgUrl: "lib/assets/cage.png",
    //                   note: order.note != null
    //                       ? order.note!
    //                       : 'Ghi chú của khách hàng'),
    //               pet: pet));
    //         }
    //       }
    //     }
    //   }
    // }
    // for (var act in transaction.bookingActivities!) {
    //   if (act.supplyId != null) {
    //     for (var pet in transaction.getPets()) {
    //       if (pet.id == act.petId) {
    //         SUPPLY_ACTS.add(Activity(
    //             id: 0,
    //             time: DateTime.parse(act.provideTime!),
    //             type: ActivityType(1),
    //             product: Product(
    //                 id: 0,
    //                 name: transaction.supplyOrders!
    //                     .where((e) => e.supplyId == act.supplyId)
    //                     .first
    //                     .supply!
    //                     .name!,
    //                 imgUrl: "lib/assets/cage.png",
    //                 note: act.description != null
    //                     ? act.description!
    //                     : 'Không có chú thích'),
    //             pet: pet,imgUrl: act.photo!.isNotEmpty ? act.photo!.first.url:null));
    //       }
    //     }
    //   }
    // }

    //LOAD ALL SERVICE ACTIVITY
    // if (haveSupply) {
    //   for (var pet in transaction.getPets()) {
    //     if (transaction.haveItems(pet)) {
    //       for (var order in transaction.serviceOrders!) {
    //         if (order.petId == pet.id) {
    //           SERVICE_ACTS.add(Activity(
    //               id: 0,
    //               time: booking.startBooking!.add(new Duration(hours: 2)),
    //               product: Product(
    //                   id: 0,
    //                   name: order.service!.description!,
    //                   imgUrl: "lib/assets/cage.png",
    //                   note: order.note != null
    //                       ? order.note!
    //                       : 'Ghi chú của khách hàng'),
    //               pet: pet));
    //         }
    //       }
    //     }
    //   }
    // }
    // for (var act in transaction.bookingActivities!) {
    //   if (act.serviceId != null) {
    //     for (var pet in transaction.getPets()) {
    //       if (pet.id == act.petId) {
    //         SERVICE_ACTS.add(Activity(
    //             id: 0,
    //             time: DateTime.parse(act.provideTime!),
    //             type: ActivityType(2),
    //             product: Product(
    //                 id: 0,
    //                 name: transaction.serviceOrders!
    //                     .where((e) => e.serviceId == act.serviceId)
    //                     .first
    //                     .service!
    //                     .description!,
    //                 imgUrl: "lib/assets/cage.png",
    //                 note: act.description != null
    //                     ? act.description!
    //                     : 'Không có chú thích'),
    //             pet: pet,imgUrl:  act.photo!.isNotEmpty ? act.photo!.first.url:null));
    //       }
    //     }
    //   }
    // }

    //sort

    return BlocProvider(
        create: (context) =>
            TransactionBloc()..add(GetTransactionDetails(widget.booking.id!)),
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {

          // CURRENT_ACTS = ALL_ACTIVITIES;
          // for (var e in ALL_ACTIVITIES) {
          //   print(e);
          // }

          // if (haveFeed) {
          //   filterCount++;
          // }
          // if (haveSupply) {
          //   filterCount++;
          // }
          // if (haveService) {
          //   filterCount++;
          // }

          return state is TransactionDetailsLoaded
              ? RefreshIndicator(
                  onRefresh: () async => context
                      .read<TransactionBloc>()
                      .add(GetTransactionDetails(widget.booking.id!)),
                  child: Scaffold(
                    backgroundColor: frameColor,
                    appBar: AppBar(
                      title: Text('Hoạt động',
                          style: TextStyle(color: Colors.black)),
                      elevation: 0,
                      backgroundColor: frameColor,
                      leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    body:
                        // bottom: PreferredSize(
                        // child:
                        SingleChildScrollView(
                      child: Column(
                        children: [
                          // Container(
                          //   height:width * mediumPadRate * 2 ,
                          //   width: width,
                          //   child:  SingleChildScrollView(
                          //     child: Row(
                          //       children: [
                          //         buildSumFilterCard(currentSelected),
                          //         if (haveFeed) buildFilterCard(activeIndex==1, 0, FEED_ACTS),
                          //         if (haveSupply) buildFilterCard(activeIndex==2,1, SUPPLY_ACTS),
                          //         if (haveService) buildFilterCard(activeIndex==3, 2, SERVICE_ACTS)
                          // ListView.builder(
                          //   itemBuilder: (context, index) {
                          //     if (filterCount > 1) {
                          //       if (haveSupply && index < 2) {
                          //         return buildFilterCard(false, ACTIVITYLIST[1]);
                          //       } else if (haveService) {
                          //         return buildFilterCard(false, ACTIVITYLIST[2]);
                          //       }
                          //     }
                          //     return buildFilterCard(false, ACTIVITYLIST[0]);
                          //   },
                          //   itemCount: filterCount,
                          //   shrinkWrap: true,
                          //   physics: ClampingScrollPhysics(),
                          // )
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          //cage
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * mediumPadRate),
                            child: ListView.separated(
                              itemBuilder: ((context, index) {
                                return ActivityCard(
                                    activity: state.transactionDetails
                                        .getAllActivities()[index]);
                              }),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: width * smallPadRate),
                              itemCount: state.transactionDetails
                                  .getAllActivities()
                                  .length, // *
                              // feedCountADay,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                            ),
                          ),
                          //SUPPLY
                          // (haveSupply) ? Padding(
                          //   padding:  EdgeInsets.symmetric(horizontal: width*mediumPadRate, vertical: width*smallPadRate),
                          //   child: ListView.separated(
                          //       itemBuilder: ((context, index) {
                          //         return ActivityCard(
                          //             activity: Activity(
                          //           id: 0,
                          //           time: DateTime.now(),
                          //           type: ActivityType(0),
                          //           pet: transaction
                          //                   .supplyOrders![index].getPets(),
                          //           product: Product(
                          //               id: 0,
                          //               name: transaction
                          //                   .supplyOrders![index].supply!.name!,
                          //               imgUrl: 'lib/assets/cage.png',
                          //               note: transaction.supplyOrders![index].note != null ?transaction.supplyOrders![index].note!:
                          //                   'ghi chú của khách hàng '),
                          //         ));
                          //       }),
                          //       separatorBuilder: (context, index) =>
                          //           const SizedBox(height: 10),
                          //       itemCount: transaction.supplyOrders!.length,// *
                          //          // feedCountADay,
                          //           shrinkWrap: true,
                          //           physics: ClampingScrollPhysics(),),
                          // ):Container(),
                          //SERVICE
                          // (haveService) ? Padding(
                          //   padding:  EdgeInsets.symmetric(horizontal: width*mediumPadRate, vertical: width*smallPadRate),
                          //   child: ListView.separated(
                          //       itemBuilder: ((context, index) {
                          //         return ActivityCard(
                          //             activity: Activity(
                          //           id: 0,
                          //           time: DateTime.now(),
                          //           type: ActivityType(0),
                          //           pet: transaction.bookingDetails!.first.getPets()[index],
                          //           product: Product(
                          //               id: 0,
                          //               name: transaction
                          //                   .supplyOrders![index].supply!.name!,
                          //               imgUrl: 'lib/assets/cage.png',
                          //               note: transaction.serviceOrders![index].note != null ?transaction.serviceOrders![index].note!:
                          //                   'ghi chú của khách hàng '),
                          //         ));
                          //       }),
                          //       separatorBuilder: (context, index) =>
                          //           const SizedBox(height: 10),
                          //       itemCount: transaction.serviceOrders!.length,// *
                          //          // feedCountADay,
                          //           shrinkWrap: true,
                          //           physics: ClampingScrollPhysics(),),
                          // ):Container()
                        ],
                      ),
                    ),
                    // preferredSize: Size(width/3*filterCount, width * mediumPadRate * 2)),
                    // ),
                  ))
              : LoadingIndicator(loadingText: 'Chưa có hoạt động nào');
        }));
  }

  Widget buildSumFilterCard(int currentSelected) {
    return (currentSelected != 0)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Icon(
                Icons.tune_rounded,
                color: primaryColor,
              ),
              Text(
                currentSelected.toString(),
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              )
            ]),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: lightFontColor),
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Icon(
                Icons.tune_rounded,
                color: Colors.black,
              )
            ]));
  }

  Widget buildFilterCard(bool isActive, int index, List<Activity> children) {
    return (isActive)
        ? GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
                // children.forEach((e) { CURRENT_ACTS.remove(e);});
              });
            },
            child: Container(
              height: 35,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(children: [
                Text(
                  ACTIVITYLIST[index].toString(),
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                )
              ]),
            ))
        : GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = index + 1;
                // CURRENT_ACTS = [];
                // CURRENT_ACTS.addAll(children);
                // print(CURRENT_ACTS.length);
              });
            },
            child: Container(
                height: 35,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: lightFontColor),
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                    child: Text(
                  ACTIVITYLIST[index].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ))));
  }
}
