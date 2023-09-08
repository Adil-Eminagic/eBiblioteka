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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    super.initState();
    _initialValue = {'genreId': widget.bookGenre?.genre?.id.toString()};

    _bookGenreProvider = context.read<BookGenreProvider>();
    _genreProvider = context.read<GenreProvider>();

    initTable();
  }

  Future<void> initTable() async {
    try {
      genresResult = await _genreProvider.getPaged();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.bookGenre == null
          ? AppLocalizations.of(context).bookgenre_insert
          : "${AppLocalizations.of(context).book} ${widget.bookGenre?.book?.title}, ${AppLocalizations.of(context).genre} ${widget.bookGenre?.genre?.name}",
      child: isLoading == true
          ? const Center(child: SpinKitRing(color: Colors.brown))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(65, 80, 65, 100),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            children: [
                              _buildForm(),
                              const SizedBox(
                                height: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    widget.bookGenre == null
                                        ? Container()
                                        :  Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (BuildContext context) =>
                                                                  AlertDialog(
                                                                    title: Text(
                                                                        AppLocalizations.of(
                                                                                context)
                                                                            .bookgenre_del_title),
                                                                    content: Text(
                                                                        AppLocalizations.of(
                                                                                context)
                                                                            .bookgenre_del_mes),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: (() {
                                                                            Navigator.pop(
                                                                                context);
                                                                          }),
                                                                          child: Text(
                                                                              AppLocalizations.of(
                                                                                      context)
                                                                                  .cancel)),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            try {
                                                                              await _bookGenreProvider
                                                                                  .remove(
                                                                                      widget.bookGenre?.id ??
                                                                                          0);
                                                                              ScaffoldMessenger.of(
                                                                                      context)
                                                                                  .showSnackBar(SnackBar(
                                                                                      content:
                                                                                          Text(AppLocalizations.of(context).bookgenre_del_su)));
                                                                              Navigator.pop(
                                                                                  context);
                                                                              Navigator.pop(
                                                                                  context,
                                                                                  'reload');
                                                                            } catch (e) {
                                                                              alertBoxMoveBack(
                                                                                  context,
                                                                                  AppLocalizations.of(context)
                                                                                      .error,
                                                                                  e.toString());
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                                  'Ok')),
                                                                    ],
                                                                  ));
                                                    },
                                                    child: Text(
                                                        AppLocalizations.of(context)
                                                            .bookgenre_del_lbl)),
                                              ],
                                            ),
                                    widget.bookGenre == null
                                        ? Container()
                                        : const SizedBox(
                                            width: 7,
                                          ),
                                    widget.bookGenre != null
                                        ? Container()
                                        : ElevatedButton(
                                            onPressed: () async {
                                              _formKey.currentState?.save();
                                            
                                              try {
                                                if (_formKey.currentState!.validate()) {
                                                  Map<String, dynamic> request = Map.of(
                                                      _formKey.currentState!.value);
                                            
                                                  request['bookId'] = widget.book?.id;
                                            
                                                  await _bookGenreProvider
                                                      .insert(request);
                                            
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(context)
                                                                  .bookgenre_add_su)));
                                            
                                                  Navigator.pop(context, 'reload');
                                                }
                                              } on Exception catch (e) {
                                                alertBox(
                                                    context,
                                                    AppLocalizations.of(context).error,
                                                    e.toString());
                                              }
                                            },
                                            child: Text(
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
                    ),
                     Expanded(child: Container()),
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
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).genre,
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['genreId']?.reset();
                    },
                  ),
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
