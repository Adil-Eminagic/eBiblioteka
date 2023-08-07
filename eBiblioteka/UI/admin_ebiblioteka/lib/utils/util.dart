import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user.dart';

class Autentification {
  static String? token;
  static Map? tokenDecoded;
  static User? loggedUser;
  //static String? password;
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



//TODOs
//textare biografija
//snackbar
//pagination
//ne treba da se na dugme dohavataju getpaged, koristiti listview.builder
// tašto radi kada reloadmo
//brisanje korisnika
// treba i dugme dohvati radi filtrirnaja
// ** treba password biti password šifriran
// ** da se ne može dva puta ista stranica otvoriti
// ** style of button
// ** smanjivanje base64 string
// ** zabranniti userima da se logiranju na administratora

