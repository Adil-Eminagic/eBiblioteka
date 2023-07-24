import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/detail_pages/book_detail.dart';
import 'package:mobile_ebiblioteka/models/bookgenre.dart';
import 'package:mobile_ebiblioteka/models/genre.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/pages/search_books.dart';
import 'package:mobile_ebiblioteka/providers/bookgenre_provider.dart';
import 'package:mobile_ebiblioteka/providers/genre_provider.dart';
import 'package:mobile_ebiblioteka/special_pages/show_book_desc.dart';
import 'package:mobile_ebiblioteka/utils/util_widgets.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GenreProvider _genreProvider = GenreProvider();

  SearchResult<Genre>? genreResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'eBiblioteka',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => SearchBooksPage())));
                    }),
                    child: const Text(
                      'Traži',
                      style: TextStyle(fontSize: 17),
                    )),
              ],
            ),
            const SizedBox(height: 50),
            if (!isLoading && genreResult != null)
              for (var g in genreResult!.items)
                Row(
                  children: [
                    Expanded(
                        child: GenreBooksWidget(
                      genre: g,
                    ))
                  ],
                )
          ],
        ),
      ),
    );
  }
}

class GenreBooksWidget extends StatefulWidget {
  const GenreBooksWidget({Key? key, this.genre}) : super(key: key);
  final Genre? genre;

  @override
  State<GenreBooksWidget> createState() => _GenreBooksWidgetState();
}

class _GenreBooksWidgetState extends State<GenreBooksWidget> {
  late BookGenreProvider _bookGenreProvider = BookGenreProvider();

  SearchResult<BookGenre>? bookGenreResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bookGenreProvider = context.read<BookGenreProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      bookGenreResult = await _bookGenreProvider
          .getPaged(filter: {'genreId': widget.genre?.id, 'pageSize': 6});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(widget.genre?.name ?? '',
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (!isLoading && bookGenreResult != null)
                if (bookGenreResult!.items.isNotEmpty)
                  for (var k in bookGenreResult!.items)
                    InkWell(
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => BookDetailPage(
                                  book: k.book,
                                ))));
                      }),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.brown),
                              bottom: BorderSide(color: Colors.brown),
                              right: BorderSide(color: Colors.brown)),
                        ),
                        width: 205,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 150,
                                height: 100,
                                child: k.book?.coverPhoto != null
                                    ? Image.memory(
                                        base64Decode(k.book!.coverPhoto!.data!))
                                    : Image.asset(
                                        'images/no_image.png',
                                        width: 150,
                                        height: 100,
                                      )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(k.book?.title ?? ''),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('(${k.book?.author?.fullName ?? ''})')
                          ],
                        ),
                      ),
                    )
                else
                  const Text('Nema knjiga')
              else
                const SpinKitRing(color: Colors.brown)
            ],
          ),
        ),
        const SizedBox(height: 70)
      ],
    );
  }
}
