import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer(
      {Key? key,
      required this.height,
      required this.width,
      required this.elevation,
      required this.child,
      this.circularRadius})
      : super(key: key);

  final double height;
  final double width;
  final double elevation;
  final double? circularRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circularRadius ?? 25),
      child: Container(
        margin: EdgeInsets.only(
          bottom: elevation,
          left: 1,
          right: 1,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(circularRadius ?? 25),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(0.0, 1.0), //(x,y)
              blurRadius: elevation,
            ),
          ],
        ),
        alignment: Alignment.center,
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
