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

class BookGenresPage extends StatefulWidget {
  const BookGenresPage({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  State<BookGenresPage> createState() => _BookGenresPageState();
}

class _BookGenresPageState extends State<BookGenresPage> {
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();
  late BookProvider _bookProvider = BookProvider();

  SearchResult<BookGenre>? result;
  Book? bookSend;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookGenreProvider = context.read<BookGenreProvider>();
    _bookProvider = context.read<BookProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _bookGenreProvider
          .getPaged(filter: {'bookId': widget.book?.id});
      bookSend = await _bookProvider.getById(widget.book!.id!);

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
        title: "Žanrovi knjige ${widget.book?.title}",
        child: Column(children: [
          _buildSearch(),
          (isLoading || result == null || result!.items.isEmpty )? Container() : _buildDataTable(),
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Žanr")),
            DataColumn(label: Text("Knjiga")),
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
              child: const Text('Dodaj')),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
