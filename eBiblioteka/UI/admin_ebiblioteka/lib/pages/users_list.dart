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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
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
        title: widget.roleUser == 'User'
            ? AppLocalizations.of(context).users
            : AppLocalizations.of(context).admins,
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
                        var data = await _userProvider.getPaged(filter: {
                          "fullName": _nameController.text,
                          'roleName': widget.roleUser != null
                              ? '${widget.roleUser}'
                              : '',
                          'isActive': _dropdownValue == 1 ? true : false,
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
            DataColumn(label: Text(AppLocalizations.of(context).name)),
            DataColumn(label: Text(AppLocalizations.of(context).gender)),
            DataColumn(label: Text(AppLocalizations.of(context).birth_date)),
            DataColumn(label: Text(AppLocalizations.of(context).role)),
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
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).name)),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: DropdownButton(
                  items: [
                DropdownMenuItem(
                    value: 0,
                    child: Text(AppLocalizations.of(context).inactive)),
                DropdownMenuItem(
                    value: 1, child: Text(AppLocalizations.of(context).active)),
              ],
                  value: _dropdownValue,
                  onChanged: ((value) {
                    if (value is int) {
                      if (mounted) {
                        setState(() {
                          _dropdownValue = value;
                        });
                      }
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
              child: Text(AppLocalizations.of(context).add)),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
