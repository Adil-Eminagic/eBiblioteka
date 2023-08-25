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



