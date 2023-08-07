import 'package:admin_ebiblioteka/models/quiz.dart';
import 'package:admin_ebiblioteka/pages/question_list.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class QuizDetailPage extends StatefulWidget {
  const QuizDetailPage({Key? key, this.quiz}) : super(key: key);
  final Quiz? quiz;

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late QuizProvider _quizProvider = QuizProvider();

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'title': widget.quiz?.title,
      'description': widget.quiz?.description
    };
    _quizProvider = context.read<QuizProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.quiz != null
            ? "${AppLocalizations.of(context).quiz_id} ${(widget.quiz?.id.toString() ?? '')}"
            : AppLocalizations.of(context).quiz_new,
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
                          widget.quiz == null
                              ? Container()
                              : TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                   Text(AppLocalizations.of(context).quiz_del_title),
                                              content: Text(
                                                  AppLocalizations.of(context).quiz_del_mes),
                                              actions: [
                                                TextButton(
                                                    onPressed: (() {
                                                      Navigator.pop(context);
                                                    }),
                                                    child:
                                                         Text(AppLocalizations.of(context).cancel)),
                                                TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await _quizProvider
                                                            .remove(widget
                                                                    .quiz?.id ??
                                                                0);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                 SnackBar(
                                                                    content: Text(
                                                                        AppLocalizations.of(context).quiz_del_su)));
                                                        Navigator.pop(context);
                                                        Navigator.pop(
                                                            context, 'reload');
                                                      } catch (e) {
                                                        alertBoxMoveBack(
                                                            context,
                                                            AppLocalizations.of(context).error,
                                                            e.toString());
                                                      }
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                            ));
                                  },
                                  child: Text(AppLocalizations.of(context).quiz_del_lbl)),
                          widget.quiz == null
                              ? Container()
                              : const SizedBox(
                                  width: 7,
                                ),
                          ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();

                                try {
                                  if (_formKey.currentState!.validate()) {
                                    if (widget.quiz != null) {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      request['id'] = widget.quiz?.id;

                                      var res =
                                          await _quizProvider.update(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar( SnackBar(
                                              content: Text(
                                                 AppLocalizations.of(context).quiz_mod_su)));

                                      Navigator.pop(context, 'reload');
                                    } else {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      await _quizProvider.insert(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar( SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context).quiz_add_su)));

                                      Navigator.pop(context, 'reload');
                                    }
                                  }
                                } on Exception catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title:  Text(AppLocalizations.of(context).error),
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
                              child:  Text(
                               AppLocalizations.of(context).save,
                                style: const TextStyle(fontSize: 15),
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
                name: 'title',
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).title)),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: 'description',
                  maxLines: 3,
                  decoration:  InputDecoration(label: Text(AppLocalizations.of(context).description)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          widget.quiz == null
              ? Container()
              : Row(
                  children: [
                    //  Column(
                    //         children: [
                    //           Switch(
                    //             value: widget.quiz!.isActive!,
                    //             activeColor: Colors.brown,
                    //             onChanged: (bool value) {},
                    //           ),
                    //           widget.quiz!.isActive! == true
                    //               ? const Text('Aktvan kviz')
                    //               : const Text('Nekativan kviz'),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           widget.quiz!.isActive! == false
                    //               ? const Text(
                    //                   'Minimalno jedno pitanje i svako pitanje mora biti aktivno',
                    //                   style: TextStyle(color: Colors.red),
                    //                 )
                    //               : Container()
                    //         ],
                    //       ),
                    //        const SizedBox(
                    //         width: 40,
                    //       ),
                    ElevatedButton(
                        onPressed: () async {
                          var refresh = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => QuestionsListPage(
                                        quizId: widget.quiz!.id!,
                                      )));

                          // if (refresh == 'reload2') {
                          //   inittt();
                          // }
                        },
                        child: Text(AppLocalizations.of(context).quiz_questions)),
                  ],
                ),
          const SizedBox(
            height: 30,
          ),
          widget.quiz == null
              ? Container()
              : Row(
                  children:  [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                            AppLocalizations.of(context).quiz_rule),
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
