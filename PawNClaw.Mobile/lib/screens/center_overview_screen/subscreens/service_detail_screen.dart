import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/pet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../../models/fake_data.dart';

class ServiceDetails extends StatefulWidget {
  final petCenter.Services service;
  const ServiceDetails({required this.service, Key? key}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  int activeIndex = 0;
  int selectedIndex = 0;
  double selectedPrice = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    double appbarSize = size.height * 0.35;
    petCenter.Services service = widget.service;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              expandedHeight: appbarSize,
              floating: true,
              pinned: true,
              //leading: Icon(Icons.arrow_back),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: [
                      //campaign image
                      CarouselSlider.builder(
                          itemCount: 1,
                          itemBuilder: (context, index, realIndex) {
                            return Container(
                                width: size.width,
                                child: (service.photo?.url == null) ? Image.asset(
                                  'lib/assets/service.png',
                                  fit: BoxFit.cover,
                                ): Image.network(
                                  service.photo!.url!,
                                  fit: BoxFit.cover,
                                ));
                          },
                          options: CarouselOptions(
                              height: appbarSize,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              onPageChanged: ((index, reason) {
                                setState(() => activeIndex = index);
                              }))),
                      // Positioned(
                      //     left: size.width / 3 + 15,
                      //     top: appbarSize * (1 - 0.2),
                      //     child: Center(
                      //       child: buildIndicator(),
                      //     )),
                        Container(
                        height: appbarSize,
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
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: appbarSize * 0.2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                          )),
                    ],
                  )),
            )
          ];
        },
        body: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 80,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name ?? service.description ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                                  decimalDigits: 0, symbol: '', locale: 'vi_vn')
                              .format(service.minPrice) +
                          " ~ " +
                          NumberFormat.currency(
                                  decimalDigits: 0,
                                  symbol: 'đ',
                                  locale: 'vi_vn')
                              .format(service.maxPrice),
                      //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                // cage.discount! > 0 ?
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              //height: 100,
              width: size.width,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    'Chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ReadMoreText(
                    // cage.description,
                    service.description ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: lightFontColor,
                      fontWeight: FontWeight.w500,
                    ), //halt
                    trimLines:
                        5, //thêm card chọn pet xong thì sửa số này lại nhá
                    trimCollapsedText: 'xem thêm',
                    trimExpandedText: 'thu gọn',
                    // maxLines: 5,
                    // overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
        ])),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: CAGE_PHOTOS.length,
        effect: const ScrollingDotsEffect(
            activeDotColor: lightFontColor, dotHeight: 10, dotWidth: 10),
      );
}
