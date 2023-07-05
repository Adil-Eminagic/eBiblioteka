import 'package:admin_ebiblioteka/detail_pages/author_detail.dart';
import 'package:admin_ebiblioteka/models/author.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/author_provider.dart';
import 'package:admin_ebiblioteka/providers/gender_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  late AuthorProvider _authorProvider;
  late GenderProvider _GenderProvider;

  SearchResult<Author>? result;

  TextEditingController _fullNameController = TextEditingController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _authorProvider = context.read<AuthorProvider>();
    _GenderProvider = context.read<GenderProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Autori",
      child: Column(children: [_buildSearch(), _buildDataTable()]),
    );
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const[
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Spol")),
            DataColumn(label: Text("Datum rođenja"))
          ],
          rows: result?.items
                  .map((Author e) => DataRow(
                          onSelectChanged: (value) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AuthorDetailPage(author: e),
                            ));
                          },
                          cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text(e.fullName ?? '')),
                            DataCell(Text(e.gender?.value ?? '')),
                            DataCell(
                                Text(e.birthDate!=null ? formatDate(e.birthDate!, [dd, '-', mm, '-', yyyy]) : "")
                                        
                                    ),
                          ]))
                  .toList() ??
              [],
        ),
      ),
    );
  }

  Padding _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _fullNameController,
              decoration: InputDecoration(label: Text("Ime")),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _authorProvider
                      .getPaged(filter: {"fullName": _fullNameController.text});

                  setState(() {
                    result = data;
                  });
                } on Exception catch (e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
                }
              },
              child: Text('Dohvati')),
               ElevatedButton(
              onPressed: () async {
                 Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AuthorDetailPage(
                      author: null,
                    ),
                  ),
                );
              },
              child: Text('Dodaj'))
        ],
      ),
    );
  }
}



