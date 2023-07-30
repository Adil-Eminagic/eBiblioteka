import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/providers/base_provider.dart';
import 'package:mobile_ebiblioteka/utils/util_widgets.dart';
import 'package:provider/provider.dart';

import '../providers/bookfile_provider.dart';
import '../utils/util.dart';

class BookPdfShow extends StatefulWidget {
  const BookPdfShow({Key? key, this.fileId}) : super(key: key);
  final int? fileId;

  @override
  State<BookPdfShow> createState() => _BookPdfShowState();
}

class _BookPdfShowState extends State<BookPdfShow> {
  PDFDocument? document;
  bool isLoading = true;
  late BookFileProvider _bookFileProvider = BookFileProvider();
  @override
  void initState() {
    super.initState();
    _bookFileProvider = context.read<BookFileProvider>();
    initFile();
  }

  Future<void> initFile() async {
    try {
      var url = _bookFileProvider.filerUrl(widget.fileId!);

      var randomQueryParameter = DateTime.now().millisecondsSinceEpoch;
      url += '?v=$randomQueryParameter';

      document = await PDFDocument.fromURL(url, headers: createPdfHeaders());

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Show'),
      ),
      body: isLoading == false
          ? PDFViewer(
              document: document!,
            )
          : Container(),
    );
  }

  Map<String, String> createPdfHeaders() {
    String jwt = Autentification.token ?? '';

    String jwtAuth = "Bearer $jwt";

    var headers = {"Content-Type": "application/pdf", "Authorization": jwtAuth};

    return headers;
  }
}
