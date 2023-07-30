import 'package:admin_ebiblioteka/detail_pages/answer_detail.dart';
import 'package:admin_ebiblioteka/models/question.dart';
import 'package:admin_ebiblioteka/pages/answer_list.dart';
import 'package:admin_ebiblioteka/providers/answer_provider.dart';
import 'package:admin_ebiblioteka/providers/question_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({Key? key, this.question, this.quizId})
      : super(key: key);
  final Question? question;
  final int? quizId;

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late QuestionProvider _questionProvider = QuestionProvider();
  late AnswerProvider _answerProvider = AnswerProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'content': widget.question?.content,
      'points': widget.question?.points.toString()
    };
    _questionProvider = context.read<QuestionProvider>();
    
  }

  @override
  Widget build(BuildContext context) {
    _answerProvider = context.watch<AnswerProvider>();
    return MasterScreenWidget(
        title: widget.question != null
            ? "Pitanje Id: ${(widget.question?.id.toString() ?? '')}"
            : "Novo pitanje",
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 20, 65, 100),
            child: Column(
              children: [
                _buildForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          widget.question == null
                              ? Container()
                              : TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  'Brisanje pitanja'),
                                              content: const Text(
                                                  'Da li želite obrisati pitanje'),
                                              actions: [
                                                TextButton(
                                                    onPressed: (() {
                                                      Navigator.pop(context);
                                                    }),
                                                    child:
                                                        const Text('Poništi')),
                                                TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await _questionProvider
                                                            .remove(widget
                                                                    .question
                                                                    ?.id ??
                                                                0);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Uspješno brisanje pitanja.')));
                                                        Navigator.pop(context);
                                                        Navigator.pop(
                                                            context, 'reload');
                                                      } catch (e) {
                                                        alertBoxMoveBack(
                                                            context,
                                                            'Greška',
                                                            e.toString());
                                                      }
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                            ));
                                  },
                                  child: const Text('Obriši pitanje')),
                          widget.question == null
                              ? Container()
                              : const SizedBox(
                                  width: 7,
                                ),
                          ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();

                                try {
                                  if (_formKey.currentState!.validate()) {
                                    if (widget.question != null) {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      request['id'] = widget.question?.id;

                                      request['points'] = int.parse(_formKey
                                          .currentState?.value['points']);

                                      request['quizId'] = widget.quizId;

                                      var res = await _questionProvider
                                          .update(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno mofikovanje kviza')));

                                      Navigator.pop(context, 'reload');
                                    } else {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      request['points'] = int.parse(_formKey
                                          .currentState?.value['points']);
                                      request['quizId'] = widget.quizId;

                                      await _questionProvider.insert(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno dodavanje pitnja')));

                                      Navigator.pop(context, 'reload');
                                    }
                                  }
                                } on Exception catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(
                                              e.toString(),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ok'))
                                            ],
                                          ));
                                }
                              },
                              child: const Text(
                                "Sačuvaj",
                                style: TextStyle(fontSize: 15),
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'content',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Obavezno polje";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(label: Text("Sadržaj")),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: 'points',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'obavezno polje';
                      //}
                    } else if (int.tryParse(value) == null) {
                      return 'vrijedopst mora biti numerička';
                    }
                  },
                  decoration: const InputDecoration(label: Text("Bodovi")),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          widget.question == null
              ? Container()
              : Row(
                  children: [
                    // Column(
                    //   children: [
                    //     Switch(
                    //       value: widget.question!.isActive!,
                    //       activeColor: Colors.brown,
                    //       onChanged: (bool value) {},
                    //     ),
                    //     widget.question!.isActive! == true
                    //         ? const Text('Aktvno pitanje')
                    //         : const Text('Nekativno pitanje'),
                    //     const SizedBox(
                    //       height: 10,
                    //     ),
                    //     widget.question!.isActive! == false
                    //         ? const Text(
                    //             'Minimalno 2 dva odgovora,\njedan i samo jedan tačan\ni jedan ili više netačnih odgovora.',
                    //             style: TextStyle(color: Colors.red),
                    //           )
                    //         : Container()
                    //   ],
                    // ),
                    // const SizedBox(
                    //   width: 40,
                    // ),
                    ElevatedButton(
                        onPressed: () async {
                          var refresh = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AnswersListPage(
                                        questionId: widget.question!.id!,
                                      )));

                          // if (refresh == 'reload2') {
                          //   inittt();
                          // }
                        },
                        child: const Text('Uredi odgovore')),
                  ],
                ),
                 const SizedBox(
            height: 30,
          ),
          widget.question == null
              ? Container()
              : Row(
                  children: const [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                            'Napomena: Da bi pitanje bilo aktivno mora imati jedan\ni samo jedan tačan odgovor i jedan ili više netačnih odgovora.'),
                      ),
                    )
                  ],
                ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
