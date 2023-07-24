import 'dart:convert';

import 'package:flutter/material.dart';

class Autentification {
  static String? token;
  static Map? tokenDecoded;
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
    height: 250,
    width: 250,
  );
}


//TODOs
//provjera u slučaju da korisnik ne dozvoli ulazak u slike
// context.watch
// scrollanje pagination(video)
//staviti knjifge u listview. builder
//provjeri da li je trycatch block u svakom na adminu
//pokušati logovati errrore i prkazati ih na forntendu npr za password
