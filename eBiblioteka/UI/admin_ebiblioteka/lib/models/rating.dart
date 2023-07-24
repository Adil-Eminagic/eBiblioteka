import 'package:json_annotation/json_annotation.dart';
import '../models/book.dart';
import '../models/user.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  int? id;
  int? stars;
  String? comment;
  DateTime? dateTime;
  int? userId;
  User? user;
  int? bookId;
  Book? book;

  Rating(this.id, this.stars, this.comment, this.dateTime, this.bookId,
      this.userId, this.user, this.book);

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
