// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notif _$NotifFromJson(Map<String, dynamic> json) => Notif(
      json['id'] as int?,
      json['title'] as String?,
      json['content'] as String?,
      json['isRead'] as bool?,
      json['userId'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotifToJson(Notif instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'isRead': instance.isRead,
      'userId': instance.userId,
      'user': instance.user,
    };
