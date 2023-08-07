import 'package:admin_ebiblioteka/detail_pages/book_details.dart';
import 'package:admin_ebiblioteka/models/recommend_result.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/book_provider.dart';
import 'package:admin_ebiblioteka/providers/recommend_result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../utils/util_widgets.dart';
import '../widgets/master_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late BookProvider _bookProvider = BookProvider();
  late RecommendResultProvider _recommendResultProvider =
      RecommendResultProvider();
  SearchResult<Book>? result;
  bool isLoading = true;
  int _dropdownValue = 1;

 final TextEditingController _titleController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookProvider = context.read<BookProvider>();
    _recommendResultProvider = context.read<RecommendResultProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _bookProvider.getPaged(filter: {
        "title": _titleController.text,
        'isActive': _dropdownValue == 1 ? true : false,
      });

      setState(() {
        result = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: AppLocalizations.of(context).books,
        child: Column(children: [
          _buildSearch(),
          isLoading
              ? const SpinKitRing(color: Colors.brown)
              : _buildDataTable(),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isLoading == false && result != null && result!.pageCount > 1)
              for (int i = 0; i < result!.pageCount; i++)
                InkWell(
                    onTap: () async {
                      try {
                        var data = await _bookProvider.getPaged(filter: {
                          "title": _titleController.text,
                          'isActive': _dropdownValue == 1 ? true : false,
                          'pageNumber': i + 1
                        });

                        setState(() {
                          result = data;
                        });
                      } on Exception catch (e) {
                        alertBox(context, 'Greška', e.toString());
                      }
                    },
                    child: CircleAvatar(
                        backgroundColor: (i + 1 == result?.pageNumber)
                            ? Colors.brown
                            : Colors.white,
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                              color: (i + 1 == result?.pageNumber)
                                  ? Colors.white
                                  : Colors.brown),
                        ))),
          ]),
          const SizedBox(
            height: 65,
          ),
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns:  [
           const DataColumn(label:  Text("Id")),
            DataColumn(label: Text(AppLocalizations.of(context).title)),
            DataColumn(label: Text(AppLocalizations.of(context).wrote)),
            //DataColumn(label: Text("Žanr")),
            DataColumn(label: Text(AppLocalizations.of(context).author)),
          ],
          rows: result?.items
                  .map((Book e) => DataRow(
                          onSelectChanged: (value) async {
                            var refresh = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: e),
                            ));

                            if (refresh == 'reload') {
                              initTable();
                            }
                          },
                          cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text("${e.title}")),
                            DataCell(Text(e.publishingYear.toString())),
                            DataCell(Text(e.author?.fullName ?? '')),
                          ]))
                  .toList() ??
              [],
        ),
      ),
    );
  }

  Padding _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).title)),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: DropdownButton(
                  items:  [
                DropdownMenuItem(value: 0, child: Text(AppLocalizations.of(context).inactive)),
                DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context).active)),
              ],
                  value: _dropdownValue,
                  onChanged: ((value) {
                    if (value is int) {
                      setState(() {
                        _dropdownValue = value;
                      });
                    }
                  }))),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                    var data = await _recommendResultProvider.trainData();

                } on Exception catch (e) {
                  alertBox(context, AppLocalizations.of(context).error, e.toString());
                }
              },
              child:  Text(AppLocalizations.of(context).train_recommend)),
          const SizedBox(
            width: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _bookProvider.getPaged(filter: {
                    "title": _titleController.text,
                    'isActive': _dropdownValue == 1 ? true : false
                  });

                  setState(() {
                    result = data;
                  });
                } on Exception catch (e) {
                  alertBox(context, 'Greška', e.toString());
                }
              },
              child: Text(AppLocalizations.of(context).search)),
          const SizedBox(
            width: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                var refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BookDetailPage(
                      book: null,
                    ),
                  ),
                );
                if (refresh == 'reload') {
                  initTable();
                }
              },
              child: Text(AppLocalizations.of(context).add)),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
