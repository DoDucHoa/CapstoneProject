import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

class AvailableCenterScreen extends StatefulWidget {
  const AvailableCenterScreen({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  State<AvailableCenterScreen> createState() => _ShowAvailableCenterState();
}

class _ShowAvailableCenterState extends State<AvailableCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: const Text(
              "Pet Hotels",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: ListView.builder(
            itemCount: (state as SearchCompleted).centers.length,
            itemBuilder: ((context, index) {
              return CenterCard(width:);
            }),
          ),
        );
      },
    );
  }
}

class CenterCard extends StatelessWidget {
  const CenterCard({
    required this.center,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  final petCenter.Center center;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: width,
        height: height * 0.25,
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: width * 0.05,
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
              margin: EdgeInsets.symmetric(horizontal: width * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    center.name!,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.location_on,
                            size: 14,
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: center.address,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
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
        child: const Icon(Icons.star_border_outlined, size: 18),
        bottom: width * 0.1,
        right: width * 0.15,
      )
    ]);
  }
}
