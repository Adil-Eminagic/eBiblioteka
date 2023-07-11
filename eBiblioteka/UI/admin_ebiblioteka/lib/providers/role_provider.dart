
import 'package:admin_ebiblioteka/models/role.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super('Roles');

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }
}
