import 'dart:ffi';

import '../models/country.dart';
import '../models/photo.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/gender.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  int? id;
  String? fullName;
  String? biography;
  int? birthYear;
  int? mortalYear;
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
      this.birthYear,
      this.mortalYear,
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
