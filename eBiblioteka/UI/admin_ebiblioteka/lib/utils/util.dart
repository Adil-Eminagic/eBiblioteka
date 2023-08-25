import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';

class Autentification {
  static String? token;
  static Map? tokenDecoded;
  static User? loggedUser;
}

class Language {
  static String lang = 'bs';
}

dynamic DateEncode(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(
    base64Decode(base64Image),
    height: 400,
    width: 400,
  );
}




