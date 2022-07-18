import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double contextWidth;
  const SecondaryButton(
      {required this.text,
      required this.onPressed,
      required this.contextWidth,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            side: const BorderSide(
              color: primaryColor,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: contextWidth * smallPadRate,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ));
  }
}
