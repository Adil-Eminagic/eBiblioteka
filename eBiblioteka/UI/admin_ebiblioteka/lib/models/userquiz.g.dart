// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userquiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserQuiz _$UserQuizFromJson(Map<String, dynamic> json) => UserQuiz(
      json['id'] as int?,
      json['quizId'] as int?,
      json['userId'] as int?,
      (json['percentage'] as num).toDouble(),
      DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserQuizToJson(UserQuiz instance) => <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'userId': instance.userId,
      'percentage': instance.percentage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
