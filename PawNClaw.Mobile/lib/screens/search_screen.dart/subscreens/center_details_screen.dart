import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/booking/booking_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/confirm_booking.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/center_slider.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/item_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/service_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/supplytype_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/service_detail_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/vouchers_screen.dart';

import '../components/catergory_card.dart';
import '../components/review_card.dart';

class CenterDetails extends StatefulWidget {
  const CenterDetails(
      {required this.petCenterId,
      required this.requests,
      required this.bookingDate,
      required this.endDate,
      Key? key})
      : super(key: key);

  final int petCenterId;
  final List<List<Pet>> requests;
  final DateTime bookingDate;
  final DateTime endDate;

  @override
  State<CenterDetails> createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> {
  petCenter.Center? center;
  List<String> supplyType = ["DRINK", "FOOD", "MED", "OTHER"];
  @override
  void initState() {
    // TODO: implement initState
    CenterRepository()
        .getCenterDetail(widget.requests, widget.petCenterId,
            widget.bookingDate, widget.endDate)
        .then((value) {
      setState(() {
        this.center = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double appbarSize = height * 0.5;

    var auth = BlocProvider.of<AuthBloc>(context).state;
    int customerId = (auth as Authenticated).user.id!;
    return BlocProvider(
        create: (context) => BookingBloc()
          ..add(
            InitBooking(
              startBooking: widget.bookingDate,
              endBooking: widget.endDate,
              centerId: widget.petCenterId,
              request: widget.requests,
              customerId: customerId,
            ),
          ),
        child:
            BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
          return (center != null)
              ? Scaffold(
                  backgroundColor: frameColor,
                  body: DefaultTabController(
                      length: 4,
                      child: NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          return [
                            SliverAppBar(
                              // title: const Text(
                              //   'Chi tiết',
                              //   style: TextStyle(fontSize: 16),
                              // ),
                              centerTitle: true,
                              backgroundColor: frameColor,
                              expandedHeight: appbarSize,
                              floating: true,
                              pinned: true,
                              //leading: Icon(Icons.arrow_back),
                              flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  background: Stack(
                                    children: [
                                      //campaign image
                                      Image.asset(
                                        'lib/assets/center0.jpg',
                                        width: width,
                                        fit: BoxFit.cover,
                                      ),
                                      // Image.network(
                                      //   center.![0].picture.toString(),
                                      //   width: width,
                                      //   fit: BoxFit.cover,

                                      ////campaign name

                                      Container(
                                        height: appbarSize - 5,
                                        decoration: const BoxDecoration(
                                          // borderRadius:
                                          //     BorderRadius.only(bottomLeft: Radius.circular(60)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black12,
                                              Colors.black26,
                                              Colors.black38,
                                              Colors.black54,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: appbarSize * 0.45,
                                          left: 0,
                                          right: 0,
                                          height: appbarSize / 2 + 65 / 2 + 10,
                                          child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(50.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0)
                                                    //topRight: const Radius.circular(30.0),
                                                    ),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 65 / 2 - 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: width * 2 / 3,
                                                        child: Text(
                                                          center?.name ?? "",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Icon(
                                                        Icons.star_rate_rounded,
                                                        color:
                                                            lightPrimaryColor,
                                                      ),
                                                      Text(
                                                        center?.rating!
                                                                .toString() ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                        ' (' +
                                                            (center?.rating!
                                                                    .toString() ??
                                                                "") +
                                                            ')',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                lightFontColor),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5,
                                                              bottom: 5),
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  11 * 0.4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            //border: Border.all(width: 1),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            4,
                                                                            3,
                                                                            5,
                                                                            2),
                                                                child:
                                                                    Image.asset(
                                                                  'lib/assets/white-paw.png',
                                                                  width: 13,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Đối tác PawNClaw   ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ]),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  OutlinedButton.icon(
                                                      style: OutlinedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                      onPressed: () => Navigator
                                                              .of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Vouchers())),
                                                      icon: Image.asset(
                                                        'lib/assets/coupon.png',
                                                        width: 30,
                                                      ),
                                                      label: Container(
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  10,
                                                                  15,
                                                                  5,
                                                                  15),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Bạn có 4 ưu đãi',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryFontColor),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      SizedBox()),
                                                              Icon(Icons
                                                                  .keyboard_double_arrow_right),
                                                            ],
                                                          )))
                                                ],
                                              ))),
                                      Positioned(
                                        top: appbarSize * 0.45 - 65 / 2,
                                        left: 20,
                                        child: Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'lib/assets/vet-ava.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.height * 0.1),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  )),
                              actions: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search_rounded)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.info_outline)),
                              ],
                              bottom: TabBar(
                                tabs: [
                                  Tab(
                                    text: 'Facilities',
                                  ),
                                  Tab(
                                    text: 'Supplies',
                                  ),
                                  Tab(
                                    text: 'Services',
                                  ),
                                  Tab(
                                    text: 'Reviews',
                                  ),
                                ],
                                labelColor: primaryColor,
                                unselectedLabelColor: lightFontColor,
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.w700),
                                indicator: LineIndicator(
                                    color: primaryColor, radius: width / 4),
                                splashBorderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                            ),

                            //buildContent(context)
                          ];
                        },
                        body: Container(
                            color: frameColor,
                            width: width,
                            //height: ,
                            child: TabBarView(children: [
                              SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child:
                                              //       Wrap(
                                              // spacing: 12,
                                              // runSpacing: 8,
                                              // children:
                                              ListView.separated(
                                        itemBuilder: (context, index) {
                                          var cageType =
                                              center?.cageTypes?[index];
                                          // return CatergoryCard(
                                          //   cageType: cageTypes[index],
                                          //   size: size,
                                          // );
                                          return CatergoryCard(
                                              cageType: cageType, size: size);
                                        },
                                        itemCount:
                                            center?.cageTypes?.length ?? 0,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 8,
                                        ),
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                      )
                                          //cageTypeList(FAKE_CAGETYPES, context),
                                          ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 10, 10),
                                        child: Text(
                                          'CƠ SỞ VẬT CHẤT',
                                          style: TextStyle(
                                              color: lightFontColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      CenterSlider(size: size),
                                      SizedBox(height: 80)
                                    ],
                                  )),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:
                                            //       Wrap(
                                            // spacing: 12,
                                            // runSpacing: 8,
                                            // children:
                                            ListView.separated(
                                          itemBuilder: (context, index) {
                                            var supplies = center?.supplies;
                                            return SupplyTypeCard(
                                                supplyType: supplyType[index],
                                                size: size,
                                                supplies: supplies ?? []);
                                          },
                                          itemCount: supplyType.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                            height: 8,
                                          ),
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                        ),

                                        //cageTypeList(FAKE_CAGETYPES, context),
                                      ),
                                      SizedBox(
                                        height: width * 0.3,
                                      ),
                                    ]),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  //color: Colors.white,
                                  child:
                                      //       Wrap(
                                      // spacing: 12,
                                      // runSpacing: 8,
                                      // children:
                                      ListView.separated(
                                    itemBuilder: (context, index) {
                                      var service = center?.services?[index];
                                      return ServiceCard(
                                        service:
                                            service ?? new petCenter.Services(),
                                        redirect:
                                            ServiceDetails(service: service!),
                                      );
                                    },
                                    itemCount: center?.services?.length ?? 0,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 8,
                                    ),
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                  ),
                                  //cageTypeList(FAKE_CAGETYPES, context),
                                ),
                              ),
                              SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                      child:
                                          //       Wrap(
                                          // spacing: 12,
                                          // runSpacing: 8,
                                          // children:
                                          ListView.separated(
                                    itemBuilder: (context, index) {
                                      return ReviewCard(
                                          review: FAKE_REVIEWS[index]);
                                    },
                                    itemCount: FAKE_REVIEWS.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 8,
                                    ),
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                  )
                                      //cageTypeList(FAKE_CAGETYPES, context),
                                      )),
                            ])),
                      )),
                  floatingActionButton: Container(
                    padding: EdgeInsets.only(left: 30),
                    child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: ()
                            // => (state as BookingUpdated)
                            //         .booking
                            //         .bookingDetailCreateParameters!
                            //         .isNotEmpty
                            //     ?
                            =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<BookingBloc>(context),
                                      child: ConfirmBooking(
                                        center: center!,
                                      ),
                                    ))),
                        // : ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //           "Hãy chọn chuồng cho pet trước khi tiến hành đặt lịch."),
                        //     ),
                        //   ),
                        // onPressed: () async {

                        //   var state = BlocProvider.of<BookingBloc>(context).state;
                        //   BookingRequestModel request =
                        //       (state as BookingUpdated).booking;
                        //   var result =
                        //       await BookingRepository().createBooking(request);
                        //   print(result);
                        //   //booking button
                        // },
                        icon:
                            //  state == BookingInitial() ? Container():
                            Container(
                                //margin: EdgeInsets.only(left: 30),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5 / 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  (state as BookingUpdated)
                                      .booking
                                      .getCartCount()
                                      .toString(),
                                  style: TextStyle(color: primaryColor),
                                )),
                        label: Container(
                            child: Row(
                          children: [
                            SizedBox(
                              width: width / 7,
                            ),
                            Text(
                              'Tiến Hành đặt lịch',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: width / 5 + 10,
                            ),
                      // onPressed: () async {

                      //   var state = BlocProvider.of<BookingBloc>(context).state;
                      //   BookingRequestModel request =
                      //       (state as BookingUpdated).booking;
                      //   var result =
                      //       await BookingRepository().createBooking(request);
                      //   print(result);
                      //   //booking button
                      // },
                      // icon: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 5, vertical: 5 / 2),
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.all(Radius.circular(10))),
                      //     child: Text(
                      //       cartcount.toString(),
                      //       style: TextStyle(color: primaryColor),
                      //     )),
                      label: Container(
                          child: Row(
                        children: [
                          SizedBox(
                            width: width / 5 + 15,
                          ),
                          Text(
                            'Tiến Hành đặt lịch',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: width / 5 + 10,
                          ),
                        ],
                      ))))
              : LoadingIndicator(loadingText: 'Vui lòng chờ');
        }));
  }
}

class LineIndicator extends Decoration {
  final Color color;
  final double radius;

  LineIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LinePainter(color: color, radius: radius);
  }
}

class _LinePainter extends BoxPainter {
  final Color color;
  final double radius;

  _LinePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Offset lineOffset =
        offset + Offset(cfg.size!.width / 3, cfg.size!.height);
    final Offset lineOffset2 =
        offset + Offset(cfg.size!.width / 3 * 2, cfg.size!.height);
    canvas.drawLine(lineOffset, lineOffset2, _paint);
  }
}
