import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pawnclaw_mobile_application/blocs/sponsor/sponsor_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;
import 'package:pawnclaw_mobile_application/models/photo.dart';

import '../../center_overview_screen/center_overview_screen.dart';
import '../../search_screen.dart/subscreens/center_details_screen.dart';

class CenterCard extends StatelessWidget {
  const CenterCard({
    required this.center,
    Key? key,
  }) : super(key: key);

  final petCenter.Center center;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // Photo? thumbnail;
    // Photo? background;
    // if (center.photos != null &&
    //     center.photos!.isNotEmpty) {
    //   center.photos!.forEach((photo) {
    //     if (photo.isThumbnail!) {
    //       thumbnail = photo;
    //       return;
    //     }
    //   });
    //   center.photos!.forEach((photo) {
    //     if (!photo.isThumbnail!) {
    //       background = photo;
    //       return;
    //     }
    //   });
    // }
    // return
    //  BlocBuilder<SponsorBloc, SponsorState>(
    //   builder: (context, state) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CenterOverview(
                petCenterId: center.id!,
                isSponsor: true,
              ),
            ),
          );
        },
        child: Stack(children: [
          Container(
            width: width,
            height: height * 0.31,
            margin: EdgeInsets.symmetric(
              horizontal: width * smallPadRate,
              vertical: width * extraSmallPadRate,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  backgroundColor,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        // (center.imgUrl != null)?
                        // FadeInImage.assetNetwork(placeholder: 'lib/assets/paw-gif.gif', image:
                        //     center.imgUrl!,
                        //     width: width * (1 - 2 * mediumPadRate),
                        //    height: height * 0.18,
                        //     fit: BoxFit.cover,
                        //     placeholderFit: BoxFit.scaleDown,

                        //   )
                        // :
                        (center.getBackGround() == null)
                            ? Image.asset(
                                'lib/assets/center0.jpg',
                                width: width * (1 - 2 * mediumPadRate),
                                height: height * 0.18,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: 'lib/assets/new-paw.gif',
                                image: center.getBackGround()!.url!,
                                width: width * (1 - 2 * mediumPadRate),
                                height: height * 0.18,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: width * extraSmallPadRate * 0.5),
                  padding: EdgeInsets.only(
                      top: width * mediumPadRate, left: width * smallPadRate),
                  height: width * (largeFontRate + mediumPadRate),
                  child: Text(
                    center.name!,
                    style: TextStyle(
                        fontSize: 20, //width * largeFontRate,
                        fontWeight: FontWeight.w500,
                        height: 1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: width * extraSmallPadRate * 0.5),
                  padding:
                      EdgeInsets.symmetric(horizontal: width * smallPadRate),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: width * regularFontRate,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: width * 0.5,
                        child: Text(
                          center.shortAddress(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: lightFontColor,
                            fontWeight: FontWeight.w400,
                            fontSize: width * smallFontRate,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      if (center.rating! != 0)
                        Row(
                          children: [
                            Icon(
                              Icons.star_rate_rounded,
                              size: width * regularFontRate,
                              color: primaryColor,
                            ),
                            Text(
                              center.rating.toString(),
                              style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '(' + center.ratingCount.toString() + ')',
                              style: TextStyle(
                                color: lightFontColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 0.18 - 50 / 2 + smallPadRate * width * 0.5,
            left: width * regularPadRate,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  image: (center.getThumbnail() == null)
                      ? DecorationImage(
                          image: AssetImage('lib/assets/vet-ava.png'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(center.getThumbnail()!.url!),
                          fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(height * 0.1),
                  border: Border.all(width: 2, color: Colors.white)),
            ),
          ),
          Positioned(
            top: width * smallPadRate,
            right: width * regularPadRate,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 5, horizontal: width * extraSmallPadRate),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Text(
                'Sponsor',
                style: TextStyle(
                    fontSize: 13, //width * largeFontRate,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: primaryColor),
              ),
            ),
          ),
        ]));
    // },
    // )
    ;
  }
}
