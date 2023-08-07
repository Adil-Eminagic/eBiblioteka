import 'package:admin_ebiblioteka/detail_pages/quiz_detail.dart';
import 'package:admin_ebiblioteka/models/quiz.dart';
import 'package:admin_ebiblioteka/providers/quiz_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class QuizzesListPage extends StatefulWidget {
  const QuizzesListPage({Key? key}) : super(key: key);

  @override
  State<QuizzesListPage> createState() => _QuizzesListPageState();
}

class _QuizzesListPageState extends State<QuizzesListPage> {
  late QuizProvider _quizProvider = QuizProvider();

  TextEditingController _titleController = TextEditingController();
  bool isLoading = true;

  SearchResult<Quiz>? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    initData();
  }

  Future<void> initData() async {
    try {
      result = await _quizProvider.getPaged(
          filter: {'title': _titleController.text, 'pageSize': 100000});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).quizes,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration:  InputDecoration(label: Text(AppLocalizations.of(context).title)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var data = await _quizProvider.getPaged(filter: {
                          "title": _titleController.text,
                          "pageSize": 100000000
                        });

                        setState(() {
                          result = data;
                        });
                      } on Exception catch (e) {
                        alertBox(context, AppLocalizations.of(context).error, e.toString());
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
                          builder: (context) => const QuizDetailPage(
                            quiz: null,
                          ),
                        ),
                      );
                      if (refresh == 'reload') {
                        initData();
                      }
                    },
                    child:  Text(AppLocalizations.of(context).add)),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          (result == null || result!.items.isEmpty || isLoading==true)
              ?  Expanded(
                  child: Center(child: Text(AppLocalizations.of(context).no_quizzes)))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                    child: ListView.builder(
                      itemCount: result!.items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              subtitle: Text(result!.items[index].description ?? ''),
                              title: Text("${result!.items[index].title}"),
                              leading: Text("${result!.items[index].id}"),
                              onTap: (() async {
                                var refresh = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuizDetailPage(
                                      quiz: result!.items[index],
                                    ),
                                  ),
                                );
                                if (refresh == 'reload') {
                                  initData();
                                }
                              }),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 0.5,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
