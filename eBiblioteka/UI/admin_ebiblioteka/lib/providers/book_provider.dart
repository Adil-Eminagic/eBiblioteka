
import 'package:admin_ebiblioteka/providers/base_provider.dart';

import '../models/book.dart';

class BookProvider extends BaseProvider<Book> {
  BookProvider() : super('Books');

  @override
  Book fromJson(data) {
    return Book.fromJson(data);
  }
}
