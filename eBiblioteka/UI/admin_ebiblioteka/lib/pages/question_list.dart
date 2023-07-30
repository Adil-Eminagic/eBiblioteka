import 'package:admin_ebiblioteka/detail_pages/question_detail.dart';
import 'package:admin_ebiblioteka/models/question.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/question_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

class QuestionsListPage extends StatefulWidget {
  const QuestionsListPage({Key? key, this.quizId}) : super(key: key);
  final int? quizId;

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  late QuestionProvider _questionProvider = QuestionProvider();
  SearchResult<Question>? result;
  final TextEditingController _contentConroller = TextEditingController();


  bool isLoading = true;
  int _dropdownValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionProvider = context.read<QuestionProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      var data = await _questionProvider.getPaged(
          filter: {"quizId": widget.quizId, "content": _contentConroller.text,'points':_dropdownValue > 0 ? _dropdownValue : null });

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
      title: 'Pitanja',
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
                        "content": _contentConroller.text,
                        "quizId": widget.quizId,
                        "points": _dropdownValue > 0 ? _dropdownValue : null,
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
      ]),
    );
  }

  Expanded _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Sadržaj")),
              DataColumn(label: Text("Bodovi")),
            ],
            rows: result?.items
                    .map((Question e) => DataRow(
                            onSelectChanged: (value) async {
                              var refresh = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => QuestionDetailPage(
                                  question: e,
                                  quizId: widget.quizId,
                                ),
                              ));

                              if (refresh == 'reload') {
                                initTable();
                              }
                            },
                            cells: [
                              DataCell(Text("${e.content}")),
                              DataCell(Text("${e.points}")),
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
                decoration: const InputDecoration(label: Text("Naziv")),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: DropdownButton(
            items: const [
              DropdownMenuItem(value: 0, child: Text('Broj bodova')),
              DropdownMenuItem(value: 1, child: Text('1')),
              DropdownMenuItem(value: 2, child: Text('2')),
              DropdownMenuItem(value: 3, child: Text('3')),
              DropdownMenuItem(value: 4, child: Text('4')),
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
                    "quizId": widget.quizId,
                    "content": _contentConroller.text,
                    "points": _dropdownValue > 0 ? _dropdownValue : null
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
                    builder: (context) =>  QuestionDetailPage(
                      question: null,
                      quizId: widget.quizId,
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
