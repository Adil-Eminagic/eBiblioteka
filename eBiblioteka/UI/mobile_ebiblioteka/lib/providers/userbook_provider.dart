import '../models/userbook.dart';
import '../providers/base_provider.dart';

class UserBookProvider extends BaseProvider<UserBook> {
  UserBookProvider() : super('UserBooks');
  @override
  UserBook fromJson(data) {
    return UserBook.fromJson(data);
  }
}
