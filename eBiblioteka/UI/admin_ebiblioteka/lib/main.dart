import 'package:admin_ebiblioteka/pages/login_page.dart';
import 'package:admin_ebiblioteka/providers/author_provider.dart';
import 'package:admin_ebiblioteka/providers/country_provider.dart';
import 'package:admin_ebiblioteka/providers/gender_provider.dart';
import 'package:admin_ebiblioteka/providers/sign_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>SignProvider()),
      ChangeNotifierProvider(create: (s)=>AuthorProvider()),
      ChangeNotifierProvider(create: (s)=>GenderProvider()),
      ChangeNotifierProvider(create: (create)=>CountryProvider())
    ],
    child:const MyApp(),)
   );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eBiblioteka Admin',
     
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home:const  LoginPage(),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}