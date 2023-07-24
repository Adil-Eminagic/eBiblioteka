
import '../models/role.dart';
import '../providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super('Roles');

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }
}
