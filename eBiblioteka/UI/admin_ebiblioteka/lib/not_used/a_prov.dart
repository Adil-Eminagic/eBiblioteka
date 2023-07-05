/*
import 'dart:convert';

import 'package:admin_ebiblioteka/models/author.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthorProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "api/Authors/Getpaged";

  AuthorProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://localhost:7034/");
  }

  Future<SearchResult<Author>> getPaged({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var querryString = getQueryString(filter);
      url = "$url?$querryString";
    }

    var uri = Uri.parse(url);

    Response response = await get(uri);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Author>();
      result.hasNextPage = data['hasNextPage'];
      result.hasPreviousPage = data['hasPreviousPage'];
      result.isFirstPage = data['isFirstPage'];
      result.isLastPage = data['isLastPage'];
      result.pageCount = data['pageCount'];
      result.pageNumber = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalCount = data['totalCount'];

      for (var a in data['items']) {
        result.items.add(Author.fromJson(a));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    print(response.body);
    throw Exception("Something bad happened please try again");
  }
}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '';
  params.forEach((key, value) {
    if (inRecursion) {
      if (key is int) {
        key = '[$key]';
      } else if (value is List || value is Map) {
        key = '.$key';
      } else {
        key = '.$key';
      }
    }
    if (value is String || value is int || value is double || value is bool) {
      var encoded = value;
      if (value is String) {
        encoded = Uri.encodeComponent(value);
      }
      query += '$prefix$key=$encoded';
    } else if (value is DateTime) {
      query += '$prefix$key=${(value as DateTime).toIso8601String()}';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });
  return query;
}


*/