import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:readmore/readmore.dart';

import '../../../models/cage.dart';
import '../../../models/fake_data.dart';

class CageDetails extends StatefulWidget {
  final Cage cage;
  const CageDetails({required this.cage, Key? key}) : super(key: key);

  @override
  State<CageDetails> createState() => _CageDetailsState();
}

class _CageDetailsState extends State<CageDetails> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double appbarSize = size.height * 0.35;
    Cage cage = widget.cage;

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
                        itemCount: CAGE_PHOTOS.length,
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                              width: size.width,
                              child: Image.asset(
                                CAGE_PHOTOS[index],
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
                    Positioned(
                        left: size.width / 3 + 15,
                        top: appbarSize * (1 - 0.2),
                        child: Center(
                          child: buildIndicator(),
                        )),

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
      body: buildContent(cage, size),
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: CAGE_PHOTOS.length,
        effect: ScrollingDotsEffect(
            activeDotColor: lightFontColor, dotHeight: 10, dotWidth: 10),
      );
}

Widget buildContent(Cage cage, Size size) {
  return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      height: 100,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cage.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                NumberFormat.currency(
                  decimalDigits: 0,
                  symbol: '',
                ).format(cage.discount! > 0
                    ? cage.price - cage.discount!
                    : cage.price),
                //double.parse(cage.price.toStringAsFixed(0)).toStringAsExponential(),
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                width: 5,
              ),
              if (cage.discount! > 0)
                Text(
                  NumberFormat.currency(
                    decimalDigits: 0,
                    symbol: '',
                  ).format(cage.price),
                  style: TextStyle(
                      fontSize: 15,
                      color: lightFontColor,
                      decoration: TextDecoration.lineThrough),
                ),
              SizedBox(
                width: 5,
              ),
              if (cage.discount! > 0)
                Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    child: Container(
                      padding: EdgeInsets.all(13 * 0.4),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        //border: Border.all(width: 1),
                      ),
                      child: Text(
                        '  Khuyến mãi  ',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
            ],
          ),
          // cage.discount! > 0 ?
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
    SizedBox(
      height: 15,
    ),
    Container(
        //height: 100,
        width: size.width,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            ReadMoreText(
              cage.description,
              style: TextStyle(
                fontSize: 15,
                color: lightFontColor,
                fontWeight: FontWeight.w500,
              ),//halt
              trimLines: 5, //thêm card chọn pet xong thì sửa số này lại nhá
              trimCollapsedText: 'xem thêm',
              trimExpandedText: 'thu gọn',
              // maxLines: 5,
              // overflow: TextOverflow.ellipsis,
            )
          ],
        )),
    Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: ElevatedButton(
          onPressed: () {},
          child: Row(children: [
            Expanded(
                child: SizedBox(
              height: 45,
            )),
            Text(
              'Thêm vào giỏ hàng - ' +
                  NumberFormat.currency(
                          decimalDigits: 0, symbol: 'đ', locale: 'vi_vn')
                      .format((cage.price - cage.discount!)),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Expanded(child: SizedBox(height: 45)),
          ]),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ))
  ]));
}
