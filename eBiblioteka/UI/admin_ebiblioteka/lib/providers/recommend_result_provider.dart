import 'dart:convert';

import '../models/recommend_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/search_result.dart';
import '../utils/util.dart';

class RecommendResultProvider extends ChangeNotifier {
  String? _baseUrl;
  final String _endpoint = "api/RecommendResults";

  RecommendResultProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7034/");
  }

  Future<dynamic> getPaged(String em, String ps, {dynamic filter}) async {
    var url = "$_baseUrl$_endpoint/GetPaged";

    if (filter != null) {
      var querryString = getQueryString(filter);
      url = "$url?$querryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<RecommendResult>();
      result.hasNextPage = data['hasNextPage'];
      result.hasPreviousPage = data['hasPreviousPage'];
      result.isFirstPage = data['isFirstPage'];
      result.isLastPage = data['isLastPage'];
      result.pageCount = data['pageCount'];
      result.pageNumber = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalCount = data['totalCount'];

      for (var a in data['items']) {
        result.items.add(RecommendResult.fromJson(a));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

 Future trainData() async {
    var url = "$_baseUrl$_endpoint/TrainModelAsync";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await post(
      uri,
      headers: headers,
    );
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

 Future deleteData() async {
    var url = "$_baseUrl$_endpoint/ClearRecommendation";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await delete(
      uri,
      headers: headers,
    );
    if (isValidResponse(response)) {

    } else {
      throw Exception("Unknown error");
    }
  }


  Future getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await get(uri, headers: headers);
    if (isValidResponse(response)) {
      if (response.body != "") {
        var data = jsonDecode(response.body);

        return RecommendResult.fromJson(data);
      }
    } else {
      throw Exception("Unknown error");
    }
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception(
        "Something bad happened please try again,\n${response.body}");
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

Map<String, String> createHeaders() {
  String jwt = Autentification.token ?? '';

  String jwtAuth = "Bearer $jwt";

  var headers = {"Content-Type": "application/json", "Authorization": jwtAuth};

  return headers;
}
