import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/models/userbook.dart';
import 'package:mobile_ebiblioteka/providers/userbook_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:mobile_ebiblioteka/widgets/history_book.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';


class ReadingHistoryPage extends StatefulWidget {
  const ReadingHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReadingHistoryPage> createState() => _ReadingHistoryPageState();
}

class _ReadingHistoryPageState extends State<ReadingHistoryPage> {
late UserBookProvider _userBookProvider= UserBookProvider();

final TextEditingController _valueController=TextEditingController();
bool isLoading=true;
SearchResult<UserBook>? resultHistory;

@override
  void initState() {
    super.initState();
    _userBookProvider = context.read<UserBookProvider>();

    initData();

  }

  Future<void> initData() async {
    try {
      resultHistory = await _userBookProvider.getPaged(filter: {'pagesize':1000000, "userId":int.parse(Autentification.tokenDecoded!["Id"])});
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: AppLocalizations.of(context).reading_hist,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       // mora u expande jer ne zan koliko da se širi
              //       child: TextField(
              //         controller: _valueController,
              //         decoration: InputDecoration(
              //             label: Text(AppLocalizations.of(context).value_name)),
              //       ),
              //     ),
              //     ElevatedButton(
              //         onPressed: (() async {
              //           initData();
              //         }),
              //         child: Text(AppLocalizations.of(context).search))
              //   ],
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              Expanded(
                  child: (isLoading || resultHistory == null || resultHistory!.items.isEmpty)
                      ? const Center(child:  SpinKitRing(color: Colors.brown))
                      : ListView.builder(
                          // kada se koristi buider ucitavaju se kako scrollamo a ne sve od jednom
                          itemCount: resultHistory!.items.length,
                          itemBuilder: (context, index) {
                            // preko indeksa se pristupa elemntima u nizu
                            return HistoryBook(
                              bookId: resultHistory!.items[index].bookId ,
                            );
                          },
                        ))
            ],
          ),
        ));
  }
}
