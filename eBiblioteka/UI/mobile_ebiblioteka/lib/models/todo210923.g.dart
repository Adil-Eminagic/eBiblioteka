// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo210923.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDo210923 _$ToDo210923FromJson(Map<String, dynamic> json) => ToDo210923(
      json['id'] as int?,
      json['activityName'] as String?,
      json['activityDescription'] as String?,
      json['finshingDate'] == null
          ? null
          : DateTime.parse(json['finshingDate'] as String),
      json['statusCode'] as String?,
      json['userId'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToDo210923ToJson(ToDo210923 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activityName': instance.activityName,
      'activityDescription': instance.activityDescription,
      'finshingDate': instance.finshingDate?.toIso8601String(),
      'statusCode': instance.statusCode,
      'userId': instance.userId,
      'user': instance.user,
    };