import 'package:flutter/cupertino.dart';

class LanguageProvider with ChangeNotifier {
   String lang = 'bs';

  void changeLanguage(String l) {
    lang = l;
    notifyListeners();
  }
}
