import 'package:admin_ebiblioteka/pages/login_page.dart';
import 'package:admin_ebiblioteka/providers/author_provider.dart';
import 'package:admin_ebiblioteka/providers/book_provider.dart';
import 'package:admin_ebiblioteka/providers/bookgenre_provider.dart';
import 'package:admin_ebiblioteka/providers/country_provider.dart';
import 'package:admin_ebiblioteka/providers/gender_provider.dart';
import 'package:admin_ebiblioteka/providers/genre_provider.dart';
import 'package:admin_ebiblioteka/providers/photo_provider.dart';
import 'package:admin_ebiblioteka/providers/role_provider.dart';
import 'package:admin_ebiblioteka/providers/sign_provider.dart';
import 'package:admin_ebiblioteka/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignProvider()),
      ChangeNotifierProvider(create: (s) => AuthorProvider()),
      ChangeNotifierProvider(create: (s) => GenderProvider()),
      ChangeNotifierProvider(create: (create) => CountryProvider()),
      ChangeNotifierProvider(create: (create) => UserProvider()),
      ChangeNotifierProvider(create: (create) => RoleProvider()),
      ChangeNotifierProvider(create: (create) => PhotoProvider()),
      ChangeNotifierProvider(create: (create)=>GenreProvider()),
      ChangeNotifierProvider(create: (create)=>BookProvider()),
      ChangeNotifierProvider(create: (create)=>BookGenreProvider())
    ],
    child:  MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _scafoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scafoldKey,
      title: 'eBiblioteka Admin',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const LoginPage(),
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
