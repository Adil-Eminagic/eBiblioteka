import 'package:admin_ebiblioteka/detail_pages/quote_detail.dart';
import 'package:admin_ebiblioteka/models/quote.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/quotes_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuotesListPage extends StatefulWidget {
  const QuotesListPage({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<QuotesListPage> createState() => _QuotesListPageState();
}

class _QuotesListPageState extends State<QuotesListPage> {
  late QuoteProvider _quoteProvider = QuoteProvider();
  final TextEditingController _contentConroller = TextEditingController();

  SearchResult<Quote>? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _quoteProvider = context.read<QuoteProvider>();
    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _quoteProvider.getPaged(
          filter: {"bookId": widget.bookId, "content": _contentConroller.text});

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
      title: AppLocalizations.of(context).quotes,
      child: Column(children: [
        _buildSearch(),
        isLoading ? Container() : _buildDataTable(),
         isLoading == false && result != null && result!.pageCount > 1 ?  const SizedBox(
          height: 20,
        ) : Container(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (isLoading == false && result != null && result!.pageCount > 1)
            for (int i = 0; i < result!.pageCount; i++)
              InkWell(
                  onTap: () async {
                    try {
                      var data = await _quoteProvider.getPaged(filter: {
                        "content": _contentConroller.text,
                        "bookId": widget.bookId,
                        'pageNumber': i + 1
                      });

                      if (mounted) {
                        setState(() {
                          result = data;
                        });
                      }
                    } on Exception catch (e) {
                      alertBox(context, AppLocalizations.of(context).error, e.toString());
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
        )
      ]),
    );
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
          child: DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context).name_2)),
            ],
            rows: result?.items
                    .map((Quote e) => DataRow(
                            onSelectChanged: (value) async {
                              var refresh = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => QuoteDetailPage(
                                  quote: e,
                                ),
                              ));

                              if (refresh == 'reload') {
                                initTable();
                              }
                            },
                            cells: [
                              DataCell(Text("${e.content}")),
                            ]))
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }

  Padding _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _contentConroller,
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
                  var data = await _quoteProvider.getPaged(filter: {
                    "bookId": widget.bookId,
                    "content": _contentConroller.text,
                    
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
            width: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                var refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuoteDetailPage(
                      quote: null,
                      bookId: widget.bookId,
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
