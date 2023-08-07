import 'package:admin_ebiblioteka/pages/book_list.dart';
import 'package:admin_ebiblioteka/pages/genre_list.dart';
import 'package:admin_ebiblioteka/detail_pages/profile_setting.dart';
import 'package:admin_ebiblioteka/pages/quiz_list.dart';
import 'package:admin_ebiblioteka/pages/users_list.dart';
import 'package:admin_ebiblioteka/providers/language_provider.dart';
import 'package:admin_ebiblioteka/providers/user_provider.dart';
import 'package:admin_ebiblioteka/utils/util.dart';
import 'package:admin_ebiblioteka/utils/util_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../pages/authors_list.dart';
import '../pages/login_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // TODO: implement initState
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
    try {
      int number = int.parse(Autentification.tokenDecoded!['Id']);
      user = await _userProvider.getById(number);

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
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
          TextButton.icon(
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
              label: Text(
                AppLocalizations.of(context).back,
                style: const TextStyle(color: Colors.white),
              )),
          TextButton.icon(
              onPressed: () {
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
                                    width: 100,
                                    height: 100,
                                  )),
                              const SizedBox(
                                width: 100,
                              ),
                              InkWell(
                                onTap: () {
                                  _languageProvider.changeLanguage('bs');
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/bih.png',
                                  width: 100,
                                  height: 100,
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
              },
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              label: Text(
                AppLocalizations.of(context).language_name,
                style: const TextStyle(color: Colors.white),
              )),
          TextButton.icon(
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title:  Text(AppLocalizations.of(context).log_out),
                          content:
                               Text(AppLocalizations.of(context).logout_mess),
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
                                        (route) =>
                                            false); 

                                  } catch (e) {
                                    alertBoxMoveBack(
                                        context, AppLocalizations.of(context).error, e.toString());
                                  }
                                },
                                child: const Text('Ok')),
                          ],
                        ));
              }),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                AppLocalizations.of(context).log_out,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
      drawer: Drawer(
        child: isLoading
            ? Container()
            : ListView(
                children: [
                  drawerItem(context, AppLocalizations.of(context).books,
                      const BooksPage()),
                  drawerItem(context, AppLocalizations.of(context).authors,
                      const AuthorsPage()),
                  drawerItem(
                      context,
                      AppLocalizations.of(context).users,
                      const UsersPage(
                        roleUser: "User",
                      )),
                  drawerItem(
                      context,
                      AppLocalizations.of(context).admins,
                      const UsersPage(
                        roleUser: "Admin",
                      )),
                  drawerItem(context, AppLocalizations.of(context).genres,
                      const GenresPage()),
                  drawerItem(context, AppLocalizations.of(context).quizes,
                      const QuizzesListPage()),
                  drawerItem(
                      context,
                      AppLocalizations.of(context).profile_settings,
                      ProfileSettingsPage(
                        user: user!,
                      )),
                ],
              ),
      ),
      body: widget.child!,
    );
  }

  ListTile drawerItem(BuildContext context, String title, Widget route) {
    return ListTile(
        title: Text(title),
        onTap: () async {
          var ref = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => route));
          if (ref == "getUser") {
            initUser();
          }
        });
  }
}
