import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/search/search_bloc.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

import '../components/center_card.dart';

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
            title: Text(
              "Khách sạn thú cưng",
              style: TextStyle(
                fontSize: widget.width * largeFontRate,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryFontColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: ListView.builder(
            itemCount: (state as SearchCompleted).centers.length,
            itemBuilder: ((context, index) {
              return CenterCard(
                width: widget.width,
                height: widget.height,
                center: state.centers[index],
              );
            }),
          ),
        );
      },
    );
  }
}
