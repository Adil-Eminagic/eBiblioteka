import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/pages/fromToDo210923Novi.dart';
import 'package:mobile_ebiblioteka/providers/tod210923_provider.dart';
import 'package:mobile_ebiblioteka/providers/user_provider.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/todo210923.dart';
import '../models/user.dart';
import '../utils/util_widgets.dart';

class FrmToDo210923 extends StatefulWidget {
  const FrmToDo210923({Key? key}) : super(key: key);

  @override
  State<FrmToDo210923> createState() => _FrmToDo210923State();
}

class _FrmToDo210923State extends State<FrmToDo210923> {
  late UserProvider _userProvider = UserProvider();
  late ToDo210923Provider _toDo210923Provider = ToDo210923Provider();
  final _formKey = GlobalKey<FormBuilderState>();

  SearchResult<User>? resultUsers;
  SearchResult<ToDo210923>? resultToDo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _toDo210923Provider = context.read<ToDo210923Provider>();

    initData();
  }

  Future<void> initData() async {
    try {
      var userData =
          await _userProvider.getPaged(filter: {'pageSize': 1000000000});
      var toDoData = await _toDo210923Provider.getPaged(filter: {
        'pageSize': 1000000000,
        //'userId': _formKey.currentState?.value['userId']
      });
      if (mounted) {
        setState(() {
          isLoading = false;
          resultUsers = userData;
          resultToDo = toDoData;
        });
      }
    } catch (e) {
      alertBox(context, "Errror", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "To do stavke",
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: isLoading == true
            ? Container()
            : Column(
                children: [
                  _buildSearch(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Korinsik")),
                          DataColumn(label: Text("Naziv")),
                          DataColumn(label: Text("Opis")),
                          DataColumn(label: Text("Datum")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows: resultToDo?.items
                                .map((ToDo210923 e) => DataRow(cells: [
                                      DataCell(Text(
                                          "${e.user?.firstName} ${e.user?.lastName}")),
                                      DataCell(Text("${e.activityName}")),
                                      DataCell(
                                          Text("${e.activityDescription}")),
                                      DataCell(Text(e.finshingDate.toString())),
                                      DataCell(Text("${e.statusCode}")),
                                    ]))
                                .toList() ??
                            [],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Row _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: FormBuilder(
              key: _formKey,
              child: FormBuilderDropdown<String>(
                name: 'userId',
                decoration: InputDecoration(
                  labelText: "Korisnik",
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!
                          .fields['userId'] //brisnje selekcije iz forme
                          ?.reset();
                    },
                  ),
                ),
                items: resultUsers?.items
                        .map((g) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: g.id.toString(),
                              child: Text("${g.firstName} ${g.lastName}"),
                            ))
                        .toList() ??
                    [],
              )),
        ),
        ElevatedButton(
          onPressed: () async {
            var refresh = await Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => FrmToDo210923Novi())));

            if (refresh == "reload") {
              initData();
            }
          },
          child: Text("Dodaj"),
        ),
      
      ],
    );
  }
}
