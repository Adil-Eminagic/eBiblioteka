import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rating.dart';
import '../models/search_result.dart';
import '../providers/rating_provider.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RatingListPage extends StatefulWidget {
  const RatingListPage({Key? key, this.bookId}) : super(key: key);
  final int? bookId;

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  late RatingProvider _ratingProvider = RatingProvider();

  final TextEditingController _userConroller = TextEditingController();
  bool isLoading = true;

  SearchResult<Rating>? result;

  @override
  void initState() {
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
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).rates,
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
                    decoration:
                         InputDecoration(label: Text(AppLocalizations.of(context).user_name)),
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
                          "userName": _userConroller
                              .text, //!=''?_userConroller.text : null
                          "pageSize": 1000000
                        });

                        setState(() {
                          result = data;
                        });
                      } on Exception catch (e) {
                        alertBox(context, AppLocalizations.of(context).error, e.toString());
                      }
                    },
                    child: Text(AppLocalizations.of(context).search)),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          (result == null || result!.items.isEmpty || isLoading == true)
              ? Expanded(
                  child: Center(child: Text(AppLocalizations.of(context).no_rates)))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                    child: ListView.builder(
                      itemCount: result!.items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              subtitle:
                                  Text(result?.items[index].comment ?? ''),
                              title: Text(
                                  "${result!.items[index].user!.firstName} ${result!.items[index].user!.lastName}"),
                              leading: Text(
                                result!.items[index].stars!.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              trailing: InkWell(
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title:
                                                 Text(AppLocalizations.of(context).rate_del_title),
                                            content:  Text(
                                                AppLocalizations.of(context).rate_del_mes),
                                            actions: [
                                              TextButton(
                                                  onPressed: (() {
                                                    Navigator.pop(context);
                                                  }),
                                                  child: Text(AppLocalizations.of(context).cancel)),
                                              TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await _ratingProvider
                                                          .remove(result!
                                                                  .items[index]
                                                                  .id ??
                                                              0);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                               SnackBar(
                                                                  content: Text(
                                                                      AppLocalizations.of(context).rate_del_su)));

                                                      Navigator.pop(
                                                        context,
                                                      );
                                                      initData();
                                                    } catch (e) {
                                                      alertBoxMoveBack(
                                                          context,
                                                          AppLocalizations.of(context).error,
                                                          e.toString());
                                                    }
                                                  },
                                                  child: const Text('Ok')),
                                            ],
                                          ));
                                },
                                child: const Icon(Icons.delete),
                              ),
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
