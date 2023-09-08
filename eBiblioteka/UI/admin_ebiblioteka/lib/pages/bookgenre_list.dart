import 'package:admin_ebiblioteka/detail_pages/bookgenre_detail.dart';
import 'package:admin_ebiblioteka/models/bookgenre.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/book_provider.dart';
import 'package:admin_ebiblioteka/providers/bookgenre_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookGenresPage extends StatefulWidget {
  const BookGenresPage({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  State<BookGenresPage> createState() => _BookGenresPageState();
}

class _BookGenresPageState extends State<BookGenresPage> {
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();
  late BookProvider _bookProvider = BookProvider();

  TextEditingController _nameController = TextEditingController();
  SearchResult<BookGenre>? result;
  Book? bookSend;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookGenreProvider = context.read<BookGenreProvider>();
    _bookProvider = context.read<BookProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _bookGenreProvider.getPaged(filter: {
        'bookId': widget.book?.id,
        "genreName": _nameController.text,
        "pageSize": 1000000
      });
      bookSend = await _bookProvider.getById(widget.book!.id!);

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
        title:
            "${AppLocalizations.of(context).bookgenre_title} ${widget.book?.title}",
        child: Column(children: [
          _buildSearch(),
          (isLoading || result == null || result!.items.isEmpty)
              ? Center(child: Text(AppLocalizations.of(context).no_book_genres, style:const TextStyle(fontSize: 17),))
              : _buildDataTable(),
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text(AppLocalizations.of(context).genre)),
            DataColumn(label: Text(AppLocalizations.of(context).book)),
          ],
          rows: result?.items
                  .map((BookGenre e) => DataRow(
                          onSelectChanged: (value) async {
                            var refresh = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => BookGenreDetailPage(
                                bookGenre: e,
                                book: bookSend,
                              ),
                            ));

                            if (refresh == 'reload') {
                              initTable();
                            }
                          },
                          cells: [
                            DataCell(Text("${e.genre?.name}")),
                            DataCell(Text("${e.book?.title}")),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context).name_2)),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _bookGenreProvider.getPaged(filter: {
                    "genreName": _nameController.text,
                    "pageSize": 1000000,
                    "bookId": widget.book!.id
                  });

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
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookGenreDetailPage(
                      bookGenre: null,
                      book: bookSend,
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
