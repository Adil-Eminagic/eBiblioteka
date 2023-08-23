import 'dart:convert';
import 'dart:io';

import 'package:admin_ebiblioteka/pages/quote_list.dart';
import 'package:admin_ebiblioteka/pages/rating_list.dart';

import '../models/author.dart';
import '../models/book.dart';
import '../models/bookgenre.dart';
import '../models/search_result.dart';
import '../pages/bookgenre_list.dart';
import '../providers/author_provider.dart';
import '../providers/book_provider.dart';
import '../providers/bookgenre_provider.dart';
import '../widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../utils/util.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({Key? key, this.book}) : super(key: key);
  final Book? book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AuthorProvider _authorProvider = AuthorProvider();
  late BookProvider _bookProvider = BookProvider();
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();

  bool isLoading = false;
  String? photo;

  Book? bookSend;
  SearchResult<Author>? authorResult;
  SearchResult<BookGenre>? bookGenreResult;
  bool? isActive;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'title': widget.book?.title,
      'shortDescription': widget.book?.shortDescription,
      'publishingYear': widget.book?.publishingYear.toString(), // mora biti
      'authorId': widget.book?.authorID.toString(),
    };
    if (widget.book != null) {
      isActive = widget.book!.isActive!;
    }
    _authorProvider = context.read<AuthorProvider>();
    _bookProvider = context.read<BookProvider>();
    _bookGenreProvider = context.read<BookGenreProvider>();

    if (widget.book != null && widget.book?.coverPhoto != null) {
      photo = widget.book?.coverPhoto?.data ?? '';
    }

    initForm();
  }

  Future<void> initForm() async {
    try {
      authorResult = await _authorProvider.getPaged();
      if (widget.book != null) {
        bookSend = await _bookProvider.getById(widget.book!.id!);
        bookGenreResult = await _bookGenreProvider
            .getPaged(filter: {'bookId': widget.book?.id});
        if (bookGenreResult!.items.isNotEmpty) {
          print(bookGenreResult?.items[0].genre?.name);
        }
      }
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.book != null
          ? "${AppLocalizations.of(context).book_id} ${(widget.book?.id.toString() ?? '')}"
          : AppLocalizations.of(context).new_book,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
          child: Column(
            children: [
              isLoading ? const SpinKitRing(color: Colors.brown) : _buildForm(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.book == null
                        ? Container()
                        : const SizedBox(
                            width: 7,
                          ),
                    ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.save();
                          try {
                            if (_formKey.currentState!.validate()) {
                              if (widget.book != null) {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                request['id'] = widget.book
                                    ?.id; // zbog ovoga nije radilo, treba id

                                if (_base64Document != null) {
                                  Map<String, dynamic> document = {
                                    'name': _documentName,
                                    'data': _base64Document
                                  };
                                  request['document'] = document;
                                }

                                var publishingYear = int.parse(_formKey
                                    .currentState!.value['publishingYear']);
                                request['publishingYear'] = publishingYear;

                                print(request['publishingYear']);

                                var openingCount =
                                    widget.book?.openingCount as int;
                                request['openingCount'] = 0;

                                request['openingCount'] =
                                    widget.book?.openingCount!;

                                if (_base64Image != null) {
                                  request['image'] = _base64Image;
                                }

                                request['isActive'] = isActive;

                                var res = await _bookProvider.update(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .su_mod_book)));

                                Navigator.pop(context, 'reload');
                              } else {
                                Map<String, dynamic> request =
                                    Map.of(_formKey.currentState!.value);

                                var publishingYear = int.parse(_formKey
                                    .currentState!.value['publishingYear']);
                                request['publishingYear'] = publishingYear;

                                request['openingCount'] = 0;

                                if (_base64Document != null) {
                                  Map<String, dynamic> document = {
                                    'name': _documentName,
                                    'data': _base64Document
                                  };
                                  request['document'] = document;
                                }

                                request['openingCount'] =
                                    widget.book?.openingCount!;

                                request['isActive'] = true;
                                if (_base64Image != null) {
                                  request['image'] = _base64Image;
                                }

                                await _bookProvider.insert(request);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .su_add_book)));

                                Navigator.pop(context, 'reload');
                              }
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
                flex: 2,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                  child: Column(
                    children: [
                      widget.book == null
                          ? Container()
                          : Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context).activity,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Switch(
                                  // This bool value toggles the switch.
                                  value: isActive!,
                                  activeColor: Colors.brown,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      isActive = value;
                                    });
                                  },
                                )
                              ],
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      (photo == null)
                          ? Container()
                          : Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 350, maxWidth: 350),
                              child: imageFromBase64String(photo!)),
                      photo == null
                          ? Container()
                          : const SizedBox(
                              height: 28,
                            ),
                      ElevatedButton(
                          onPressed: getimage,
                          child: photo == null
                              ? Text(AppLocalizations.of(context).choose_image)
                              : Text(
                                  AppLocalizations.of(context).change_image)),
                    ],
                  ),
                )),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textField('title', AppLocalizations.of(context).title),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: FormBuilderTextField(
                name: 'shortDescription',
                maxLines: 5,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).short_desc)),
              )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'publishingYear',
                 validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  }
                  else if (int.tryParse(value) == null) {
                      return AppLocalizations.of(context).numeric_field;
                    }
                  else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).publishing_year)),
              )),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: FormBuilderDropdown<String>(
                name: 'authorId',
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).author,
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!
                          .fields['authorId'] //brisnje selekcije iz forme
                          ?.reset();
                    },
                  ),
                ),
                items: authorResult?.items
                        .map((g) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: g.id.toString(),
                              child: Text(g.fullName ?? ''),
                            ))
                        .toList() ??
                    [],
              )),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          (widget.book == null || isLoading == true)
              ? Container()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            AppLocalizations.of(context).genres,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (bookGenreResult == null ||
                              bookGenreResult!.items.isEmpty)
                             Text(AppLocalizations.of(context).no_genres)
                          else
                            Row(
                              children: bookGenreResult?.items
                                      .map((BookGenre i) => Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.brown,
                                                        width: 2)),
                                                child: Text(
                                                  i.genre?.name ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.brown,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              )
                                            ],
                                          ))
                                      .toList() ??
                                  [],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    var refresh = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                BookGenresPage(
                                                  book: bookSend,
                                                )));

                                    if (refresh == 'reload2') {
                                      initForm();
                                    }
                                  },
                                  child:  Text(AppLocalizations.of(context).mod_b_genres)),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: (() async {
                                    var refresh = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                QuotesListPage(
                                                  bookId: widget.book!.id,
                                                )));

                                    if (refresh == 'reload2') {
                                      initForm();
                                    }
                                  }),
                                  child: Text(AppLocalizations.of(context).mod_b_quotes)),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: (() async {
                                    var refresh = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                RatingListPage(
                                                  bookId: widget.book!.id,
                                                )));

                                    if (refresh == 'reload2') {
                                      initForm();
                                    }
                                  }),
                                  child: Text(AppLocalizations.of(context).mod_b_rates)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          widget.book?.bookFileId == null
                              ? (_base64Document == null
                                  ?  Text(AppLocalizations.of(context).no_doc)
                                  :  Text(AppLocalizations.of(context).chosen_doc))
                              : Text(AppLocalizations.of(context).added_doc),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: getFile,
                              child: widget.book?.bookFileId != null
                                  ? Text(AppLocalizations.of(context).change_doc)
                                  : Text(AppLocalizations.of(context).choose_doc)),
                        ],
                      ),
                    ),
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
          return AppLocalizations.of(context).mfield;
        } else {
          return null;
        }
      },
      name: name,
      decoration: InputDecoration(label: Text(label)),
    ));
  }

  File? _image; //dart.io
  String? _base64Image;
  File? _document;
  String? _documentName;
  String? _base64Document;

  Future getimage() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.image); //sam prepoznaj platformu u kjoj radi
    if (result != null && result.files.single.path != null) {
      _image = File(
          result.files.single.path!); //jer smo sa if provjerili pa je sigurn !
      _base64Image = base64Encode(_image!.readAsBytesSync());

      setState(() {
        photo = _base64Image; //opet !
      });
    }
  }

  Future getFile() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.any); //sam prepoznaj platformu u kjoj radi

    if (result != null && result.files.single.path != null) {
      var file = File(result.files.single.path!);
      if (file.toString().substring(
              file.toString().length - 4, file.toString().length - 1) ==
          "pdf") {
        setState(() {
          _base64Document = base64Encode(file.readAsBytesSync());
          _documentName = "${widget.book?.title}.pdf";
        });

        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(AppLocalizations.of(context).su_ch_doc)));
      } else {
        _document = null;
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(
          AppLocalizations.of(context).doc_rule,
        )));
      }
    }
  }
}
