import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_ebiblioteka/models/user.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notif {
  int? id;
  String? title;
  String? content;
  bool? isRead;
  int? userId;
  User? user;

  Notif(this.id, this.title, this.content, this.isRead, this.userId,
      this.user);

  factory Notif.fromJson(Map<String, dynamic> json) =>
      _$NotifFromJson(json);

  Map<String, dynamic> toJson() => _$NotifToJson(this);
}
