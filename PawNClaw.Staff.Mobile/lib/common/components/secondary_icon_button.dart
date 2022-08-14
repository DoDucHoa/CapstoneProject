import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants.dart';

class SecondaryIconButton extends StatelessWidget {
  const SecondaryIconButton({required this.icon, required this.color, required this.onPressed,Key? key}) : super(key: key);
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.white),
        margin: EdgeInsets.only(right: 5),
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: color,
              size: 25,
            )));
  }
}
