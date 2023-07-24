import 'package:admin_ebiblioteka/models/quote.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/quotes_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/util_widgets.dart';

class QuoteDetailPage extends StatefulWidget {
  const QuoteDetailPage({Key? key, this.quote, this.bookId}) : super(key: key);
  final Quote? quote;
  final int? bookId;

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  QuoteProvider _quoteProvider = QuoteProvider();

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'id': widget.quote?.id.toString(),
      'content': widget.quote?.content.toString(),
      'bookId': widget.quote?.bookId
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.quote != null
          ? "Citat Id: ${(widget.quote?.id.toString() ?? '')}"
          : "Novi citat",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
          child: Column(
            children: [
              _buildForm(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.quote == null
                        ? Container()
                        : TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Brisanje citata'),
                                        content: const Text(
                                            'Da li želite obrisati citat'),
                                        actions: [
                                          TextButton(
                                              onPressed: (() {
                                                Navigator.pop(context);
                                              }),
                                              child: const Text('Poništi')),
                                          TextButton(
                                              onPressed: () async {
                                                try {
                                                  await _quoteProvider.remove(
                                                      widget.quote?.id ?? 0);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Uspješno brisanje citata knjige')));
                                                  Navigator.pop(context);
                                                  Navigator.pop(
                                                      context, 'reload');
                                                } catch (e) {
                                                  alertBoxMoveBack(context,
                                                      'Greška', e.toString());
                                                }
                                              },
                                              child: const Text('Ok')),
                                        ],
                                      ));
                            },
                            child: const Text('Obriši citat')),
                    widget.quote == null
                        ? Container()
                        : const SizedBox(
                            width: 7,
                          ),
                  
                        ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState?.save();
                              print(_formKey.currentState?.value);

                              try {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.quote != null) {
                                    Map<String, dynamic> request =
                                        Map.of(_formKey.currentState!.value);

                                    request['id'] = widget.quote?.id;
                                    request['bookId'] = widget.quote?.bookId;

                                    await _quoteProvider.update(request);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Uspješna modifikovanje citata')));

                                    Navigator.pop(context, 'reload');
                                  } else {
                                    Map<String, dynamic> request =
                                        Map.of(_formKey.currentState!.value);

                                    request['bookId'] = widget.bookId;

                                    await _quoteProvider.insert(request);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Uspješna dodavanje citata')));

                                    Navigator.pop(context, 'reload');
                                  }
                                }
                              } on Exception catch (e) {
                                alertBox(context, 'Greška', e.toString());
                              }
                            },
                            child: const Text(
                              "Sačuvaj",
                              style: TextStyle(fontSize: 15),
                            )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
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
                decoration: const InputDecoration(label: Text('Sadržaj')),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
