import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/providers/bookfile_provider.dart';
import 'package:mobile_ebiblioteka/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import '../models/recommend_result.dart';
import '../providers/recommend_result_provider.dart';
import '../utils/util_widgets.dart';

class PdfShowPage extends StatefulWidget {
  const PdfShowPage({Key? key}) : super(key: key);

  @override
  State<PdfShowPage> createState() => _PdfShowPageState();
}

class _PdfShowPageState extends State<PdfShowPage> {
  // bool isLoading = true;
  // late BookFileProvider _bookFileProvider = BookFileProvider();
  // late RecommendResultProvider _recommendResultProvider =
  //     RecommendResultProvider();
  // RecommendResult? recommendResult;
  late NotificationProvider _notificationProvider = NotificationProvider();

  @override
  void initState() {
    super.initState();
    // _bookFileProvider = context.read<BookFileProvider>();
    // _recommendResultProvider = context.read<RecommendResultProvider>();
    _notificationProvider = context.read<NotificationProvider>();
    initForm();
  }

  Future<void> initForm() async {
    // try {
    //   recommendResult = await _recommendResultProvider.getById(18);

    //   setState(() {
    //     isLoading = false;
    //   });
    // } on Exception catch (e) {
    //   print(recommendResult);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Show'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (() async {
              try {
  var res = await _notificationProvider.sendRabbitNotification({
    "title": "asfdfsg",
    "content": "string",
    "isRead": true,
    "userId": 1
  });
  print(res);
} on Exception catch (e) {
      alertBox(context, 'error', e.toString());
 
}
            }),
            child: Text('Send notif'),
          ),
        ));
  }
}
