import 'package:admin_ebiblioteka/detail_pages/genre_detail.dart';
import 'package:admin_ebiblioteka/models/genre.dart';
import 'package:admin_ebiblioteka/providers/genre_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/search_result.dart';
import '../utils/util_widgets.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  late GenreProvider _genreProvider = GenreProvider();
  SearchResult<Genre>? result;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _genreProvider = context.read<GenreProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data =
          await _genreProvider.getPaged(filter: {"name": _nameController.text});

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
        title: AppLocalizations.of(context).genres,
        child: Column(children: [
          _buildSearch(),
          isLoading ? Container() : _buildDataTable(),
          isLoading == false && result != null && result!.pageCount > 1
              ? const SizedBox(
                  height: 20,
                )
              : Container(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isLoading == false && result != null && result!.pageCount > 1)
              for (int i = 0; i < result!.pageCount; i++)
                InkWell(
                    onTap: () async {
                      try {
                        var data = await _genreProvider.getPaged(filter: {
                          "name": _nameController.text,
                          'pageNumber': i + 1
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
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            const DataColumn(label: Text("Id")),
            DataColumn(label: Text(AppLocalizations.of(context).name_2)),
          ],
          rows: result?.items
                  .map((Genre e) => DataRow(
                          onSelectChanged: (value) async {
                            var refresh = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => GenreDetailPage(genre: e),
                            ));

                            if (refresh == 'reload') {
                              initTable();
                            }
                          },
                          cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text("${e.name}")),
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
                  var data = await _genreProvider
                      .getPaged(filter: {"name": _nameController.text});

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
                    builder: (context) => const GenreDetailPage(
                      genre: null,
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
