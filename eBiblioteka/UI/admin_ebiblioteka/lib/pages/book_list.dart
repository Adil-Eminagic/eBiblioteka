import 'package:admin_ebiblioteka/detail_pages/book_details.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/book_provider.dart';
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
  SearchResult<Book>? result;
  bool isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bookProvider = context.read<BookProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _bookProvider
          .getPaged(filter: {"title": _titleController.text});

      if (mounted) {
        setState(() {
          result = data;
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
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
          isLoading == false && result != null && result!.pageCount > 1 ?  const SizedBox(
          height: 20,
        ) : Container(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isLoading == false && result != null && result!.pageCount > 1)
              for (int i = 0; i < result!.pageCount; i++)
                InkWell(
                    onTap: () async {
                      try {
                        var data = await _bookProvider.getPaged(filter: {
                          "title": _titleController.text,
                          'pageNumber': i + 1
                        });

                        if (mounted) {
                          setState(() {
                            result = data;
                          });
                        }
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
            height: 20,
          ),
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            const DataColumn(label: Text("Id")),
            DataColumn(label: Text(AppLocalizations.of(context).title)),
            DataColumn(label: Text(AppLocalizations.of(context).wrote)),
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
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).title)),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _bookProvider
                      .getPaged(filter: {"title": _titleController.text});

                  if (mounted) {
                    setState(() {
                      result = data;
                    });
                  }
                } on Exception catch (e) {
                  alertBox(context, AppLocalizations.of(context).error,
                      e.toString());
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
