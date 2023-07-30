import 'dart:io';

import 'package:mobile_ebiblioteka/pages/login_page.dart';
import 'package:mobile_ebiblioteka/providers/recommend_result_provider.dart';
import 'providers/bookfile_provider.dart';
import 'providers/quotes_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/sign_provider.dart';
import 'package:provider/provider.dart';

import 'providers/answer_provider.dart';
import 'providers/author_provider.dart';
import 'providers/book_provider.dart';
import 'providers/bookgenre_provider.dart';
import 'providers/country_provider.dart';
import 'providers/gender_provider.dart';
import 'providers/genre_provider.dart';
import 'providers/photo_provider.dart';
import 'providers/question_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/role_provider.dart';
import 'providers/user_provider.dart';


import 'package:flutter/material.dart';


void main() {
      HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
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
      ChangeNotifierProvider(create: ((context) => QuoteProvider())),
      ChangeNotifierProvider(create: ((context) => RatingProvider())),
       ChangeNotifierProvider(create: ((context) => QuizProvider())),
      ChangeNotifierProvider(create: ((context) => QuestionProvider())),
      ChangeNotifierProvider(create: ((context) => AnswerProvider())),
      ChangeNotifierProvider(create: ((context) => BookFileProvider())),
      ChangeNotifierProvider(create: ((context) => RecommendResultProvider()))
    ],
    child: const  MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown)
      ),
      home: const LoginPage(),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
