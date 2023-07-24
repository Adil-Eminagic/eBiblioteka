import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/detail_pages/rating_detail.dart';
import 'package:mobile_ebiblioteka/models/rating.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/providers/rating_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../utils/util_widgets.dart';

class RatingListPage extends StatefulWidget {
  const RatingListPage({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  late RatingProvider _ratingProvider = RatingProvider();
  bool isLoading = true;

  SearchResult<Rating>? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ratingProvider = context.read<RatingProvider>();
    initData();
  }

  Future<void> initData() async {
    try {
      result = await _ratingProvider
          .getPaged(filter: {'bookId': widget.bookId, 'pageSize': 100000});
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
        title: 'Ocjene',
        child:  Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: (() async {
                                var refresh = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: ((context) => RatingDetailPage(
                                            rating: null,
                                            bookId: widget.bookId,
                                            userId: int.parse(Autentification
                                                .tokenDecoded!['Id'])))));

                                if (refresh == 'reload') {
                                  initData();
                                }
                              }),
                              child: const Text('Ocjeni')),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                     (result == null || result!.items.isEmpty) ? const Expanded(child: Center(child: Text('Nema ocjena za ovu knjigu'))) : Expanded(
                        child: ListView.builder(
                          itemCount: result!.items.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  subtitle: Text(result!.items[index].comment!),
                                  title: Text(
                                      "${result!.items[index].user!.firstName} ${result!.items[index].user!.lastName}"),
                                  leading: Text(
                                    result!.items[index].stars!.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onTap: (() async {
                                    if (result!.items[index].userId ==
                                       int.parse(Autentification.tokenDecoded!['Id'])) {
                                      var refresh = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) =>
                                                  RatingDetailPage(
                                                    rating:
                                                        result!.items[index],
                                                  ))));

                                      if (refresh == 'reload') {
                                        initData();
                                      }
                                    } else
                                      print('dont');
                                  }),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 0.5,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ));
  }
}
