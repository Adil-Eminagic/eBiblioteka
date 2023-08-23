import 'package:admin_ebiblioteka/models/quote.dart';
import 'package:admin_ebiblioteka/providers/quotes_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  late QuoteProvider _quoteProvider = QuoteProvider();

  bool isLoading = true;

  @override
  void initState() {
    _quoteProvider = context.read<QuoteProvider>();
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
          ? "${AppLocalizations.of(context).quote_id} ${(widget.quote?.id.toString() ?? '')}"
          : AppLocalizations.of(context).quote_id,
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
                                        title:  Text(AppLocalizations.of(context).quote_del_title),
                                        content:  Text(
                                            AppLocalizations.of(context).quote_del_mes),
                                        actions: [
                                          TextButton(
                                              onPressed: (() {
                                                Navigator.pop(context);
                                              }),
                                              child:  Text(AppLocalizations.of(context).cancel)),
                                          TextButton(
                                              onPressed: () async {
                                                try {
                                                  await _quoteProvider.remove(
                                                      widget.quote?.id ?? 0);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar( SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(context).quote_del_su)));
                                                  Navigator.pop(context);
                                                  Navigator.pop(
                                                      context, 'reload');
                                                } catch (e) {
                                                  alertBoxMoveBack(context,
                                                      AppLocalizations.of(context).error, e.toString());
                                                }
                                              },
                                              child: const Text('Ok')),
                                        ],
                                      ));
                            },
                            child: Text(AppLocalizations.of(context).quote_del_lbl)),
                    widget.quote == null
                        ? Container()
                        : const SizedBox(
                            width: 7,
                          ),
                    ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.save();

                          try {
                            if (_formKey.currentState!.validate()) {
                              if (widget.quote != null) {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['id'] = widget.quote?.id;
                                request['bookId'] = widget.quote?.bookId;

                                await _quoteProvider.update(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context).quote_mod_su)));

                                Navigator.pop(context, 'reload');
                              } else {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['bookId'] = widget.bookId;

                                await _quoteProvider.insert(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content:
                                            Text(AppLocalizations.of(context).quote_add_su)));

                                Navigator.pop(context, 'reload');
                              }
                            }
                          } on Exception catch (e) {
                            alertBox(context, AppLocalizations.of(context).error, e.toString());
                          }
                        },
                        child:  Text(
                          AppLocalizations.of(context).save,
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
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).content)),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
