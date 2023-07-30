
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/models/quote.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/providers/quotes_provider.dart';
import 'package:mobile_ebiblioteka/utils/util_widgets.dart';

class QuoteListPage extends StatefulWidget {
  const QuoteListPage({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<QuoteListPage> createState() => _QuoteListPageState();
}

class _QuoteListPageState extends State<QuoteListPage> {
  late QuoteProvider _quoteProvider = QuoteProvider();

  SearchResult<Quote>? result;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      result = await _quoteProvider.getPaged(filter: {'bookId': widget.bookId});

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citati'),
        centerTitle: true,
      ),
      body: isLoading
          ? const SpinKitRing(color: Colors.brown)
          : ListView(
              children: [
                if (result != null && result!.items.isEmpty == false)
                  for (var q in result!.items)
                    Column(
                      children: [
                        ListTile(
                          title: Text(q.content ?? ''),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        )
                      ],
                    )
                else
                  const Text('Nema citata', style: TextStyle(fontSize: 20))
              ],
            ),
    );
  }
}
