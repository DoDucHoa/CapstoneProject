import 'package:flutter/material.dart';
import 'package:pncstaff_mobile_application/common/constants.dart';

class OutlinedText extends StatelessWidget {
  final String labelText;
  final String? errorText;
  final int? maxLine;
  final double? height;
  final IconData icon;
  final TextInputType inputType;
  final bool enable;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;

  OutlinedText({
    required this.labelText,
    required this.icon,
    this.errorText,
    this.maxLine,
    this.height,
    this.inputType = TextInputType.text,
    this.enable = true,
    this.controller,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: size.width * 0.81,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        onChanged: onChange,
        keyboardType: inputType,
        controller: controller,
        enabled: enable,
        maxLines: maxLine,
        decoration: InputDecoration(
          icon: Icon(icon, color: primaryColor),
          labelText: labelText,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
