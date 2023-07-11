
import 'package:admin_ebiblioteka/providers/base_provider.dart';

import '../models/genre.dart';

class GenreProvider extends BaseProvider<Genre> {
  GenreProvider() : super('Genres');

  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }
}
