// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendResult _$RecommendResultFromJson(Map<String, dynamic> json) =>
    RecommendResult(
      json['id'] as int?,
      json['bookId'] as int?,
      json['firstCobookId'] as int?,
      json['secondCobookId'] as int?,
      json['thirdCobookId'] as int?,
    );

Map<String, dynamic> _$RecommendResultToJson(RecommendResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'firstCobookId': instance.firstCobookId,
      'secondCobookId': instance.secondCobookId,
      'thirdCobookId': instance.thirdCobookId,
    };
