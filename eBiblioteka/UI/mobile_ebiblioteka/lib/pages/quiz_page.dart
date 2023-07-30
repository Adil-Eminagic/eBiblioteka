import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/special_pages/start_quiz.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../models/search_result.dart';
import '../providers/quiz_provider.dart';
import '../utils/util_widgets.dart';

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
          filter: {'title': _titleController.text, 'pageSize': 100000,'isActive':true});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Kvizovi',
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
                    decoration: const InputDecoration(label: Text("Naslov")),
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
                          'isActive':true,
                          "pageSize": 100000000
                        });

                        setState(() {
                          result = data;
                        });
                      } on Exception catch (e) {
                        alertBox(context, 'Greška', e.toString());
                      }
                    },
                    child: const Text('Traži')),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          (result == null || result!.items.isEmpty)
              ? const Expanded(
                  child: Center(child: Text('Nema dodanih testova')))
              : (isLoading ? const SpinKitRing(color: Colors.brown) : Expanded(
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
                                    builder: (context) => StartQuizPage(
                                      quiz: result!.items[index],
                                    ),
                                  ),
                                );
                                // if (refresh == 'reload') {
                                //   initData();
                                // }
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
