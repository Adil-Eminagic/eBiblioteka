
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

  TextEditingController _valueController = TextEditingController();
  SearchResult<Book>? result;

  String menu = 'title';
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
      result = await _bookProvider
          .getPaged(filter: {'title': _valueController.text});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
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
            bottom:  TabBar(
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
              //  Column(
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           // mora u expande jer ne zan koliko da se širi
              //           child: TextField(
              //             controller: _valueController,
              //             decoration:
              //                 const InputDecoration(label: Text('Vrijednost')),
              //           ),
              //         ),
              //         ElevatedButton(
              //             onPressed: (() async {
              //               initData();
              //             }),
              //             child: const Text('Traži'))
              //       ],
              //     ),
              //     const SizedBox(
              //       height: 30,
              //     ),
              //     Expanded(
              //       child: isLoading
              //           ? Container()
              //           : ListView(children: [
              //               const Divider(
              //                 color: Colors.black,
              //                 thickness: 0.4,
              //               ),
              //               if (result != null && result!.items.isEmpty == false)
              //                 for (var b in result!.items)
              //                   Column(
              //                     children: [
              //                       ListTile(
              //                         title: Text(b.title ?? ''),
              //                         subtitle: Text(b.author?.fullName ?? ''),
              //                         leading: b.coverPhoto == null
              //                             ? Image.asset(
              //                                 'images/no_image.png',
              //                                 width: 100,
              //                                 height: 100,
              //                               )
              //                             : Image.memory(
              //                                 base64Decode(b.coverPhoto!.data!),
              //                                 width: 100,
              //                                 height: 100,
              //                               ),
              //                       ),
              //                       const Divider(
              //                         color: Colors.black,
              //                         thickness: 0.4,
              //                       )
              //                     ],
              //                   )
              //             ]),
              //     )
              //   ],
              // ),
              ),
        ));
  }
}

