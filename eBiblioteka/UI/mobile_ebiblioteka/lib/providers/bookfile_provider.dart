import '../models/bookfile.dart';
import '../providers/base_provider.dart';

class BookFileProvider extends BaseProvider<BookFile> {
  BookFileProvider() : super('BookFiles');
  @override
  BookFile fromJson(data) {
    return BookFile.fromJson(data);
  }

  String filerUrl(int id) {
    return "${BaseProvider.baseUrl}$endpoint/$id";
  }
}
