
import 'package:admin_ebiblioteka/models/gender.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super('Genders');

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }
}
