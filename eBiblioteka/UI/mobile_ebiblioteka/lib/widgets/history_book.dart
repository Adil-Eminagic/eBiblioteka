import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../detail_pages/book_detail.dart';
import '../models/book.dart';
import '../models/photo.dart';
import '../providers/author_provider.dart';
import '../providers/photo_provider.dart';
import 'package:provider/provider.dart';

import '../models/author.dart';
import '../providers/book_provider.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryBook extends StatefulWidget {
  final int? bookId;

  const HistoryBook({Key? key, this.bookId}) : super(key: key);

  @override
  State<HistoryBook> createState() => _HistoryBookState();
}

class _HistoryBookState extends State<HistoryBook> {
  late BookProvider _bookProvider = BookProvider();
  late PhotoProvider _photoProvider = PhotoProvider();
  AuthorProvider _authorProvider = AuthorProvider();

  Book? book;
  Photo? photo;
  Author? author;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookProvider = context.read<BookProvider>();
    _photoProvider = context.read<PhotoProvider>();
    _authorProvider = context.read<AuthorProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      book = await _bookProvider.getById(widget.bookId!);
      author = await _authorProvider.getById(book!.authorID!);
      if (book?.coverPhotoId != null && book!.coverPhotoId! > 0) {
        photo = await _photoProvider.getById(book!.coverPhotoId!);
      }
      if (mounted) {
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
    return isLoading == true
        ? const SpinKitRing(color: Colors.brown)
        : ListTile(
            title: Text(book?.title ?? ''),
            subtitle: Text(author?.fullName ?? ''),
            leading: photo == null
                ? Image.asset(
                    'images/no_image.png',
                    width: 100,
                    height: 100,
                  )
                : Image.memory(
                    base64Decode(photo!.data!),
                    width: 100,
                    height: 100,
                  ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return BookDetailPage(
                  book: book,
                );
              })));
            },
          );
  }
}
