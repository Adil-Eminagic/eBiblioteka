import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/models/search_result.dart';
import 'package:mobile_ebiblioteka/models/userquiz.dart';
import 'package:mobile_ebiblioteka/providers/userquiz_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/util_widgets.dart';

class QuizResultListPage extends StatefulWidget {
  const QuizResultListPage({Key? key}) : super(key: key);

  @override
  State<QuizResultListPage> createState() => _QuizResultListPageState();
}

class _QuizResultListPageState extends State<QuizResultListPage> {
  UserQuizProvider _userQuizProvider = UserQuizProvider();

  SearchResult<UserQuiz>? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userQuizProvider = context.read<UserQuizProvider>();

    initData();
  }

  Future<void> initData() async {
    try {
      result = await _userQuizProvider.getPaged(filter: {
        'pageSize': 100000,
        'userId': int.parse(Autentification.tokenDecoded!["Id"])
      });
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
    return MasterScreenWidget(
      title: AppLocalizations.of(context).quiz_results,
      child: isLoading == true
          ? const Center(child: SpinKitRing(color: Colors.brown))
          : SizedBox(
            child: result!.items.isEmpty ?  Center(child: Text(AppLocalizations.of(context).no_quiz_reuslts)) : ListView.builder(
                itemCount: result!.items.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(AppLocalizations.of(context)
                                          .rate_del_title),
                                      content: Text(AppLocalizations.of(context)
                                          .rate_del_mes),
                                      actions: [
                                        TextButton(
                                            onPressed: (() {
                                              Navigator.pop(context);
                                            }),
                                            child: Text(
                                                AppLocalizations.of(context)
                                                    .cancel)),
                                        TextButton(
                                            onPressed: () async {
                                              try {
                                                await _userQuizProvider.remove(
                                                    result?.items[index].id ?? 0);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .rate_del_su)));
                                                Navigator.pop(context);
                                                initData();
                                              } catch (e) {
                                                alertBoxMoveBack(
                                                    context,
                                                    AppLocalizations.of(context)
                                                        .error,
                                                    e.toString());
                                              }
                                            },
                                            child: const Text('Ok')),
                                      ],
                                    ));
                          },
                        ),
                        title: Text(result!.items[index].quiz?.title ?? ''),
                        trailing: Text("${result!.items[index].percentage}%"),
                        subtitle: Text(formatDate(result!.items[index].createdAt,
                            [dd, '-', mm, '-', yyyy])),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      )
                    ],
                  );
                },
              ),
          ),
    );
  }
}
