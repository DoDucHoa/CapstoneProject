import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/models/review.dart';

import '../../../common/constants.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({required this.review, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Stack(children: [
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          color: lightFontColor,
                          size: 16,
                        ),
                        Text(
                          review.rating.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(review.customerAva),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.customerName,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width * 2 / 3,
                          child: Text(
                            review.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: lightFontColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ]))));
  }
}
