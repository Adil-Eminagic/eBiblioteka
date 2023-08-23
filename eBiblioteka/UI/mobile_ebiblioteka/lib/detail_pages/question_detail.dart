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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionDeatilPage extends StatefulWidget {
  const QuestionDeatilPage({Key? key, this.quiz}) : super(key: key);
  final Quiz? quiz;

  @override
  State<QuestionDeatilPage> createState() => _QuestionDeatilPageState();
}

List<int> options = List.generate(1000000, (index) => index + 1);


class _QuestionDeatilPageState extends State<QuestionDeatilPage> {
  late QuestionProvider _questionProvider = QuestionProvider();
  late AnswerProvider _answerProvider = AnswerProvider();

  SearchResult<Question>? result;
  SearchResult<Answer>? answerResult;

  int count = 0; //navigation through questions
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
      result = await _questionProvider.getPaged(
          filter: {'quizId': widget.quiz!.id}); //loading all questions for quiz
      answerResult = await _answerProvider.getPaged(filter: {
        'questionId': result!.items[count].id
      }); //loading all answers for current question, starts with first because count is initally 0

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${AppLocalizations.of(context).question_num} ${count + 1}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).leave_quiz_tit),
                      content:
                          Text(AppLocalizations.of(context).leave_quiz_msg),
                      actions: [
                        TextButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            child: Text(AppLocalizations.of(context).cancel)),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context); //escape alertbox
                              Navigator.pop(context); //escape quizdetail page
                              Navigator.pop(context); //escape startquizpage
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
                  for (int i = 0;
                      i < answerResult!.items.length;
                      i++) //printing all answers of certain question
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(answerResult!.items[i].content ?? ''),
                            trailing: Radio<int>(
                              value: options[i],//list of options, starts with 1, not 0, but i is 0 here which means frist element of optiosn which is one
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
                      (count + 1) == result!.items.length//if lenght is 3 lat element has index 2, so if count+1 == 3 it means it is last question of quiz and we cann't go on next question
                          ? ElevatedButton(
                              onPressed: (() {
                                if (answerResult!
                                        .items[currentOption - 1].isTrue! ==
                                    true) {//ifanswer is true add points of that question for overall points 
                                  points += result!.items[count].points!;
                                  print(points);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => QuizResultPage(//and then go to result page
                                        totalPoint: widget.quiz!.totalPoints,
                                        wonPoints: points,
                                        quizId: widget.quiz!.id,
                                      ),
                                    ),
                                  );
                                } else if (currentOption == 0) {//if user didn't select answer force him to do it
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration:const Duration(seconds: 2),
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .manswer)));
                                } else {
                                  print(points);
                                  Navigator.of(context).push(//just in case
                                    MaterialPageRoute(
                                      builder: (context) => QuizResultPage(
                                        totalPoint: widget.quiz!.totalPoints,
                                        wonPoints: points,
                                        quizId: widget.quiz!.id,
                                      ),
                                    ),
                                  );
                                }
                              }),
                              child: Text(
                                  AppLocalizations.of(context).finish_quiz))
                          : ElevatedButton(//this is else, when curent+1!=lenght, when it isn't last question
                              onPressed: (() {
                                if (currentOption != 0 &&
                                    answerResult!
                                            .items[currentOption - 1].isTrue! ==
                                        true) { //if user selected answer, and if answer is true true answer and 
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
                                      SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .manswer)));
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
                              child: Text(
                                  AppLocalizations.of(context).next_question)),
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
