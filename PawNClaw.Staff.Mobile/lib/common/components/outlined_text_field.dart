import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';

class OutlinedText extends StatefulWidget {
  final String labelText;
  // final String? errorText;
  final int? maxLine;
  final double? height;
  final IconData icon;
  final TextInputType inputType;
  final bool enable;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;
  final bool? obsecure;

  OutlinedText({
    required this.labelText,
    required this.icon,
    // this.errorText,
    this.maxLine,
    this.obsecure,
    this.height,
    this.inputType = TextInputType.text,
    this.enable = true,
    this.controller,
    this.onChange,
  });

  @override
  State<OutlinedText> createState() => _OutlinedTextState();
}

class _OutlinedTextState extends State<OutlinedText> {
  String? errorText;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: size.width * 0.81,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        onChanged: ((value) {
          if (widget.controller!.text.isEmpty) {
            setState(() {
              this.errorText = "*required";
            });
          } else {
            setState(() {
              this.errorText = null;
            });
          }
        }),
        keyboardType: widget.inputType,
        controller: widget.controller,
        enabled: widget.enable,
        maxLines: widget.maxLine ?? 1,
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: primaryColor),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
          errorText: errorText,
        ),
        obscureText: widget.obsecure ?? false,
        onFieldSubmitted: (value) {},
      ),
    );
  }
}
