// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['biography'] as String?,
      json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      json['lastTimeSignIn'] == null
          ? null
          : DateTime.parse(json['lastTimeSignIn'] as String),
      json['genderId'] as int?,
      json['gender'] == null
          ? null
          : Gender.fromJson(json['gender'] as Map<String, dynamic>),
      json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      json['countryId'] as int?,
      json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      json['roleId'] as int?,
      json['profilePhoto'] == null
          ? null
          : Photo.fromJson(json['profilePhoto'] as Map<String, dynamic>),
      json['profilePhotoId'] as int?,
      json['isActive'] as bool,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'lastTimeSignIn': instance.lastTimeSignIn?.toIso8601String(),
      'biography': instance.biography,
      'birthDate': instance.birthDate?.toIso8601String(),
      'genderId': instance.genderId,
      'gender': instance.gender,
      'countryId': instance.countryId,
      'country': instance.country,
      'roleId': instance.roleId,
      'role': instance.role,
      'profilePhotoId': instance.profilePhotoId,
      'profilePhoto': instance.profilePhoto,
      'isActive': instance.isActive,
    };
