import 'package:flutter/material.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, required this.loadingText})
      : super(key: key);

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text(
            loadingText,
            style: TextStyle(
              fontSize: width * regularFontRate,
              color: lightPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
