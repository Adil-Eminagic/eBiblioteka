import 'package:admin_ebiblioteka/detail_pages/user_detail.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/user_provider.dart';
import 'package:admin_ebiblioteka/utils/util_widgets.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key, this.roleUser}) : super(key: key);
  final String? roleUser;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserProvider _userProvider = UserProvider();
  SearchResult<User>? result;
  bool isLoading = true;
  int _dropdownValue = 1;


  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = context.read<UserProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _userProvider.getPaged(filter: {
        'roleName': widget.roleUser != null ? '${widget.roleUser}' : '',
        "fullName": _nameController.text,
        'isActive': _dropdownValue == 1 ? true : false
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
        title: widget.roleUser == 'User' ? 'Korisnici' : 'Administaratori',
        child: Column(children: [
          _buildSearch(),
          isLoading
              ? const SpinKitRing(color: Colors.brown)
              : _buildDataTable(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isLoading == false && result != null && result!.pageCount > 1)
              for (int i = 0; i < result!.pageCount; i++)
                InkWell(
                    onTap: () async {
                      try {
                        var data = await _userProvider.getPaged(filter: {
                          "fullName": _nameController.text,
                          'roleName': widget.roleUser != null
                              ? '${widget.roleUser}'
                              : '',
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
        ]));
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Spol")),
            DataColumn(label: Text("Datum rođenja")),
            DataColumn(label: Text("Uloga")),
          ],
          rows: result?.items
                  .map((User e) => DataRow(
                          onSelectChanged: (value) async {
                            var refresh = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => UserDetailPage(
                                user: e,
                                roleUser: widget.roleUser,
                              ),
                            ));

                            if (refresh == 'reload') {
                              initTable();
                            }
                          },
                          cells: [
                            DataCell(Text(e.id?.toString() ?? "")),
                            DataCell(Text("${e.firstName} ${e.lastName}")),
                            DataCell(Text(e.gender?.value ?? '')),
                            DataCell(Text(e.birthDate != null
                                ? formatDate(
                                    e.birthDate!, [dd, '-', mm, '-', yyyy])
                                : "")),
                            DataCell(Text(e.role?.value ?? '')),
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
                controller: _nameController,
                decoration: const InputDecoration(label: Text("Ime")),
              ),
            ),
          ),
           const SizedBox(
            width: 15,
          ),
          Expanded(
              child: DropdownButton(
                  items: const [
                DropdownMenuItem(value: 0, child: Text('Neaktivne')),
                DropdownMenuItem(value: 1, child: Text('Aktivne')),
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
                  var data = await _userProvider.getPaged(filter: {
                    'roleName':
                        widget.roleUser != null ? '${widget.roleUser}' : '',
                    "fullName": _nameController.text,
                    'isActive': _dropdownValue == 1 ? true : false
                  });

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
                    builder: (context) => UserDetailPage(
                      user: null,
                      roleUser: widget.roleUser,
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
