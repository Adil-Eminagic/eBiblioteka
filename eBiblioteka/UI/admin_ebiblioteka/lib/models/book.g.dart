// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      json['id'] as int?,
      json['title'] as String?,
      json['shortDescription'] as String?,
      json['publishingYear'] as int?,
      json['openingCount'] as int?,
      json['coverPhoto'] == null
          ? null
          : Photo.fromJson(json['coverPhoto'] as Map<String, dynamic>),
      json['coverPhotoId'] as int?,
      json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      json['authorID'] as int?,
    )..isActive = json['isActive'] as bool?;

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'publishingYear': instance.publishingYear,
      'openingCount': instance.openingCount,
      'isActive': instance.isActive,
      'coverPhotoId': instance.coverPhotoId,
      'coverPhoto': instance.coverPhoto,
      'authorID': instance.authorID,
      'author': instance.author,
    };
