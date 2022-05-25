import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/constants.dart';
import '../../../models/fake_data.dart';

class CenterSlider extends StatefulWidget {
  final Size size;

  const CenterSlider({required this.size, Key? key}) : super(key: key);

  @override
  State<CenterSlider> createState() => _CenterSliderState();
}

class _CenterSliderState extends State<CenterSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = widget.size;
    return Container(
        child: Stack(
      children: [
        CarouselSlider.builder(
            itemCount: CAGE_PHOTOS.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      CAGE_PHOTOS[index],
                      fit: BoxFit.cover,
                    ),
                  ));
            },
            options: CarouselOptions(
                height: size.width * 9 / 16,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: ((index, reason) {
                  setState(() => activeIndex = index);
                }))),
        Positioned(
          bottom: 10,
          left: size.width / 3 + 15,
          child: buildIndicator(),
        )
      ],
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: CAGE_PHOTOS.length,
        effect: ScrollingDotsEffect(
            activeDotColor: lightFontColor, dotHeight: 10, dotWidth: 10),
      );
}
