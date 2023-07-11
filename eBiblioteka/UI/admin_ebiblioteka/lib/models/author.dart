import 'package:admin_ebiblioteka/models/country.dart';
import 'package:admin_ebiblioteka/models/photo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:admin_ebiblioteka/models/gender.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  int? id;
  String? fullName;
  String? biography;
  DateTime? birthDate;
  DateTime? mortalDate;
  int? genderId;
  Gender? gender;
  int? countryId;
  Country? country;
  int? photoId;
  Photo? photo;

  Author(
      this.id,
      this.fullName,
      this.biography,
      this.birthDate,
      this.mortalDate,
      this.genderId,
      this.gender,
      this.country,
      this.countryId,
      this.photoId,
      this.photo
      );

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
