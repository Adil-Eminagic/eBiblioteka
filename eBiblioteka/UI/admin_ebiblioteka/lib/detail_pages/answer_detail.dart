import 'package:admin_ebiblioteka/models/answer.dart';
import 'package:admin_ebiblioteka/providers/answer_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';


class AnswerDetailPage extends StatefulWidget {
  const AnswerDetailPage({Key? key, this.answer, this.questionId}) : super(key: key);
  final Answer? answer;
  final int? questionId;

  @override
  State<AnswerDetailPage> createState() => _AnswerDetailPageState();
}

class _AnswerDetailPageState extends State<AnswerDetailPage> {
 final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AnswerProvider _answerProvider = AnswerProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'content': widget.answer?.content,
      'isTrue': widget.answer?.isTrue ?? false
    };
    _answerProvider = context.read<AnswerProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.answer != null
          ? "Odgovor Id: ${(widget.answer?.id.toString() ?? '')}"
          : "Novi odgovor",
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
                          widget.answer == null
                              ? Container()
                              : TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  'Brisanje odgovora'),
                                              content: const Text(
                                                  'Da li želite obrisati odgovor'),
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
                                                        await _answerProvider
                                                            .remove(widget
                                                                    .answer
                                                                    ?.id ??
                                                                0);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Uspješno brisanje odgovora.')));
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
                                  child: const Text('Obriši odgovor')),
                          widget.answer == null
                              ? Container()
                              : const SizedBox(
                                  width: 7,
                                ),
                          ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();

                                try {
                                  if (_formKey.currentState!.validate()) {
                                    if (widget.answer != null) {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      request['id'] = widget.answer?.id;

                                      request['questionId'] = widget.questionId;

                                      var res = await _answerProvider
                                          .update(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno mofikovanje odgovora')));

                                      Navigator.pop(context, 'reload');
                                    } else {
                                      Map<String, dynamic> request =
                                          Map.of(_formKey.currentState!.value);

                                      request['questionId'] = widget.questionId;

                                      await _answerProvider.insert(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Uspješno dodavanje odgovora')));

                                      Navigator.pop(context, 'reloadQ');
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
                child: FormBuilderCheckbox(
                  name: 'isTrue',
                 title: const Text('Da li je tačno'),
                  decoration: const InputDecoration(label: Text("Tačno")),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
         
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
