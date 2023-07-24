import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/detail_pages/question_detail.dart';
import 'package:mobile_ebiblioteka/models/question.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';

import '../models/quiz.dart';

class StartQuizPage extends StatefulWidget {
  const StartQuizPage({Key? key, this.quiz}) : super(key: key);
  final Quiz? quiz;

  @override
  State<StartQuizPage> createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.quiz!.title ?? '',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => QuestionDeatilPage(
                        quiz: widget.quiz,
                      ))));
                }),
                child:const Text('Započnite kviz')),

          ],
        ),
      ),
    );
  }
}
