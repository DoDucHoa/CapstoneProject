import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawnclaw_mobile_application/models/fake_data.dart';
import 'package:pawnclaw_mobile_application/models/cage.dart';
import 'package:pawnclaw_mobile_application/models/cage_type.dart';

import '../components/catergory_card.dart';
import '../components/review_card.dart';

class CenterDetails extends StatelessWidget {
  const CenterDetails({required this.center, Key? key}) : super(key: key);

  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double appbarSize = height * 0.5;

    int cartcount = 2;

    return Scaffold(
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
                            // ),

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
                                          children: [
                                            Container(
                                              width: width * 2 / 3,
                                              child: Text(
                                                center.name!,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                            Icon(
                                              Icons.star_rate_rounded,
                                              color: lightPrimaryColor,
                                            ),
                                            Text(
                                              center.rating!.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              ' (' +
                                                  center.rating!.toString() +
                                                  ')',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: lightFontColor),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5, bottom: 5),
                                            child: Container(
                                                padding:
                                                    EdgeInsets.all(11 * 0.4),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  //border: Border.all(width: 1),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              4, 3, 5, 2),
                                                      child: Image.asset(
                                                        'lib/assets/white-paw.png',
                                                        width: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Đối tác PawNClaw   ',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                        BorderRadius.circular(
                                                            10))),
                                            onPressed: () {},
                                            icon: Image.asset(
                                              'lib/assets/coupon.png',
                                              width: 30,
                                            ),
                                            label: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 15, 5, 15),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Bạn có 4 ưu đãi',
                                                      style: TextStyle(
                                                          color:
                                                              primaryFontColor),
                                                    ),
                                                    Expanded(child: SizedBox()),
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
                          onPressed: () {}, icon: Icon(Icons.search_rounded)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.info_outline)),
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
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
                      indicator:
                          LineIndicator(color: primaryColor, radius: width / 4),
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
                        child: Container(
                            child:
                                //       Wrap(
                                // spacing: 12,
                                // runSpacing: 8,
                                // children:
                                ListView.separated(
                          itemBuilder: (context, index) {
                            return CatergoryCard(
                              id: FAKE_CAGETYPES[index].id,
                              name: FAKE_CAGETYPES[index].name,
                              size: size,
                            );
                          },
                          itemCount: FAKE_CAGETYPES.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        )
                            //cageTypeList(FAKE_CAGETYPES, context),
                            )),
                    Text(
                      '2',
                    ),
                    Text(
                      '3',
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
                            return ReviewCard(review:FAKE_REVIEWS[index]);
                          },
                          itemCount: FAKE_REVIEWS.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8,),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        )
                            //cageTypeList(FAKE_CAGETYPES, context),
                            )),
                  ])),
            )),
        
        floatingActionButton: FloatingActionButton.extended(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              //booking button
            },
            
            icon: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5 / 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  cartcount.toString(),
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
                  width: width / 5 + 5,
                ),
              ],
            ))));
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
