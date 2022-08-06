import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({required this.user, Key? key}) : super(key: key);
  final Account user;

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: frameColor,
      appBar: AppBar(
        // title: Text(
        //   'Thông tin cá nhân',
        // ),
        foregroundColor: primaryFontColor,
        backgroundColor: frameColor,
        titleSpacing: width * extraSmallPadRate,
        leadingWidth: width * mediumPadRate * 2,
        elevation: 0,
        leading: Container(),
        // leading: IconButton(
        //     icon:const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       size: 20,
        //       color: lightFontColor,
        //     ),
        //     onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        
      ]),
    );
  }
}
