
import 'dart:convert';

import 'package:http/http.dart';

import '../providers/base_provider.dart';

import '../models/book.dart';

class BookProvider extends BaseProvider<Book> {
  BookProvider() : super('Books');

  @override
  Book fromJson(data) {
    return Book.fromJson(data);
  }


  Future<dynamic> deactivate(int bookId) async {
    var url = "${BaseProvider.baseUrl}$endpoint/Deactivate?bookId=$bookId";

    var uri = Uri.parse(url);

   
   
    var headers = createHeaders();

    Response response = await put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = data;

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<dynamic> activate(int bookId) async {
    var url = "${BaseProvider.baseUrl}$endpoint/Activate?bookId=$bookId";

    var uri = Uri.parse(url);
   
    var headers = createHeaders();

    Response response = await put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = data;

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

}
