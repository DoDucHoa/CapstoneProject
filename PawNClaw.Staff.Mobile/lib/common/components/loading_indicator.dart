import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, required this.loadingText})
      : super(key: key);

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const CircularProgressIndicator(),
              SizedBox(
                height: width * 0.25,
                child: Image.asset('lib/assets/paw-gif.gif'),
              ),
              const SizedBox(height: 5),
              Container(
                  width: width / 2,
                  child: Text(
                    loadingText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * regularFontRate,
                      color: lightPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ));
  }
}
