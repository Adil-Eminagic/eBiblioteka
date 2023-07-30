import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/models/author.dart';
import 'package:mobile_ebiblioteka/models/photo.dart';
import 'package:mobile_ebiblioteka/providers/author_provider.dart';
import 'package:mobile_ebiblioteka/providers/book_provider.dart';
import 'package:mobile_ebiblioteka/providers/photo_provider.dart';
import 'package:provider/provider.dart';

import '../detail_pages/book_detail.dart';
import '../models/book.dart';
import '../utils/util_widgets.dart';

class RecommendedBookWidget extends StatefulWidget {
  const RecommendedBookWidget({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<RecommendedBookWidget> createState() => _RecommendedBookWidgetState();
}

class _RecommendedBookWidgetState extends State<RecommendedBookWidget> {
  late BookProvider _bookProvider = BookProvider();
  late AuthorProvider _authorProvider = AuthorProvider();
  late PhotoProvider _photoProvider = PhotoProvider();

  bool isLoading = true;
  Book? book;
  Author? author;
  String? _base64Photo;

  @override
  void initState() {
    super.initState();
    _bookProvider = context.read<BookProvider>();
    _authorProvider = context.read<AuthorProvider>();
    _photoProvider = context.read<PhotoProvider>();

    intiBook();
  }

  Future<void> intiBook() async {
    try {
      book = await _bookProvider.getById(widget.bookId!);
      author = await _authorProvider.getById(book!.authorID!);
      if (book?.coverPhotoId != null && book!.coverPhotoId! > 0) {
        Photo photo = await _photoProvider.getById(book!.coverPhotoId!);
        _base64Photo = photo.data;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => BookDetailPage(
                  book: book,
                ))));
      }),
      child: isLoading == true ? Container() : Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.brown),
              bottom: BorderSide(color: Colors.brown),
              right: BorderSide(color: Colors.brown)),
        ),
        width: 205,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150,
                height: 100,
                child: _base64Photo != null
                    ? Image.memory(base64Decode(_base64Photo!))
                    : Image.asset(
                        'images/no_image.png',
                        width: 150,
                        height: 100,
                      )),
            const SizedBox(
              height: 10,
            ),
            Text(book?.title ?? ''),
            const SizedBox(
              height: 10,
            ),
            Text('(${author?.fullName ?? ''})')
          ],
        ),
      ),
    );
  }
}
