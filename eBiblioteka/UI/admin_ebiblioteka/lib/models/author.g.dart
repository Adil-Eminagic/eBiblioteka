// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['id'] as int?,
      json['fullName'] as String?,
      json['biography'] as String?,
      json['birthYear'] as int?,
      json['mortalYear'] as int?,
      json['genderId'] as int?,
      json['gender'] == null
          ? null
          : Gender.fromJson(json['gender'] as Map<String, dynamic>),
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      json['countryId'] as int?,
      json['photoId'] as int?,
      json['photo'] == null
          ? null
          : Photo.fromJson(json['photo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'biography': instance.biography,
      'birthYear': instance.birthYear,
      'mortalYear': instance.mortalYear,
      'genderId': instance.genderId,
      'gender': instance.gender,
      'countryId': instance.countryId,
      'country': instance.country,
      'photoId': instance.photoId,
      'photo': instance.photo,
    };
