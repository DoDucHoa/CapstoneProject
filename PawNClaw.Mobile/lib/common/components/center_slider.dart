import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants.dart';
import '../../models/fake_data.dart';

class CenterSlider extends StatefulWidget {
  final Size size;
  final List<String> photoUrls;
  final List<int> durations;
  final CenterCallback callback;

  const CenterSlider(
      {required this.size,
      required this.photoUrls,
      required this.callback,
      required this.durations,
      Key? key})
      : super(key: key);

  @override
  State<CenterSlider> createState() => _CenterSliderState();
}

typedef void CenterCallback(int brandId);

class _CenterSliderState extends State<CenterSlider> {
  int activeIndex = 0;
  int currentDurations = 0; 

  @override
  Widget build(BuildContext context) {
    Size size = widget.size;
    currentDurations =  widget.durations[0];

    return Container(
        child: Stack(
      children: [
        CarouselSlider.builder(
            itemCount: widget.photoUrls.length,
            itemBuilder: (context, index, realIndex) {
              // setState(() {
                // currentDurations = widget.durations[index];
              // });
              return InkWell(
                onTap: () => widget.callback(index),
                child: Container(
                    width: size.width,
                    // height: size.height*0.3,
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: //Image.network(widget.photoUrls[index], fit: BoxFit.cover,)
                        Image.asset(
                          'lib/assets/sponsor-0.png',
                          fit: BoxFit.cover,
                        ),
                        )),
              );
            },
            options: CarouselOptions(
                height: size.height * 0.35,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: currentDurations),
                onPageChanged: ((index, reason) {
                  setState(() => activeIndex = index);
                }))),
        Positioned(
          bottom: 10,
          left: size.width *
              (1 -
                  2 * regularPadRate -
                  0.035 *
                      ((widget.photoUrls.length < 5)
                          ? widget.photoUrls.length
                          : 5)) /
              2,
          right: size.width *
              (1 -
                  2 * regularPadRate -
                  0.035 *
                      ((widget.photoUrls.length < 5)
                          ? widget.photoUrls.length
                          : 5)) /
              2,
          child: buildIndicator(),
        )
      ],
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.photoUrls.length,
        effect: ScrollingDotsEffect(
            activeDotColor: lightFontColor, dotHeight: 8, dotWidth: 8),
      );
}
