
import 'package:admin_ebiblioteka/providers/base_provider.dart';

import '../models/user.dart';


class UserProvider extends BaseProvider<User> {
  UserProvider() : super('Users');

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}
