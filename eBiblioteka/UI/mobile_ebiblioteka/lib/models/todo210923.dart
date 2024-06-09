import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_ebiblioteka/models/user.dart';

part 'todo210923.g.dart';

@JsonSerializable()
class ToDo210923 {
  int? id;
  String? activityName;
  String? activityDescription;
  DateTime? finshingDate;
  String? statusCode;
  int? userId;
  User? user;

  ToDo210923(this.id, this.activityName, this.activityDescription,
      this.finshingDate, this.statusCode, this.userId, this.user);

  factory ToDo210923.fromJson(Map<String, dynamic> json) =>
      _$ToDo210923FromJson(json);

  Map<String, dynamic> toJson() => _$ToDo210923ToJson(this);
}
