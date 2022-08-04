import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';

class InvoiceScreen extends StatefulWidget {
  InvoiceScreen({required this.invoiceUrl, Key? key}) : super(key: key);

  final String invoiceUrl;
  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Uint8List? doc;

  @override
  void initState() {
    // TODO: implement initState
    InternetFile.get(widget.invoiceUrl).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return doc != null
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: PdfView(
              pageLoader: LoadingIndicator(loadingText: "Đang tải"),
              controller: PdfController(
                document: PdfDocument.openData(doc!),
              ),
            ),
          )
        : LoadingIndicator(loadingText: "Đang tải");
  }
}
