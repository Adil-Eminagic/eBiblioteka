import 'package:admin_ebiblioteka/detail_pages/genre_detail.dart';
import 'package:admin_ebiblioteka/models/genre.dart';
import 'package:admin_ebiblioteka/providers/genre_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
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

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genreProvider = context.read<GenreProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data =
          await _genreProvider.getPaged(filter: {"name": _nameController.text});

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
        title: 'Žanrovi',
        child: Column(children: [
          _buildSearch(),
          isLoading ? Container() : _buildDataTable(),
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
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Naziv")),
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
              decoration: const InputDecoration(label: Text("Naziv")),
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

                  setState(() {
                    result = data;
                  });
                } on Exception catch (e) {
                  alertBox(context, 'Greška', e.toString());
                }
              },
              child: const Text('Traži')),
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
              child: const Text('Dodaj')),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
