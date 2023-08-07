import 'package:admin_ebiblioteka/detail_pages/answer_detail.dart';
import 'package:admin_ebiblioteka/models/answer.dart';
import 'package:admin_ebiblioteka/providers/answer_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AnswersListPage extends StatefulWidget {
  const AnswersListPage({Key? key, this.questionId}) : super(key: key);
  final int? questionId;

  @override
  State<AnswersListPage> createState() => _AnswesrListPageState();
}

class _AnswesrListPageState extends State<AnswersListPage> {
  late AnswerProvider _questionProvider = AnswerProvider();
  SearchResult<Answer>? result;
  final TextEditingController _contentConroller = TextEditingController();

  bool isLoading = true;
  int _dropdownValue = 0;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<AnswerProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _questionProvider.getPaged(filter: {
        "questionId": widget.questionId,
        "content": _contentConroller.text,
        'isTrue':
            _dropdownValue == 0 ? null : (_dropdownValue == 1 ? false : true),
      });

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
      title: AppLocalizations.of(context).answers,
      child: Column(children: [
        _buildSearch(),
        isLoading ? Container() : _buildDataTable(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (isLoading == false && result != null && result!.pageCount > 1)
            for (int i = 0; i < result!.pageCount; i++)
              InkWell(
                  onTap: () async {
                    try {
                      var data = await _questionProvider.getPaged(filter: {
                        "questionId": widget.questionId,
                        "content": _contentConroller.text,
                        'isTrue': _dropdownValue == 0
                            ? null
                            : (_dropdownValue == 1 ? false : true),
                        'pageNumber': i + 1
                      });

                      setState(() {
                        result = data;
                      });
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
      ]),
    );
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
          child: DataTable(
            columns:  [
              DataColumn(label: Text(AppLocalizations.of(context).content)),
              DataColumn(label: Text(AppLocalizations.of(context).is_true)),
            ],
            rows: result?.items
                    .map((Answer e) => DataRow(
                            onSelectChanged: (value) async {
                              var refresh = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => AnswerDetailPage(
                                  answer: e,
                                  questionId: widget.questionId,
                                ),
                              ));

                              if (refresh == 'reload') {
                                initTable();
                              }
                            },
                            cells: [
                              DataCell(Text("${e.content}")),
                              DataCell(Text("${e.isTrue}")),
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
                controller: _contentConroller,
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).name_2)),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: DropdownButton(
            items:  [
              DropdownMenuItem(value: 0, child: Text(AppLocalizations.of(context).all)),
              DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context).false_val)),
              DropdownMenuItem(value: 2, child: Text(AppLocalizations.of(context).true_val)),
            ],
            value: _dropdownValue,
            onChanged: ((value) {
              if (value is int) {
                setState(() {
                  _dropdownValue = value;
                });
              }
            }),
          )),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  var data = await _questionProvider.getPaged(filter: {
                    "questionId": widget.questionId,
                    "content": _contentConroller.text,
                    'isTrue': _dropdownValue == 0
                        ? null
                        : (_dropdownValue == 1 ? false : true),
                  });

                  setState(() {
                    result = data;
                  });
                } on Exception catch (e) {
                  alertBox(context, AppLocalizations.of(context).error, e.toString());
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
                    builder: (context) => AnswerDetailPage(
                      answer: null,
                      questionId: widget.questionId,
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
