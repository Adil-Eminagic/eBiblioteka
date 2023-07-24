import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ebiblioteka/pages/profil_setting.dart';
import 'package:mobile_ebiblioteka/pages/quiz_page.dart';
import 'package:mobile_ebiblioteka/special_pages/pdf_show.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../pages/home_page.dart';

import '../pages/login_page.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

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
          IconButton(onPressed: (() {
            //
          }), icon: const Icon(Icons.language))
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
                  Text("${user?.firstName} ${user?.lastName}", style: const TextStyle(color: Colors.white, fontSize: 17)),
                  const SizedBox(height: 2.5,),
                  Text("${user?.email}",style: const TextStyle(color: Colors.white, fontSize: 17) )
                ],
              ),
            ),
          ),
          drawerItem(context, "Početna", const HomePage(), Icons.home),
          drawerItem(context, "Kvizovi", const QuizzesListPage(), Icons.quiz),

          drawerItem(
              context,
              'Postavke profila',
              ProfileSettings(
                user: user,
              ),
              Icons.settings),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Odjava'),
            onTap: () {
              Autentification.token = '';

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false); // briše čitav stack ruta
            },
          ),
          drawerItem(context, 'Pdf', const PdfShowPage())
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
