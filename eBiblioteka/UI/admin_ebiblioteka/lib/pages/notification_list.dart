import 'package:admin_ebiblioteka/detail_pages/notification_detail.dart';
import 'package:admin_ebiblioteka/models/notification.dart';
import 'package:date_format/date_format.dart';

import '../providers/notification_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../utils/util_widgets.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({Key? key}) : super(key: key);

  @override
  State<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  late NotificationProvider _notificationProvider = NotificationProvider();
  SearchResult<Notif>? result;
  final TextEditingController _titleConroller = TextEditingController();

  bool isLoading = true;
  int _dropdownValue = 0;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _notificationProvider.getPaged(filter: {
        "userId": int.parse(Autentification.tokenDecoded!["Id"]),
        "title": _titleConroller.text,
        "isRead":
            _dropdownValue == 0 ? null : (_dropdownValue == 1 ? false : true)
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
      title: AppLocalizations.of(context).notifications,
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
                      var data = await _notificationProvider.getPaged(filter: {
                        "userId":
                            int.parse(Autentification.tokenDecoded!["Id"]),
                        "title": _titleConroller.text,
                        'isTrue': _dropdownValue == 0
                            ? null
                            : (_dropdownValue == 1 ? false : true),
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
              const DataColumn(label: Text("Id")),
              DataColumn(label: Text(AppLocalizations.of(context).content)),
              DataColumn(label: Text(AppLocalizations.of(context).is_read)),
              DataColumn(label: Text(AppLocalizations.of(context).date)),
            ],
            rows: result?.items
                    .map((Notif e) => DataRow(
                            onSelectChanged: (value) async {
                              if (e.isRead == false) {
                                try {
                                  await _notificationProvider
                                      .readNotfication(e.id!);
                                  if (mounted) {
                                    setState(() {
                                      isLoading = true;
                                      initTable();
                                    });
                                  }
                                } on Exception catch (e) {
                                  alertBox(
                                      context,
                                      AppLocalizations.of(context).error,
                                      e.toString());
                                }
                              }
                              var refresh = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => NotificationDetailPage(
                                  notif: e,
                                ),
                              ));

                              if (refresh == 'reload') {
                                // if you cahnge enitity when you return to lista page it will be cahnged data there
                                initTable();
                              }
                            },
                            cells: [
                              DataCell(Text("${e.id}")),
                              DataCell(Text("${e.title}")),
                              DataCell(Container(
                                  padding: const EdgeInsets.all(2),
                                  color: e.isRead == true
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    "${e.isRead}",
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                              DataCell(Text(e.createdAt != null
                                  ? formatDate(e.createdAt!, [
                                      dd,
                                      '-',
                                      mm,
                                      '-',
                                      yyyy,
                                      ' ',
                                      HH,
                                    ])
                                  : "")),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleConroller,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).name_2)),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: DropdownButton(
            items: [
              DropdownMenuItem(
                  value: 0, child: Text(AppLocalizations.of(context).all)),
              DropdownMenuItem(
                  value: 1,
                  child: Text(AppLocalizations.of(context).is_unread)),
              DropdownMenuItem(
                  value: 2, child: Text(AppLocalizations.of(context).is_read)),
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
            }),
          )),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _notificationProvider.getPaged(filter: {
                    "userId": int.parse(Autentification.tokenDecoded!["Id"]),
                    'title': _titleConroller.text,
                    'isRead': _dropdownValue == 0
                        ? null
                        : (_dropdownValue == 1 ? false : true),
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
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
