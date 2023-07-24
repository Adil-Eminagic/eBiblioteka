
import '../models/gender.dart';
import '../providers/base_provider.dart';

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super('Genders');

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }
}
