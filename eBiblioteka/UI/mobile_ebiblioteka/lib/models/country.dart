import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  int? id;
  String? name;
  String? abbreviation;
  bool? isActive;

  Country(this.id, this.name, this.abbreviation, this.isActive);

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
