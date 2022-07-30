import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../common/components/elevated_container.dart';
import '../../../common/constants.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const SearchBar({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ElevatedContainer(
            height: height * 0.06,
            width: width * (1 - 2*smallPadRate),
            child: TextField(
              controller: controller,
              // enabled: false,
              showCursor: true,
              autofocus: true,
              decoration:const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                hintText: "Tìm kiếm trung tâm thú cưng",
                hintStyle: TextStyle(
                    color: lightFontColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.4,
                    ),
                border: InputBorder.none,
                suffixIcon: Icon(Icons.close_rounded, color: lightFontColor,)
                
              ),
              
            ),
            elevation: width * 0.015,
          );
  }
}