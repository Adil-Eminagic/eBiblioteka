
import '../models/author.dart';
import '../providers/base_provider.dart';

class AuthorProvider extends BaseProvider<Author> {
  AuthorProvider() : super('Authors');
  @override
  Author fromJson(data) {
    return Author.fromJson(data);
  }
}
