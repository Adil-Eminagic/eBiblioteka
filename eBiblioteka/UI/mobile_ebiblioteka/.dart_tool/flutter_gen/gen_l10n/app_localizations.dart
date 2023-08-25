
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('en')
  ];

  /// No description provided for @language_name.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_name;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @authors.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get authors;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @admins.
  ///
  /// In en, this message translates to:
  /// **'Administrators'**
  String get admins;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @quizes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizes;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Profile settings'**
  String get profile_settings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @wrote.
  ///
  /// In en, this message translates to:
  /// **'Wrote in'**
  String get wrote;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @birth_date.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birth_date;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @no_quizzes.
  ///
  /// In en, this message translates to:
  /// **'No added quizzes'**
  String get no_quizzes;

  /// No description provided for @lname.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lname;

  /// No description provided for @telphone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telphone;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @mfield.
  ///
  /// In en, this message translates to:
  /// **'Mandatory field'**
  String get mfield;

  /// No description provided for @su_mod_profie.
  ///
  /// In en, this message translates to:
  /// **'Profile is successsfully updated.'**
  String get su_mod_profie;

  /// No description provided for @choose_image.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get choose_image;

  /// No description provided for @change_image.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get change_image;

  /// No description provided for @mvalue.
  ///
  /// In en, this message translates to:
  /// **'You have to input value'**
  String get mvalue;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @reg_password.
  ///
  /// In en, this message translates to:
  /// **'Password has to contain at least 8 characters, lowercase and uppercase letters and numbers.'**
  String get reg_password;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @short_desc.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get short_desc;

  /// No description provided for @publishing_year.
  ///
  /// In en, this message translates to:
  /// **'Publishing year'**
  String get publishing_year;

  /// No description provided for @mod_b_genres.
  ///
  /// In en, this message translates to:
  /// **'Modify book\'s genres'**
  String get mod_b_genres;

  /// No description provided for @mod_b_quotes.
  ///
  /// In en, this message translates to:
  /// **'Modify book\'s quotes'**
  String get mod_b_quotes;

  /// No description provided for @mod_b_rates.
  ///
  /// In en, this message translates to:
  /// **'Book\'s rates'**
  String get mod_b_rates;

  /// No description provided for @book_id.
  ///
  /// In en, this message translates to:
  /// **'Book id'**
  String get book_id;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @new_book.
  ///
  /// In en, this message translates to:
  /// **'New book'**
  String get new_book;

  /// No description provided for @no_genres.
  ///
  /// In en, this message translates to:
  /// **'No genres'**
  String get no_genres;

  /// No description provided for @logout_mess.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out from app?'**
  String get logout_mess;

  /// No description provided for @mortal_date.
  ///
  /// In en, this message translates to:
  /// **'Mortal date'**
  String get mortal_date;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get admin;

  /// No description provided for @new_lbl.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_lbl;

  /// No description provided for @name_2.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_2;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Qiuestions'**
  String get questions;

  /// No description provided for @numeric_field.
  ///
  /// In en, this message translates to:
  /// **'Value must be numeric'**
  String get numeric_field;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @true_val.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get true_val;

  /// No description provided for @false_val.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get false_val;

  /// No description provided for @is_true.
  ///
  /// In en, this message translates to:
  /// **'Is true'**
  String get is_true;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @quotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get quotes;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get user_name;

  /// No description provided for @rates.
  ///
  /// In en, this message translates to:
  /// **'Book ratings'**
  String get rates;

  /// No description provided for @rate_del_su.
  ///
  /// In en, this message translates to:
  /// **'Rating is successsfully deleted'**
  String get rate_del_su;

  /// No description provided for @rate_del_title.
  ///
  /// In en, this message translates to:
  /// **'Deleting rating'**
  String get rate_del_title;

  /// No description provided for @rate_del_mes.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this rating?'**
  String get rate_del_mes;

  /// No description provided for @no_rates.
  ///
  /// In en, this message translates to:
  /// **'No ratings for this book'**
  String get no_rates;

  /// No description provided for @no_profile.
  ///
  /// In en, this message translates to:
  /// **'No profile'**
  String get no_profile;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @no_books.
  ///
  /// In en, this message translates to:
  /// **'No books'**
  String get no_books;

  /// No description provided for @search_by.
  ///
  /// In en, this message translates to:
  /// **'Search by'**
  String get search_by;

  /// No description provided for @titles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get titles;

  /// No description provided for @value_name.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value_name;

  /// No description provided for @no_result.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get no_result;

  /// No description provided for @choose_genre.
  ///
  /// In en, this message translates to:
  /// **'Choose genre'**
  String get choose_genre;

  /// No description provided for @mgenre.
  ///
  /// In en, this message translates to:
  /// **'Genre is mandatory'**
  String get mgenre;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @new_email.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get new_email;

  /// No description provided for @su_sign_up.
  ///
  /// In en, this message translates to:
  /// **'successsfully signed up'**
  String get su_sign_up;

  /// No description provided for @start_quiz.
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get start_quiz;

  /// No description provided for @max_points.
  ///
  /// In en, this message translates to:
  /// **'Maximum points'**
  String get max_points;

  /// No description provided for @next_question.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get next_question;

  /// No description provided for @manswer.
  ///
  /// In en, this message translates to:
  /// **'\'You have to choose answer'**
  String get manswer;

  /// No description provided for @finish_quiz.
  ///
  /// In en, this message translates to:
  /// **'Finish quiz'**
  String get finish_quiz;

  /// No description provided for @leave_quiz_tit.
  ///
  /// In en, this message translates to:
  /// **'Leave quit'**
  String get leave_quiz_tit;

  /// No description provided for @leave_quiz_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to finish the quiz?\nResults will be deleted.'**
  String get leave_quiz_msg;

  /// No description provided for @question_num.
  ///
  /// In en, this message translates to:
  /// **'Question number'**
  String get question_num;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rate;

  /// No description provided for @rec_books.
  ///
  /// In en, this message translates to:
  /// **'Recommended books for you'**
  String get rec_books;

  /// No description provided for @see_rates.
  ///
  /// In en, this message translates to:
  /// **'See ratings'**
  String get see_rates;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @no_reading.
  ///
  /// In en, this message translates to:
  /// **'Reading is not avaliable'**
  String get no_reading;

  /// No description provided for @no_short_de.
  ///
  /// In en, this message translates to:
  /// **'There is no short description'**
  String get no_short_de;

  /// No description provided for @no_quotes.
  ///
  /// In en, this message translates to:
  /// **'There are no quotes'**
  String get no_quotes;

  /// No description provided for @rate_action.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate_action;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @rate_del_lbl.
  ///
  /// In en, this message translates to:
  /// **'Delete rating'**
  String get rate_del_lbl;

  /// No description provided for @rate_new.
  ///
  /// In en, this message translates to:
  /// **'New rating'**
  String get rate_new;

  /// No description provided for @rate_mod.
  ///
  /// In en, this message translates to:
  /// **'Edit rating'**
  String get rate_mod;

  /// No description provided for @rate_add_su.
  ///
  /// In en, this message translates to:
  /// **'Rating is successsfully added'**
  String get rate_add_su;

  /// No description provided for @rate_mod_su.
  ///
  /// In en, this message translates to:
  /// **'Rating is successsfully updated'**
  String get rate_mod_su;

  /// No description provided for @mebership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get mebership;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get purchase;

  /// No description provided for @inactive_meb.
  ///
  /// In en, this message translates to:
  /// **'Your membership is inactive. To activate membership you need to buy it.'**
  String get inactive_meb;

  /// No description provided for @su_payed.
  ///
  /// In en, this message translates to:
  /// **'Membership is successsfully purchased.\n Your membership last for a year.'**
  String get su_payed;

  /// No description provided for @forbid_users.
  ///
  /// In en, this message translates to:
  /// **'Superadmin and admin are not allowd to use mobile application'**
  String get forbid_users;

  /// No description provided for @cur_email.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get cur_email;

  /// No description provided for @changing_email.
  ///
  /// In en, this message translates to:
  /// **'Changing email'**
  String get changing_email;

  /// No description provided for @su_cha_email.
  ///
  /// In en, this message translates to:
  /// **'Email is successfully changed'**
  String get su_cha_email;

  /// No description provided for @su_mod_password.
  ///
  /// In en, this message translates to:
  /// **'Password is successfully changed'**
  String get su_mod_password;

  /// No description provided for @pass_no_matc.
  ///
  /// In en, this message translates to:
  /// **'New password and confirm password don\'t match.'**
  String get pass_no_matc;

  /// No description provided for @pass_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get pass_confirm;

  /// No description provided for @changign_password.
  ///
  /// In en, this message translates to:
  /// **'Changing password'**
  String get changign_password;

  /// No description provided for @reading_hist.
  ///
  /// In en, this message translates to:
  /// **'Reading history'**
  String get reading_hist;

  /// No description provided for @your_result.
  ///
  /// In en, this message translates to:
  /// **'Your result'**
  String get your_result;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @result_text.
  ///
  /// In en, this message translates to:
  /// **'You have won'**
  String get result_text;

  /// No description provided for @result_text_2.
  ///
  /// In en, this message translates to:
  /// **', which is'**
  String get result_text_2;

  /// No description provided for @su_add_quizres.
  ///
  /// In en, this message translates to:
  /// **'Successfully added quiz result'**
  String get su_add_quizres;

  /// No description provided for @quiz_results.
  ///
  /// In en, this message translates to:
  /// **'Quizzes\' results'**
  String get quiz_results;

  /// No description provided for @result_del_su.
  ///
  /// In en, this message translates to:
  /// **'Quiz reslut is successfully deleted'**
  String get result_del_su;

  /// No description provided for @result_del_title.
  ///
  /// In en, this message translates to:
  /// **'Deleting quiz result'**
  String get result_del_title;

  /// No description provided for @result_del_mes.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete quiz result?'**
  String get result_del_mes;

  /// No description provided for @dec_account.
  ///
  /// In en, this message translates to:
  /// **'You cann\'t log in because your account is deactivated'**
  String get dec_account;

  /// No description provided for @no_open_rate.
  ///
  /// In en, this message translates to:
  /// **'You cann\'t modify others ratings, only yours'**
  String get no_open_rate;

  /// No description provided for @no_read_hist.
  ///
  /// In en, this message translates to:
  /// **'No read books'**
  String get no_read_hist;

  /// No description provided for @error_pay.
  ///
  /// In en, this message translates to:
  /// **'Error with payment'**
  String get error_pay;

  /// No description provided for @cancel_payment.
  ///
  /// In en, this message translates to:
  /// **'Payment is canceled'**
  String get cancel_payment;

  /// No description provided for @no_quiz_reuslts.
  ///
  /// In en, this message translates to:
  /// **'No quiz results'**
  String get no_quiz_reuslts;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bs': return AppLocalizationsBs();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
