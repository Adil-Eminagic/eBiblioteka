
import 'package:admin_ebiblioteka/models/country.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super('Countries');

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}
