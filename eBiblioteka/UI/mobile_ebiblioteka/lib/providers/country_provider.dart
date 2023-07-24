
import '../models/country.dart';
import '../providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super('Countries');

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}
