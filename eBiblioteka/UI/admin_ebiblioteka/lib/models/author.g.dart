// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['id'] as int?,
      json['fullName'] as String?,
      json['biography'] as String?,
      json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      json['mortalDate'] == null
          ? null
          : DateTime.parse(json['mortalDate'] as String),
      json['genderId'] as int?,
      json['gender'] == null
          ? null
          : Gender.fromJson(json['gender'] as Map<String, dynamic>),
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      json['countryId'] as int?,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'biography': instance.biography,
      'birthDate': instance.birthDate?.toIso8601String(),
      'mortalDate': instance.mortalDate?.toIso8601String(),
      'genderId': instance.genderId,
      'gender': instance.gender,
      'countryId': instance.countryId,
      'country': instance.country,
    };
