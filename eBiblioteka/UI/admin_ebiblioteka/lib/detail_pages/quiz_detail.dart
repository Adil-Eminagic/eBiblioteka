import 'package:admin_ebiblioteka/models/quiz.dart';
import 'package:admin_ebiblioteka/pages/question_list.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../utils/util_widgets.dart';

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
    // TODO: implement initState
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
            ? "Kviz Id: ${(widget.quiz?.id.toString() ?? '')}"
            : "Kviz autor",
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
                                                  const Text('Brisanje kviza'),
                                              content: const Text(
                                                  'Da li želite obrisati kviz'),
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
                                                        await _quizProvider
                                                            .remove(widget
                                                                    .quiz?.id ??
                                                                0);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Uspješno brisanje kviza.')));
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
                                  child: const Text('Obriši kviz')),
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
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno mofikovanje kviza')));

                                      Navigator.pop(context, 'reload');
                                    } else {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      await _quizProvider.insert(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno dodavanje kviza')));

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
                name: 'title',
                validator: (value) {
                  if (value == null) {
                    return "Obavezno polje";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(label: Text("Naslov")),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: 'description',
                  maxLines: 3,
                  decoration: const InputDecoration(label: Text("Opis")),
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
                        child: const Text('Uredi pitanja')),
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
