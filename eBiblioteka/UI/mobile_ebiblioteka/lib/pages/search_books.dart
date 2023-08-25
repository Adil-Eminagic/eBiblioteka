import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/providers/book_provider.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../special_pages/search_widgets.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBooksPage extends StatefulWidget {
  const SearchBooksPage({Key? key}) : super(key: key);

  @override
  State<SearchBooksPage> createState() => _SearchBooksPageState();
}

class _SearchBooksPageState extends State<SearchBooksPage> {
  late BookProvider _bookProvider = BookProvider();

  final TextEditingController _valueController = TextEditingController();
  SearchResult<Book>? result;

  String menu = 'title';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookProvider = context.read<BookProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      result = await _bookProvider
          .getPaged(filter: {'title': _valueController.text});
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
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).search_by),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(AppLocalizations.of(context).titles),
                ),
                Tab(
                  child: Text(AppLocalizations.of(context).authors),
                ),
                Tab(
                  child: Text(AppLocalizations.of(context).genres),
                ),
              ],
            ),
          ),
          body: const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TabBarView(
                children: [SearchTitle(), SearchAuthors(), SearchGenre()],
              )
              ),
        ));
  }
}
