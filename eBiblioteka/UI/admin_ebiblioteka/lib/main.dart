import 'package:admin_ebiblioteka/providers/answer_provider.dart';
import 'package:admin_ebiblioteka/providers/question_provider.dart';
import 'package:admin_ebiblioteka/providers/quiz_provider.dart';

import 'providers/quotes_provider.dart';

import 'pages/login_page.dart';
import 'providers/author_provider.dart';
import 'providers/book_provider.dart';
import 'providers/bookgenre_provider.dart';
import 'providers/country_provider.dart';
import 'providers/gender_provider.dart';
import 'providers/genre_provider.dart';
import 'providers/photo_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/role_provider.dart';
import 'providers/sign_provider.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';


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
      ChangeNotifierProvider(create: (create)=>BookGenreProvider()),
      ChangeNotifierProvider(create: (create)=>QuoteProvider()),
      ChangeNotifierProvider(create: ((context) => RatingProvider())),
      ChangeNotifierProvider(create: ((context) => QuizProvider())),
      ChangeNotifierProvider(create: ((context) => QuestionProvider())),
      ChangeNotifierProvider(create: ((context) => AnswerProvider()))

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
