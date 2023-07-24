import 'dart:convert';
import 'dart:io';

import 'package:mobile_ebiblioteka/pages/rating_page.dart';
import 'package:mobile_ebiblioteka/special_pages/quotes_list.dart';
import 'package:mobile_ebiblioteka/special_pages/show_book_desc.dart';

import '../models/author.dart';
import '../models/book.dart';
import '../models/bookgenre.dart';
import '../models/search_result.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'title': widget.book?.title,
      'shortDescription': widget.book?.shortDescription,
      'publishingYear': widget.book?.publishingYear.toString(), // mora biti
      'authorId': widget.book?.authorID.toString(),
    };

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
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "${widget.book?.title}",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
          child: Column(
            children: [
              isLoading ? const SpinKitRing(color: Colors.brown) : _buildForm(),
              Row(
                children: [
                  Text(
                      'Ocjena : ${widget.book?.averageRate == null ? "nema ocjena" : widget.book?.averageRate.toString()}',
                      style: const TextStyle(
                        fontSize: 17,
                      )),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => RatingListPage(
                            bookId: widget.book!.id,
                          ))));
                   
                    },
                      child: const Text(
                    'Pogledajte ocjene',
                    style: TextStyle(fontSize: 17, color: Colors.brown),
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Čitaj",
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                ),
              ),
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
                  child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 350, maxWidth: 350),
                      child: photo == null
                          ? Image.asset('images/no_image.png')
                          : imageFromBase64String(photo!)),
                )),
              )
            ],
          ),
          rowMethod(textField('title', 'Nalov')),
          const SizedBox(height: 15),
          rowMethod(
            Expanded(
                child: FormBuilderTextField(
              name: 'publishingYear',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Godina objave')),
            )),
          ),
          const SizedBox(height: 15),
          rowMethod(
            Expanded(
                child: FormBuilderDropdown<String>(
              name: 'authorId',
              
              validator: (value) {
                if (value == null) {
                  return "Obavezno polje";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Autor',
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState!
                        .fields['authorId'] //brisnje selekcije iz forme
                        ?.reset();
                  },
                ),
                hintText: 'Odaberi autora',
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
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => BookShortDesription(
                              decription: widget.book?.shortDescription,
                            ))));
                  }),
                  child: const Text('Kratak sadržaj')),
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => QuoteListPage(
                              bookId: widget.book!.id,
                            ))));
                  }),
                  child: const Text('Citati')),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.7,
          ),
          const SizedBox(
            height: 25,
          ),
          (widget.book == null || isLoading == true)
              ? Container()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Žanrovi:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (bookGenreResult == null ||
                              bookGenreResult!.items.isEmpty)
                            const Text('Nema žanrova')
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
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  File? _image; //dart.io
  String? _base64Image;

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
}
