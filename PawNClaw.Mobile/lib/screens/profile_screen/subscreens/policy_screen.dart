import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/auth_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String? policyHtml;

  @override
  void initState() {
    AuthRepository().getPolicy().then((policy) {
      setState(() {
        policyHtml = '''<!DOCTYPE html>
        <html>
        <body>

        $policy

        </body>
        </html>''';
      });
    });
    super.initState();
  }

  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Policy'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: (policyHtml != null)
          ? Padding(
            padding:  EdgeInsets.symmetric(horizontal:width*mediumPadRate),
            child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                allowsInlineMediaPlayback: true,
                onWebViewCreated: (controller) {
                  this.controller = controller;
                  loadHtml();
                },
              ),
          )

          : CircularProgressIndicator(),
    );
  }

  // final html = '<h1> this is header</h1>';
  void loadHtml() async {
    final url = Uri.dataFromString(policyHtml!,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    controller.loadUrl(url);
  }
}
