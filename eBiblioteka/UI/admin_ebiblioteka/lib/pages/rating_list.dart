import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rating.dart';
import '../models/search_result.dart';
import '../providers/rating_provider.dart';
import '../utils/util_widgets.dart';

class RatingListPage extends StatefulWidget {
  const RatingListPage({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  late RatingProvider _ratingProvider = RatingProvider();

  TextEditingController _userConroller = TextEditingController();
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
      title: 'Ocjene knjige',
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userConroller,
                    decoration: const InputDecoration(label: Text("Naziv")),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var data = await _ratingProvider.getPaged(filter: {
                          "bookId": widget.bookId,
                          "userName": _userConroller.text,
                          "pageSize":1000000
                        });

                        setState(() {
                          result = data;
                        });
                      } on Exception catch (e) {
                        alertBox(context, 'Greška', e.toString());
                      }
                    },
                    child: const Text('Traži')),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          (result == null || result!.items.isEmpty)
              ? const Expanded(
                  child: Center(child: Text('Nema ocjena za ovu knjigu')))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
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
                              trailing: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                  const Text('Brisanje ocjenu'),
                                              content: const Text(
                                                  'Da li želite obrisati ocjenu'),
                                              actions: [
                                                TextButton(
                                                    onPressed: (() {
                                                      Navigator.pop(context);
                                                    }),
                                                    child:
                                                        const Text('Poništi')),
                                                TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await _ratingProvider
                                                            .remove(result!
                                                                    .items[
                                                                        index]
                                                                    .id ??
                                                                0);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Uspješno brisanje ocjene.')));

                                                        Navigator.pop(
                                                          context,
                                                        );
                                                        initData();
                                                      } catch (e) {
                                                        alertBoxMoveBack(
                                                            context,
                                                            'Greška',
                                                            e.toString());
                                                      }
                                                    },
                                                    child: const Text('Ok')),
                                              ],
                                            ));
                                  },
                                  child: const Icon(Icons.delete),),
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
                ),
        ],
      ),
    );
  }
}
