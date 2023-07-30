import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/models/question.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/providers/question_provider.dart';
import 'package:mobile_ebiblioteka/special_pages/quiz_result.dart';
import 'package:provider/provider.dart';

import '../models/answer.dart';
import '../models/quiz.dart';
import '../providers/answer_provider.dart';
import '../utils/util_widgets.dart';

class QuestionDeatilPage extends StatefulWidget {
  const QuestionDeatilPage({Key? key, this.quiz}) : super(key: key);
  final Quiz? quiz;

  @override
  State<QuestionDeatilPage> createState() => _QuestionDeatilPageState();
}

List<int> options = [1, 2, 3, 4, 5, 6];

class _QuestionDeatilPageState extends State<QuestionDeatilPage> {
  late QuestionProvider _questionProvider = QuestionProvider();
  late AnswerProvider _answerProvider = AnswerProvider();

  SearchResult<Question>? result;
  SearchResult<Answer>? answerResult;

  int count = 0;
  bool isLoading = true;
  int points = 0;
  int currentOption = 0;
  Answer? selectAnswer;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
    _answerProvider = context.read<AnswerProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      result =
          await _questionProvider.getPaged(filter: {'quizId': widget.quiz!.id});
      answerResult = await _answerProvider
          .getPaged(filter: {'questionId': result!.items[count].id});

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pitanje broj ${count + 1}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Napuštanje kviza'),
                      content: const Text('Da li želite napustiti kviz.\n Rezultati će se izbrisati.'),
                      actions: [
                        TextButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            child: const Text('Poništi')),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                            },
                            child: const Text('Ok')),
                      ],
                    ));
          }),
        ),
      ),
      body: isLoading
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    result!.items[count].content!,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: [
                  //     count > 0
                  //         ? IconButton(
                  //             onPressed: (() {
                  //               setState(() {
                  //                 count -= 1;
                  //                 isLoading = true;
                  //                 currentOption = 0;
                  //               });
                  //               initData();
                  //             }),
                  //             icon: Icon(Icons.arrow_back))
                  //         : Container(),
                  //     Expanded(child: Container()),
                  //     (count + 1) < result!.items.length
                  //         ? IconButton(
                  //             onPressed: (() {
                  //               setState(() {
                  //                 count += 1;
                  //                 currentOption = 0;
                  //                 isLoading = true;
                  //               });
                  //               initData();
                  //             }),
                  //             icon: Icon(Icons.arrow_forward))
                  //         : Container()
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 3,
                  ),
                  for (int i = 0; i < answerResult!.items.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(answerResult!.items[i].content ?? ''),
                            trailing: Radio<int>(
                              value: options[i],
                              groupValue: currentOption,
                              onChanged: (int? value) {
                                setState(() {
                                  currentOption = value!;
                                });
                              },
                            ),
                          ),
                          const Divider(thickness: 3),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (count + 1) == result!.items.length
                          ? ElevatedButton(
                              onPressed: (() {
                                if (answerResult!
                                        .items[currentOption - 1].isTrue! ==
                                    true) {
                                  points += result!.items[count].points!;
                                  print(points);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => QuizResultPage(
                                        totalPoint: widget.quiz!.totalPoints,
                                        wonPoints: points,
                                      ),
                                    ),
                                  );
                                } else if (currentOption == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Morate odabrati odgovor')));
                                } else {
                                  print(points);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => QuizResultPage(
                                        totalPoint: widget.quiz!.totalPoints,
                                        wonPoints: points,
                                      ),
                                    ),
                                  );
                                }
                              }),
                              child: Text('Završi test'))
                          : ElevatedButton(
                              onPressed: (() {
                                if (currentOption != 0 &&
                                    answerResult!
                                            .items[currentOption - 1].isTrue! ==
                                        true) {
                                  points += result!.items[count].points!;
                                  print(points);
                                  setState(() {
                                    count += 1;
                                    currentOption = 0;
                                    isLoading = true;
                                  });
                                  initData();
                                } else if (currentOption == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Morate odabrati odgovor')));
                                } else {
                                  print(points);
                                  setState(() {
                                    count += 1;
                                    currentOption = 0;
                                    isLoading = true;
                                  });
                                  initData();
                                }
                              }),
                              child: Text('Sljedeće pitanje')),
                      const SizedBox(
                        width: 25,
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
