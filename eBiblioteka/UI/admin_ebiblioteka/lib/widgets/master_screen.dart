
import 'package:admin_ebiblioteka/pages/book_list.dart';
import 'package:admin_ebiblioteka/pages/genre_list.dart';
import 'package:admin_ebiblioteka/detail_pages/profile_setting.dart';
import 'package:admin_ebiblioteka/pages/quiz_list.dart';
import 'package:admin_ebiblioteka/pages/users_list.dart';
import 'package:admin_ebiblioteka/providers/user_provider.dart';
import 'package:admin_ebiblioteka/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../pages/authors_list.dart';
import '../pages/login_page.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;

  MasterScreenWidget({super.key, this.child, this.title});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  User? user;
  late UserProvider _userProvider = UserProvider();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = context.read<UserProvider>();
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

    setState(() {
      isLoading = false;
    });
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
              label: const Text(
                'Nazad',
                style: TextStyle(color: Colors.white),
              )),
          TextButton.icon(
              onPressed: (() {
                Autentification.token = '';

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false); // briše čitav stack ruta
              }
              ),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: const Text(
                'Odjava',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      drawer: Drawer(
        child: isLoading
            ? Container()
            : ListView(
                children: [
                  drawerItem(context, 'Knjige', const BooksPage()),
                  drawerItem(context, "Autori", const AuthorsPage()),
                  drawerItem(
                      context,
                      "Korisnici",
                      const UsersPage(
                        roleUser: "User",
                      )),
                  drawerItem(
                      context,
                      "Administratori",
                      const UsersPage(
                        roleUser: "Admin",
                      )),
                  drawerItem(context, 'Žarovi', const GenresPage()),
                  drawerItem(context, 'Kvizovi', const QuizzesListPage()),
                  drawerItem(
                      context,
                      'Postavke profila',
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
