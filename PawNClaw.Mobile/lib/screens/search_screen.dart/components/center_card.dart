import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

import '../subscreens/center_details_screen.dart';

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
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return InkWell(
            onTap: () {
              var state = BlocProvider.of<SearchBloc>(context).state;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CenterDetails(
                    petCenterId: center.id!,
                    requests: (state as SearchCompleted).requests,
                    bookingDate: state.bookingDate,
                    endDate: state.endDate,
                  ),
                ),
              );
            },
            child: Stack(children: [
              Container(
                width: width,
                height: height * 0.25,
                margin: EdgeInsets.symmetric(
                  horizontal: width * regularPadRate,
                  vertical: width * smallPadRate,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                        height: height * 0.15,
                        width: width * 0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('lib/assets/center0.jpg'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * smallPadRate * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            center.name!,
                            style: TextStyle(
                                fontSize: width * largeFontRate,
                                fontWeight: FontWeight.w500),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.location_on,
                                    size: width * regularFontRate,
                                    color: primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: center.address,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * smallFontRate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: width * smallFontRate,
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
                ),
                bottom: width * 0.1,
                right: width * 0.15,
              )
            ]));
      },
    );
  }
}
