import 'package:admin_ebiblioteka/models/genre.dart';
import 'package:admin_ebiblioteka/providers/genre_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

class GenreDetailPage extends StatefulWidget {
  const GenreDetailPage({Key? key, this.genre}) : super(key: key);
  final Genre? genre;

  @override
  State<GenreDetailPage> createState() => _GenreDetailPageState();
}

class _GenreDetailPageState extends State<GenreDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GenreProvider _genreProvider = GenreProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'id': widget.genre?.id.toString(),
      'name': widget.genre?.name.toString()
    };

    _genreProvider = context.read<GenreProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.genre==null ? 'Novi žanr' : "Žanr Id: ${widget.genre?.id}",
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
            child: Column(
              children: [
                 _buildForm(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.genre == null
                          ? Container()
                          : TextButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title:
                                              const Text('Brisanje žanra'),
                                          content: const Text(
                                              'Da li želite obrisati žanr'),
                                          actions: [
                                            TextButton(
                                                onPressed: (() {
                                                  Navigator.pop(context);
                                                }),
                                                child: const Text('Poništi')),
                                            TextButton(
                                                onPressed: () async {
                                                  try {
                                                    await _genreProvider.remove(
                                                        widget.genre?.id ?? 0);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Uspješno brisanje žanra')));
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
                              child: const Text('Obriši žanr')),
                      widget.genre == null
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
                                if (widget.genre != null) {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['id'] = widget.genre?.id;
                                  

                                  var res = await _genreProvider.update(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješna modifikacija žanra')));

                                  Navigator.pop(context, 'reload');
                                } else {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  await _genreProvider.insert(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješna dodavanje žanra')));

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
              textField('name', 'Naziv'),
            ],
          ),
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    );
  }

  Expanded textField(String name, String label) {
    return Expanded(
        child: FormBuilderTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Obavezno polje";
        } else {
          return null;
        }
      },
      name: name,
      decoration: InputDecoration(label: Text(label)),
    ));
  }

}
