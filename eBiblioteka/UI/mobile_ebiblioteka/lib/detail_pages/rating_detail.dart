import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_ebiblioteka/providers/rating_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:mobile_ebiblioteka/utils/util_widgets.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';

import '../models/rating.dart';

class RatingDetailPage extends StatefulWidget {
  const RatingDetailPage({Key? key, this.rating, this.userId, this.bookId})
      : super(key: key);
  final Rating? rating;
  final int? userId;
  final int? bookId;

  @override
  State<RatingDetailPage> createState() => _RatingDetailPageState();
}

class _RatingDetailPageState extends State<RatingDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late RatingProvider _ratingProvider = RatingProvider();

  int num = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.rating != null) {
      num = widget.rating!.stars!;
    }

    _initialValue = {
      'comment': widget.rating?.comment,
    };
    _ratingProvider = context.read<RatingProvider>();

    //initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.rating == null ? 'Nova ocjena' : "Uredi ocjenu")),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
            child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i < 6; i++)
                          InkWell(
                              onTap: (() {
                                setState(() {
                                  num = i;
                                  //Stars.rate = i;
                                });
                              }),
                              child: (num > 0 && i <= num)
                                  ? const Icon(
                                      Icons.star,
                                      size: 50,
                                      color: Colors.yellow,
                                    )
                                  : const Icon(
                                      Icons.star_outline,
                                      size: 50,
                                      color: Colors.yellow,
                                    ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    rowMethod(Expanded(
                        child: FormBuilderTextField(
                      maxLines: 10,
                      name: 'comment',
                      decoration:
                          const InputDecoration(label: Text('Komentar')),
                    ))),
                    const SizedBox(
                      height: 50,
                    ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.rating == null
                        ? Container() : TextButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Brisanje ocjene'),
                                            content: const Text(
                                                'Da li želite obrisati ocjenu'),
                                            actions: [
                                              TextButton(
                                                  onPressed: (() {
                                                    Navigator.pop(context);
                                                  }),
                                                  child: const Text('Poništi')),
                                              TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await _ratingProvider.remove(
                                                          widget.rating?.id ?? 0);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(const SnackBar(
                                                              content: Text(
                                                                  'Uspješno brisanje ocjene.')));
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
                                child: const Text('Obriši ocjenu')),
                        
                    widget.rating == null
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
                              if (widget.rating != null) {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['id'] = widget.rating!.id;
                                request['userId'] = widget.rating!.userId;
                                request['bookId'] = widget.rating!.bookId;
                                request['stars'] = num;

                                request['dateTime'] =
                                    DateTime.now().toIso8601String();

                                var res = await _ratingProvider.update(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Uspješna modifikacija ocjene')));

                                Navigator.pop(context, 'reload');
                              } else {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['userId'] = widget.userId;
                                request['bookId'] = widget.bookId;
                                request['stars'] = num;

                                request['dateTime'] =
                                    DateTime.now().toIso8601String();

                                await _ratingProvider.insert(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Uspješno dodavanje ocjene')));

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
                  ],
                ))),
      ),
    );
  }
}
