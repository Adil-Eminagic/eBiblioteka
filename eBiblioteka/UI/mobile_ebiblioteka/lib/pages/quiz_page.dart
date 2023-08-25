import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/pages/quizresult_list.dart';
import 'package:mobile_ebiblioteka/special_pages/start_quiz.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../models/search_result.dart';
import '../providers/quiz_provider.dart';
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
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    initData();
  }

  Future<void> initData() async {
    try {
      result = await _quizProvider.getPaged(filter: {
        'title': _titleController.text,
        'pageSize': 100000,
        'isActive': true
      });
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
            padding: const EdgeInsets.fromLTRB(43, 0, 43, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const QuizResultListPage()));
                    }),
                    child: Text(AppLocalizations.of(context).results))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 50),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).title)),
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
                          'isActive': true,
                          "pageSize": 100000000
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
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          (result == null || result!.items.isEmpty)
              ? Expanded(
                  child: Center(
                      child: Text(AppLocalizations.of(context).no_quizzes)))
              : (isLoading
                  ? const SpinKitRing(color: Colors.brown)
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                        child: ListView.builder(
                          itemCount: result!.items.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  subtitle: Text(
                                      result!.items[index].description ?? ''),
                                  title: Text("${result!.items[index].title}"),
                                  leading: Text("${result!.items[index].id}"),
                                  onTap: (() async {
                                    var refresh =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StartQuizPage(
                                          quiz: result!.items[index],
                                        ),
                                      ),
                                    );
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
                    ))
        ],
      ),
    );
  }
}
