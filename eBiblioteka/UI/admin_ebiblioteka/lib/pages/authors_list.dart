import '../detail_pages/author_detail.dart';
import '../models/author.dart';
import '../models/search_result.dart';
import '../providers/author_provider.dart';
import '../providers/gender_provider.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AuthorsPage extends StatefulWidget {
  const AuthorsPage({super.key});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  late AuthorProvider _authorProvider;
  late GenderProvider _genderProvider;

  SearchResult<Author>? result;
  bool isLoading = true;

  TextEditingController _fullNameController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authorProvider = context.read<AuthorProvider>();
    _genderProvider = context.read<GenderProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _authorProvider.getPaged(
          filter: {'roleName': 'User', "fullName": _fullNameController.text});

      setState(() {
        result = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).authors,
      child: Column(children: [
        _buildSearch(),
        isLoading ? const SpinKitRing(color: Colors.brown) : _buildDataTable(),
         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isLoading == false && result != null && result!.pageCount > 1)
              for (int i = 0; i < result!.pageCount; i++)
                InkWell(
                    onTap: () async {
                      try {
                        var data = await _authorProvider.getPaged(filter: {
                          "fullName": _fullNameController.text,
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
                      backgroundColor: (i+1== result?.pageNumber) ? Colors.brown : Colors.white,
                      child: Text((i + 1).toString(),
                      style: TextStyle(
                        color: (i+1== result?.pageNumber) ? Colors.white : Colors.brown
                      ),
                      )
                      )),
                    
          ]),
         const SizedBox(
            height: 20,
          )
       ]
       ),
    );
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns:  [
            const DataColumn(label: Text("Id")),
            DataColumn(label: Text(AppLocalizations.of(context).name)),
            DataColumn(label: Text(AppLocalizations.of(context).gender)),
            DataColumn(label: Text(AppLocalizations.of(context).birth_date))
          ],
          rows: result?.items
                  .map((Author e) => DataRow(
                          onSelectChanged: (value) async{
                          var refresh = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  AuthorDetailPage(author: e),
                            ));

                             if (refresh == 'reload') {
                  initTable();
                }
                          },
                          cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text(e.fullName ?? '')),
                            DataCell(Text(e.gender?.value ?? '')),
                            DataCell(Text(e.birthDate != null
                                ? formatDate(
                                    e.birthDate!, [dd, '-', mm, '-', yyyy])
                                : "")),
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
              decoration:  InputDecoration(label: Text(AppLocalizations.of(context).name)),
            ),
          ),
          const SizedBox(
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
              child:  Text(AppLocalizations.of(context).search)),
          const SizedBox(
            width: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                var refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthorDetailPage(
                      author: null,
                    ),
                  ),
                );
                if (refresh == 'reload') {
                  initTable();
                }
              },
              child: Text(AppLocalizations.of(context).add))
        ],
      ),
    );
  }
}
