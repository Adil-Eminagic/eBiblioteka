import 'dart:convert';

import 'package:admin_ebiblioteka/models/author.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthorProvider extends BaseProvider<Author> {
  AuthorProvider() : super('Authors');
  @override
  Author fromJson(data) {
    return Author.fromJson(data);
  }
}
