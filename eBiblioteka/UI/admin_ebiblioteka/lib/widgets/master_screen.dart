import 'package:admin_ebiblioteka/utils/util.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          if (!ModalRoute.of(context)!.isFirst) Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
        color: Colors.brown,
      ),
      appBar: AppBar(
        title: Text(
          widget.title ?? "",
        ),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Autentification.token = '';

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
            label: const Text("Odjava"),
          )
        ],
        //leading:  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        // actions: [
        //   IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back))
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerItem(context, "Autori", AuthorsPage()),
            DrawerItem(context, "Logout", LoginPage()),
           
          ],
        ),
      ),
      body: widget.child!,
    );
  }

  ListTile DrawerItem(BuildContext context, String title, Widget route) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => route)),
    );
  }
}
