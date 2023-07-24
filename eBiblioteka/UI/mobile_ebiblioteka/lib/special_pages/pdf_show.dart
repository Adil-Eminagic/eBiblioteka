
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfShowPage extends StatefulWidget {
  const PdfShowPage({Key? key}) : super(key: key);

  @override
  State<PdfShowPage> createState() => _PdfShowPageState();
}

class _PdfShowPageState extends State<PdfShowPage> {
Uint8List? list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:false,
      title: const Text('Show'),),
       body:  
       const PdfView(path: 'https://10.0.2.2:7272/api/Pdf',)
    );
  }
}

