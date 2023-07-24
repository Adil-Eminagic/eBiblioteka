import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import '../models/search_result.dart';
import '../utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? baseUrl;
  String endpoint = "api/";

  BaseProvider(String point) {
    endpoint += point;
    baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://10.0.2.2:7034/");
  }

  Future<SearchResult<T>> getPaged({dynamic filter}) async {
    var url = "$baseUrl$endpoint/GetPaged";

    if (filter != null) {
      var querryString = getQueryString(filter);
      url = "$url?$querryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();
      result.hasNextPage = data['hasNextPage'];
      result.hasPreviousPage = data['hasPreviousPage'];
      result.isFirstPage = data['isFirstPage'];
      result.isLastPage = data['isLastPage'];
      result.pageCount = data['pageCount'];
      result.pageNumber = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalCount = data['totalCount'];

      for (var a in data['items']) {
        result.items.add(fromJson(a));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic object) async {
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(object);

    Response response = await post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(dynamic object) async {
    // [ ] znaci opcionalno
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(object);

    Response response = await put(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future remove(int id) async {
    // [ ] znaci opcionalno
    var url = "$baseUrl$endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await delete(uri, headers: headers);
    if (isValidResponse(response)) {
      print('Uspjesno brisanje');
    } else {
      throw Exception("Unknown error");
    }
  }

  Future getById(int id) async {
    var url = "$baseUrl$endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("not implemented");
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    print(response.body);
    throw Exception(
        "Something bad happened please try again, staus code ${response.statusCode}");
  }
}

Map<String, String> createHeaders() {
  String jwt = Autentification.token ?? '';

  String jwtAuth = "Bearer $jwt";

  var headers = {"Content-Type": "application/json", "Authorization": jwtAuth};

  return headers;
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
