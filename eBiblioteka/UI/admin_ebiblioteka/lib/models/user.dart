import 'package:admin_ebiblioteka/models/country.dart';
import 'package:admin_ebiblioteka/models/photo.dart';
import 'package:admin_ebiblioteka/models/role.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:admin_ebiblioteka/models/gender.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  DateTime? lastTimeSignIn;
  String? biography;
  DateTime? birthDate;
  int? genderId;
  Gender? gender;
  int? countryId;
  Country? country;
  int? roleId;
  Role? role;
  int? profilePhotoId;
  Photo? profilePhoto;

  User(
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.biography,
      this.birthDate,
      this.lastTimeSignIn,
      this.genderId,
      this.gender,
      this.country,
      this.countryId,
      this.role,
      this.roleId,
      this.profilePhoto,
      this.profilePhotoId
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
