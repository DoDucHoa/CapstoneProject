import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/models/center.dart' as petCenter;

class CenterInfo extends StatefulWidget {
  final petCenter.Center center;
  const CenterInfo({required this.center, Key? key}) : super(key: key);

  @override
  State<CenterInfo> createState() => _CenterInfoState();
}

class _CenterInfoState extends State<CenterInfo> {
  @override
  Widget build(BuildContext context) {
    petCenter.Center center = widget.center;
    return Scaffold(
      appBar: AppBar(title: Text('center info')),
    );
  }
}
