import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawnclaw_mobile_application/blocs/authentication/auth_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:pawnclaw_mobile_application/models/photo.dart';
import 'package:pawnclaw_mobile_application/models/voucher.dart';
import 'package:pawnclaw_mobile_application/repositories/center/center_repository.dart';
import 'package:pawnclaw_mobile_application/screens/booking_from_search_screen/main_screen.dart';
import 'package:pawnclaw_mobile_application/screens/booking_screen/confirm_booking.dart';
import 'package:pawnclaw_mobile_application/common/components/center_slider.dart';
import 'package:pawnclaw_mobile_application/screens/center_overview_screen/components/service_card.dart';
import 'package:pawnclaw_mobile_application/screens/center_overview_screen/components/supplytype_card.dart';
import 'package:pawnclaw_mobile_application/screens/center_overview_screen/subscreens/service_detail_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/components/item_card.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/show_vouchers_screen.dart';
import 'package:pawnclaw_mobile_application/screens/search_screen.dart/subscreens/vouchers_screen.dart';

import 'components/catergory_card.dart';
import 'components/review_card.dart';

class CenterOverview extends StatefulWidget {
  const CenterOverview(
      {required this.petCenterId, required this.isSponsor, Key? key})
      : super(key: key);

  final int petCenterId;
  final bool isSponsor;

  @override
  State<CenterOverview> createState() => _CenterOverviewState();
}

