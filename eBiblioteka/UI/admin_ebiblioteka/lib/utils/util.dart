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

ButtonStyle buttonStyleSecondary = ElevatedButton.styleFrom(
    primary: Colors.brown[100], onPrimary: Colors.black);

ButtonStyle buttonStyleSecondaryDelete = ElevatedButton.styleFrom(
    primary: Colors.brown[100], onPrimary: Colors.red);


// in genre detail, you cann't have ecpanded with child coulum niside column, bacause
// expanded and listview need to know exact height and widht
// by default column takes all height and widht as needed, row oposstite
// so you nedd to have row as expamded in column, because both w and h ara bounded with row and column