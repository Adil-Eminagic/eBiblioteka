import 'package:admin_ebiblioteka/special_pages/scroll.dart';

import '../models/answer.dart';
import '../models/author.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/rating.dart';
import '../models/reportinfo.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/answer_provider.dart';
import '../providers/author_provider.dart';
import '../providers/book_provider.dart';
import '../providers/question_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util_widgets.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({Key? key}) : super(key: key);

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  late UserProvider _userProvider = UserProvider();
  late AuthorProvider _authorProvider = AuthorProvider();
  late BookProvider _bookProvider = BookProvider();
  late QuizProvider _quizProvider = QuizProvider();
  late QuestionProvider _questionProvider = QuestionProvider();
  late AnswerProvider _answerProvider = AnswerProvider();
  late RatingProvider _ratingProvider = RatingProvider();

  ReportInfo<User>? adminActive;
  ReportInfo<User>? adminInactive;
  ReportInfo<User>? adminAll;
  ReportInfo<User>? userActive;
  ReportInfo<User>? userInactive;
  ReportInfo<User>? userAll;
  ReportInfo<Book>? bookActive;
  ReportInfo<Book>? bookInactive;
  ReportInfo<Book>? bookAll;
  SearchResult<Quiz>? quizActive;
  SearchResult<Quiz>? quizInactive;
  ReportInfo<Quiz>? quizAll;
  SearchResult<Question>? questionActive;
  SearchResult<Question>? questionInactive;
  ReportInfo<Question>? questionAll;
  ReportInfo<Author>? authorAll;
  ReportInfo<Rating>? ratingOne;
  ReportInfo<Rating>? ratingFive;
  ReportInfo<Rating>? ratingAll;
  ReportInfo<Answer>? answerTrue;
  ReportInfo<Answer>? answerFlase;
  ReportInfo<Answer>? answerAll;

  bool isLoading = true;

 

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _bookProvider = context.read<BookProvider>();
    _quizProvider = context.read<QuizProvider>();
    _authorProvider = context.read<AuthorProvider>();
    _questionProvider = context.read<QuestionProvider>();
    _answerProvider = context.read<AnswerProvider>();
    _ratingProvider = context.read<RatingProvider>();

    initData();
  }


  Future<void> initData() async {
    try {
      adminActive = await _userProvider
          .getCount(filter: {'roleName': 'Admin', 'isActive': true});
      adminInactive = await _userProvider
          .getCount(filter: {'roleName': 'Admin', 'isActive': false});
      adminAll = await _userProvider.getCount(filter: {'roleName': 'Admin'});
      userActive = await _userProvider
          .getCount(filter: {'roleName': "User", 'isActive': true});
      userInactive = await _userProvider
          .getCount(filter: {'roleName': "User", 'isActive': false});
      userAll = await _userProvider.getCount(filter: {'roleName': "User"});
      bookActive = await _bookProvider.getCount(filter: {'isActive': true});
      bookInactive = await _bookProvider.getCount(filter: {'isActive': false});
      bookAll = await _bookProvider.getCount();
      quizActive = await _quizProvider.getPaged(filter: {'isActive': true});
      quizInactive = await _quizProvider.getPaged(filter: {'isActive': false});
      quizAll = await _quizProvider.getCount();
      questionActive =
          await _questionProvider.getPaged(filter: {'isActive': true});
      questionInactive =
          await _questionProvider.getPaged(filter: {'isActive': false});
      questionAll = await _questionProvider.getCount();
      authorAll = await _authorProvider.getCount();
      ratingOne = await _ratingProvider.getCount(filter: {'stars': 1});
      ratingFive = await _ratingProvider.getCount(filter: {'stars': 5});
      ratingAll = await _ratingProvider.getCount();
      answerTrue = await _answerProvider.getCount(filter: {'isTrue': true});
      answerFlase = await _answerProvider.getCount(filter: {'isTrue': false});
      answerAll = await _answerProvider.getCount();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).report,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 100, 40, 20),
          child: isLoading == true
              ? const Center(
                  child: SpinKitRing(color: Colors.brown),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 166,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _activeCard(
                                    AppLocalizations.of(context).admins,
                                    adminActive!.totalCount,
                                    adminActive!.totalCount,
                                    adminAll!.totalCount),
                                const SizedBox(
                                  width: 50,
                                ),
                                _activeCard(
                                    AppLocalizations.of(context).users,
                                    userActive!.totalCount,
                                    userInactive!.totalCount,
                                    userAll!.totalCount),
                                   
                                 const SizedBox(
                                  width: 50,
                                ),
                                Card(
                                  child: Container(
                                    color: Colors.brown,
                                    width: 250,
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context).books,
                                            style: const TextStyle(
                                                fontSize: 23, color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context).active}: ${bookActive!.totalCount}',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              '${AppLocalizations.of(context).inactive}:  ${bookInactive!.totalCount}',
                                              style:
                                                  const TextStyle(color: Colors.white)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              '${AppLocalizations.of(context).overall}:  ${bookAll!.totalCount}',
                                              style: const TextStyle(color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                _activeCard(
                                    AppLocalizations.of(context).quizes,
                                    quizActive!.totalCount,
                                    quizInactive!.totalCount,
                                    quizAll!.totalCount),
                                    
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                   const SizedBox(height: 130,),
                    SizedBox(
                      height: 166,
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Container(
                                  color: Colors.brown,
                                  width: 250,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).questions,
                                          style: const TextStyle(
                                              fontSize: 23, color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context).active_n}: ${questionActive!.totalCount}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).inactive_n}:  ${questionInactive!.totalCount}',
                                            style:
                                                const TextStyle(color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).overall}:  ${questionAll!.totalCount}',
                                            style: const TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              _plainCard(AppLocalizations.of(context).authors,
                                  authorAll!.totalCount),
                                  const SizedBox(
                                width: 50,
                              ),
                              Card(
                                child: Container(
                                  color: Colors.brown,
                                  width: 250,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).rates,
                                          style: const TextStyle(
                                              fontSize: 23, color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context).one_star}: ${ratingOne!.totalCount}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).five_stars}: ${ratingFive!.totalCount}',
                                            style:
                                                const TextStyle(color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).overall}: ${ratingAll!.totalCount}',
                                            style: const TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Card(
                                child: Container(
                                  color: Colors.brown,
                                  width: 250,
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).rates,
                                          style: const TextStyle(
                                              fontSize: 23, color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context).trues}: ${answerTrue!.totalCount}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).falses}: ${answerFlase!.totalCount}',
                                            style:
                                                const TextStyle(color: Colors.white)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${AppLocalizations.of(context).overall}: ${answerAll!.totalCount}',
                                            style: const TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Card _plainCard(String title, int overallCount) {
    return Card(
      child: Container(
        color: Colors.brown,
        width: 250,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 23, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('', style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              Text('${AppLocalizations.of(context).overall}: $overallCount',
                  style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  Card _activeCard(
      String title, int activeCount, int inactiveCount, int overallCount) {
    return Card(
      child: Container(
        color: Colors.brown,
        width: 250,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 23, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${AppLocalizations.of(context).active_m}: $activeCount',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${AppLocalizations.of(context).inactive_m}: $inactiveCount',
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              Text('${AppLocalizations.of(context).overall}: $overallCount',
                  style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