class _CenterOverviewState extends State<CenterOverview> {
  petCenter.Center? center;
  List<Voucher>? vouchers;
  bool loadedDetail = false;
  // Photo? thumbnail;
  // Photo? background;
  List<String> supplyType = ["FOOD", "DRINK", "MED", "OTHER"];
  List<String> photoUrls = [];
  List<int> durations = [];
  @override
  void initState() {
    // TODO: implement initState
    //petCenter.Center? center;
    // var temp;
    CenterRepository().getCenterOverview(widget.petCenterId).then((value) {
      setState(() {
        center = value;
        if (value != null && value.photos!.isNotEmpty) {
          if (value.getFacilities() != null && value.getFacilities()!.isNotEmpty) {
            for (var i = 0; i < value.getFacilities()!.length; i++) {
              photoUrls.add(value.getFacilities()![i].url!);
              durations.add(2);
            }
          }
          ;}
    //       value.photos!.forEach((element) {
    //         if (!element.isThumbnail!) {
    //           background = element;
    //           return;
    //         }
    //       });
    //       // background =
    //       //     value.photos!.firstWhere((photo) => photo.isThumbnail == false));
        
    //   // background =
    //   //     value.photos!.firstWhere((photo) => photo.isThumbnail == false));

    // }
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

    // CenterRepository()
    //     .getCenterVouchers(widget.petCenterId, customerId)
    //     .then((value) {
    //   vouchers = value;

    //   //loadedDetail = true;
    // });
    // return BlocProvider(
    //     create: (context) => BookingBloc()
    //       ..add(
    //         InitBooking(
    //             startBooking: widget.bookingDate,
    //             endBooking: widget.endDate,
    //             centerId: widget.petCenterId,
    //             request: widget.requests,
    //             customerId: customerId,
    //             due: widget.due),
    //       ),
    //     child:
    // BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
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
                        expandedHeight: appbarSize -
                            ((vouchers == null || vouchers!.isEmpty) ? 60 : 0),
                        floating: true,
                        pinned: true,
                        //leading: Icon(Icons.arrow_back),
                        flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Stack(
                              children: [
                                (center!.getBackGround() == null)
                                    ? Image.asset(
                                        'lib/assets/center0.jpg',
                                        width: width,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        //placeholder: 'lib/assets/new-paw.gif',
                                        // image:
                                        center!.getBackGround()!.url!,
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
                                              topLeft: Radius.circular(50.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight: Radius.circular(10.0)
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width * 2 / 3,
                                                  height:
                                                      width * (largeFontRate) +
                                                          10 +
                                                          center!.name!.length *
                                                              0.5,
                                                  child: Text(
                                                    center?.name ?? "",
                                                    style: TextStyle(
                                                      fontSize:
                                                          20, //width*(largeFontRate) - center!.name!.length*0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Iconsax.star1,
                                                      color: lightPrimaryColor,
                                                    ),
                                                    Text(
                                                      center?.rating!
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' (' +
                                                          (center?.ratingCount!
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
                                                )
                                              ],
                                            ),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5, bottom: 5),
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        11 * 0.4),
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      //border: Border.all(width: 1),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  4, 3, 5, 2),
                                                          child: Image.asset(
                                                            'lib/assets/white-paw.png',
                                                            width: 13,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Đối tác PawNClaw   ',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // (vouchers != null && vouchers!.isNotEmpty)
                                            //     ? OutlinedButton.icon(
                                            //         style: OutlinedButton.styleFrom(
                                            //             shape: RoundedRectangleBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(
                                            //                         10))),
                                            //         onPressed: () => Navigator.of(context)
                                            //             .push(MaterialPageRoute(
                                            //                 builder: (context) =>
                                            //                     ShowVouchers(
                                            //                         vouchers:
                                            //                             vouchers!))),
                                            //         icon: Image.asset(
                                            //           'lib/assets/coupon.png',
                                            //           width: 30,
                                            //         ),
                                            //         label: Container(
                                            //             padding:
                                            //                 EdgeInsets.fromLTRB(
                                            //                     10, 15, 5, 15),
                                            //             child: Row(
                                            //               children: [
                                            //                 Text(
                                            //                   'Bạn có ${vouchers!.length} ưu đãi',
                                            //                   style: TextStyle(
                                            //                       color:
                                            //                           primaryFontColor),
                                            //                 ),
                                            //                 Expanded(
                                            //                     child:
                                            //                         SizedBox()),
                                            //                 Icon(Icons
                                            //                     .keyboard_double_arrow_right),
                                            //               ],
                                            //             )))
                                            //     : Container()
                                          ],
                                        ))),

                                Positioned(
                                  top: appbarSize * 0.45 - 65 / 2,
                                  left: 20,
                                  child: Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        image: (center!.getThumbnail() == null)
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    'lib/assets/vet-ava.png'),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    center!.getThumbnail()!.url!),
                                                fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.1),
                                        border: Border.all(
                                            width: 2, color: Colors.white)),
                                  ),
                                ),
                              ],
                            )),
                        actions: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search_rounded)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.info_outline)),
                        ],
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        bottom: TabBar(
                          tabs: const [
                            Tab(
                              text: 'Phòng',
                            ),
                            Tab(
                              text: 'Đồ dùng',
                            ),
                            Tab(
                              text: 'Dịch vụ',
                            ),
                            Tab(
                              text: 'Đánh giá',
                            ),
                          ],
                          labelColor: primaryColor,
                          unselectedLabelColor: lightFontColor,
                          labelStyle: TextStyle(fontWeight: FontWeight.w700),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var cageType = center?.cageTypes?[index];
                                    return CatergoryCard(
                                        cageType: cageType!, size: size);
                                  },
                                  itemCount: center?.cageTypes?.length ?? 0,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 8,
                                  ),
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                )),
                                (photoUrls.isNotEmpty)
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 10, 10),
                                        child: Text(
                                          'CƠ SỞ VẬT CHẤT',
                                          style: TextStyle(
                                              color: lightFontColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    : Container(),
                                (photoUrls.isNotEmpty)
                                    ? CenterSlider(
                                        size: size*0.9,
                                        photoUrls: photoUrls,
                                        callback: (index) {},
                                        durations: durations)
                                    : Container(),

                                // }),),
                                SizedBox(height: 80)
                              ],
                            )),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  service: service ?? new petCenter.Services(),
                                  redirect: ServiceDetails(service: service!),
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
                                    review: center!.reviews![index]);
                              },
                              itemCount: center!.reviews!.length,
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    centerId: widget.petCenterId,
                                    isSponsor: widget.isSponsor,
                                  )));
                    },
                    label: Container(
                      width: width * (1 - 2 * smallPadRate),
                      padding:
                          EdgeInsets.symmetric(vertical: width * smallPadRate),
                      child: const Center(
                        child: Text(
                          'Kiểm tra phòng trống',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ))))
        : LoadingIndicator(loadingText: 'Vui lòng đợi');
    // }
    // ))
    // ;
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
