

import 'package:admin_ebiblioteka/providers/base_provider.dart';

import '../models/bookgenre.dart';

class BookGenreProvider extends BaseProvider<BookGenre> {
  BookGenreProvider() : super('BookGenres');

  @override
  BookGenre fromJson(data) {
    return BookGenre.fromJson(data);
  }
}
