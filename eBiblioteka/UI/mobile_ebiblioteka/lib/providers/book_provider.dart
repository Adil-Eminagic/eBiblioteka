import 'package:http/http.dart';

import '../providers/base_provider.dart';

import '../models/book.dart';

class BookProvider extends BaseProvider<Book> {
  BookProvider() : super('Books');

  @override
  Book fromJson(data) {
    return Book.fromJson(data);
  }

  Future openBook(int id) async {
    var url = "${BaseProvider.baseUrl}$endpoint/OpenBook/$id";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await put(uri, headers: headers, body: null);

    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<bool> doesExist(int bookId) async {
    var url = "${BaseProvider.baseUrl}$endpoint/DoesExist/$bookId";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      bool so = response.body == "true" ? true : false;
      return so;
    } else {
      throw Exception("Unknown error");
    }
  }
}
