// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      json['id'] as int?,
      json['content'] as String?,
      json['bookId'] as int?,
      json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'bookId': instance.bookId,
      'book': instance.book,
    };
