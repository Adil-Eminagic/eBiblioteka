// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      json['id'] as int?,
      json['stars'] as int?,
      json['comment'] as String?,
      json['bookId'] as int?,
      json['userId'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'id': instance.id,
      'stars': instance.stars,
      'comment': instance.comment,
      'userId': instance.userId,
      'user': instance.user,
      'bookId': instance.bookId,
      'book': instance.book,
    };