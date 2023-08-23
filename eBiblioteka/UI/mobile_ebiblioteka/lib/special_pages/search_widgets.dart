import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/detail_pages/book_detail.dart';
import 'package:mobile_ebiblioteka/models/bookgenre.dart';
import 'package:mobile_ebiblioteka/models/genre.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/providers/book_provider.dart';
import 'package:mobile_ebiblioteka/providers/bookgenre_provider.dart';
import 'package:mobile_ebiblioteka/providers/genre_provider.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SearchTitle extends StatefulWidget {
  const SearchTitle({Key? key}) : super(key: key);

  @override
  State<SearchTitle> createState() => _SearchTitleState();
}

class _SearchTitleState extends State<SearchTitle> {
  late BookProvider _bookProvider = BookProvider();

  TextEditingController _valueController = TextEditingController();
  SearchResult<Book>? result;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookProvider = context.read<BookProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      result = await _bookProvider.getPaged(
          filter: {'title': _valueController.text, 'pageSize': 100000, 'isActive':true});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              // mora u expande jer ne zan koliko da se širi
              child: TextField(
                controller: _valueController,
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).value_name)),
              ),
            ),
            ElevatedButton(
                onPressed: (() async {
                  initData();
                }),
                child: Text(AppLocalizations.of(context).search))
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
            child: (isLoading || result == null || result!.items.isEmpty)
                ? Container()
                : ListView.builder(
                    // kada se koristi buider ucitavaju se kako scrollamo a ne sve od jednom
                    itemCount: result!.items.length,
                    itemBuilder: (context, index) {
                      // preko indeksa se pristupa elemntima u nizu
                      return ListTile(
                        title: Text(result!.items[index].title!),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return BookDetailPage(
                              book: result!.items[index],
                            );
                          })));
                        },
                        subtitle: Text(result!.items[index].author!.fullName!),
                        leading: result!.items[index].coverPhoto == null
                            ? Image.asset(
                                'images/no_image.png',
                                width: 100,
                                height: 100,
                              )
                            : Image.memory(
                                base64Decode(
                                    result!.items[index].coverPhoto!.data!),
                                width: 100,
                                height: 100,
                              ),
                      );
                    },
                  ))
      ],
    );
  }
}

class SearchAuthors extends StatefulWidget {
  const SearchAuthors({Key? key}) : super(key: key);

  @override
  State<SearchAuthors> createState() => _SearchAuthorsState();
}

class _SearchAuthorsState extends State<SearchAuthors> {
  late BookProvider _bookProvider = BookProvider();

  TextEditingController _valueController = TextEditingController();
  SearchResult<Book>? result;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookProvider = context.read<BookProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      result = await _bookProvider.getPaged(
          filter: {'authorName': _valueController.text, 'pageSize': 1000000,'isActive':true});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              // mora u expande jer ne zan koliko da se širi
              child: TextField(
                controller: _valueController,
                decoration:  InputDecoration(label: Text(AppLocalizations.of(context).value_name)),
              ),
            ),
            ElevatedButton(
                onPressed: (() async {
                  initData();
                }),
                child:  Text(AppLocalizations.of(context).search))
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
            child: (result == null || result!.items.isEmpty)
                ? (isLoading
                    ? const SpinKitRing(color: Colors.brown)
                    : Center(
                        child: Text(AppLocalizations.of(context).no_result),
                      ))
                : ListView.builder(
                    // kada se koristi buider ucitavaju se kako scrollamo a ne sve od jednom
                    itemCount: result!.items.length,
                    itemBuilder: (context, index) {
                      // preko indeksa se pristupa elemntima u nizu
                      return ListTile(
                        title: Text(result!.items[index].title!),
                        subtitle: Text(result!.items[index].author!.fullName!),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return BookDetailPage(
                              book: result!.items[index],
                            );
                          })));
                        },
                        leading: result!.items[index].coverPhoto == null
                            ? Image.asset(
                                'images/no_image.png',
                                width: 100,
                                height: 100,
                              )
                            : Image.memory(
                                base64Decode(
                                    result!.items[index].coverPhoto!.data!),
                                width: 100,
                                height: 100,
                              ),
                      );
                    },
                  ))
      ],
    );
  }
}

class SearchGenre extends StatefulWidget {
  const SearchGenre({Key? key}) : super(key: key);

  @override
  State<SearchGenre> createState() => _SearchGenreState();
}

class _SearchGenreState extends State<SearchGenre> {
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();
  late GenreProvider _genreProvider = GenreProvider();
  final _formKey = GlobalKey<FormBuilderState>();

  SearchResult<Genre>? genreResult;
  SearchResult<BookGenre>? bookGenreResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookGenreProvider = context.read<BookGenreProvider>();
    _genreProvider = context.read<GenreProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      genreResult = await _genreProvider.getPaged();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  Future<void> initBooks() async {
    try {
      _formKey.currentState?.save();
      if (_formKey.currentState!.validate()) {
        bookGenreResult = await _bookGenreProvider.getPaged(filter: {
          'genreId': _formKey.currentState?.value['genreId'],
          'isActive':true,
          'pageSize': 1000000
        });
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            // mora u expande jer ne zan koliko da se širi
            child: FormBuilder(
                key: _formKey,
                child: FormBuilderDropdown<String>(
                  name: 'genreId',
                  validator: (value) {
                    if (value == null) {
                      return "Žanr je obavezan.";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).choose_genre,
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!
                            .fields['genreId'] //brisnje selekcije iz forme
                            ?.reset();
                      },
                    ),
                   
                  ),
                  items: genreResult?.items
                          .map((g) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: g.id.toString(),
                                child: Text(g.name ?? ''),
                              ))
                          .toList() ??
                      [],
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: (() async {
                initBooks();
              }),
              child: Text(AppLocalizations.of(context).search))
        ]),
        const SizedBox(
          height: 30,
        ),
        Expanded(
            child: (bookGenreResult == null || bookGenreResult!.items.isEmpty)
                ? (isLoading
                    ? const SpinKitRing(color: Colors.brown)
                    : Center(
                        child: Text(AppLocalizations.of(context).no_result),
                      ))
                : ListView.builder(
                    // kada se koristi buider ucitavaju se kako scrollamo a ne sve od jednom
                    itemCount: bookGenreResult!.items.length,
                    itemBuilder: (context, index) {
                      // preko indeksa se pristupa elemntima u nizu
                      return ListTile(
                        title: Text(bookGenreResult!.items[index].book!.title!),
                        subtitle: Text(bookGenreResult!
                            .items[index].book!.author!.fullName!),
                            onTap: () {
                              Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return BookDetailPage(
                              book: bookGenreResult!.items[index].book,
                            );
                          })));
                            },
                        leading:
                            bookGenreResult!.items[index].book?.coverPhoto ==
                                    null
                                ? Image.asset(
                                    'images/no_image.png',
                                    width: 100,
                                    height: 100,
                                  )
                                : Image.memory(
                                    base64Decode(bookGenreResult!
                                        .items[index].book!.coverPhoto!.data!),
                                    width: 100,
                                    height: 100,
                                  ),
                      );
                    },
                  ))
      ],
    );
  }
}
