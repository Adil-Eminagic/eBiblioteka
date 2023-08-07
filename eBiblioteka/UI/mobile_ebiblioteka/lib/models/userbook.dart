import 'package:json_annotation/json_annotation.dart';

part 'userbook.g.dart';

@JsonSerializable()
class UserBook {
  int? id;
  int? bookId;
  int? userId;

  UserBook(this.id, this.bookId, this.userId);

  factory UserBook.fromJson(Map<String, dynamic> json) => _$UserBookFromJson(json);

  Map<String, dynamic> toJson() => _$UserBookToJson(this);
}
