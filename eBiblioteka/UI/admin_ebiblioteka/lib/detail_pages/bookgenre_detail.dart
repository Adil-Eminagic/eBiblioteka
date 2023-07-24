import 'package:admin_ebiblioteka/models/book.dart';
import 'package:admin_ebiblioteka/models/bookgenre.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/genre_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/genre.dart';
import '../providers/bookgenre_provider.dart';
import '../utils/util_widgets.dart';

class BookGenreDetailPage extends StatefulWidget {
  const BookGenreDetailPage({Key? key, this.bookGenre, this.book})
      : super(key: key);
  final BookGenre? bookGenre;
  final Book? book;

  @override
  State<BookGenreDetailPage> createState() => _BookGenreDetailPageState();
}

class _BookGenreDetailPageState extends State<BookGenreDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();
  late GenreProvider _genreProvider = GenreProvider();

  SearchResult<Genre>? genresResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {'genreId': widget.bookGenre?.genre?.id.toString()};

    _bookGenreProvider = context.read<BookGenreProvider>();
    _genreProvider = context.read<GenreProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      genresResult = await _genreProvider.getPaged();

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.bookGenre == null
          ? "Dodavanje žanra za knjigu"
          : "Knjiga ${widget.bookGenre?.book?.title}, žanr ${widget.bookGenre?.genre?.name}",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
          child: Column(
            children: [
               isLoading ? const SpinKitRing(color: Colors.brown) : _buildForm(),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.bookGenre == null
                        ? Container()
                        : TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Brisanje žanra'),
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
                                                  await _bookGenreProvider
                                                      .remove(widget
                                                              .bookGenre?.id ??
                                                          0);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Uspješno brisanje žanra knjige')));
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
                    widget.bookGenre == null
                        ? Container()
                        : const SizedBox(
                            width: 7,
                          ),
                   widget.bookGenre !=null ? Container(): ElevatedButton(
                        onPressed: () async {
                          
                          _formKey.currentState?.save();
                          print(_formKey.currentState?.value);

                          try {
                            if (_formKey.currentState!.validate()) {
                              
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['bookId'] = widget.book?.id;

                                await _bookGenreProvider.insert(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Uspješna dodavanje žanra')));

                                Navigator.pop(context, 'reload');

                              
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
                  child: FormBuilderDropdown<String>(
                name: 'genreId',
                validator: (value) {
                  if (value == null) {
                    return "Obavezno polje";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Žanr',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!
                          .fields['genreId'] //brisnje selekcije iz forme
                          ?.reset();
                    },
                  ),
                  hintText: 'Odaberi žanr',
                ),
                items: genresResult?.items
                        .map((g) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: g.id.toString(),
                              child: Text(g.name ?? ''),
                            ))
                        .toList() ??
                    [],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
