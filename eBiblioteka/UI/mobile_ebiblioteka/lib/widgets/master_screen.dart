import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/pages/profil_setting.dart';
import 'package:mobile_ebiblioteka/pages/quiz_page.dart';
import 'package:mobile_ebiblioteka/pages/readning_history.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../pages/home_page.dart';

import '../pages/login_page.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/util_widgets.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;

  const MasterScreenWidget({super.key, this.child, this.title});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  User? user;
  late UserProvider _userProvider = UserProvider();
  late LanguageProvider _languageProvider = LanguageProvider();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _languageProvider = context.read<LanguageProvider>();

    if (user == null) {
      initUser();
    } else {
      if (user!.id != Autentification.tokenDecoded!['Id']) {
        initState();
      }
    }
  }

  Future<void> initUser() async {
    int number = int.parse(Autentification.tokenDecoded!['Id']);
    user = await _userProvider.getById(number);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? "",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (() {
              if (!ModalRoute.of(context)!.isFirst) {
                Navigator.pop(context,
                    'reload2'); // provjerava da li je prva ruta da se izbjegne prazana rpoute stack
              }
            }),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: (() {
                                    _languageProvider.changeLanguage('en');
                                    Navigator.pop(context);
                                  }),
                                  child: Image.asset(
                                    'assets/uk.png',
                                    width: 70,
                                    height: 70,
                                  )),
                              const SizedBox(
                                width: 50,
                              ),
                              InkWell(
                                onTap: () {
                                  _languageProvider.changeLanguage('bs');
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/bih.png',
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    Text(AppLocalizations.of(context).cancel)),
                          ],
                        ));
              }),
              icon: const Icon(Icons.language))
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          Container(
            height: 150,
            color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(21, 0, 0, 17),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${user?.firstName} ${user?.lastName}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 17)),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text("${user?.email}",
                      style: const TextStyle(color: Colors.white, fontSize: 17))
                ],
              ),
            ),
          ),
          drawerItem(context, AppLocalizations.of(context).home,
              const HomePage(), Icons.home),
          drawerItem(context, AppLocalizations.of(context).reading_hist,
              const ReadingHistoryPage(), Icons.history),

          drawerItem(context, AppLocalizations.of(context).quizes,
              const QuizzesListPage(), Icons.quiz),

          drawerItem(
              context,
              AppLocalizations.of(context).profile_settings,
              ProfileSettings(
                user: user,
              ),
              Icons.settings),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context).log_out),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(AppLocalizations.of(context).log_out),
                        content: Text(AppLocalizations.of(context).logout_mess),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.pop(context);
                              }),
                              child: Text(AppLocalizations.of(context).cancel)),
                          TextButton(
                              onPressed: () async {
                                try {
                                  Autentification.token = '';

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const LoginPage()),
                                      (route) => false);
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
          ),
          
        ]),
      ),
      body: widget.child!,
    );
  }

  ListTile drawerItem(BuildContext context, String title, Widget route,
      [IconData? iconData]) {
    return ListTile(
        title: Text(title),
        leading: iconData != null ? Icon(iconData) : null,
        onTap: () async {
          var ref = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => route));
          if (ref == "getUser") {
            initUser();
            Navigator.pop(context);
          }
        });
  }
}
