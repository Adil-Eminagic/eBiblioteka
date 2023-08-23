import 'package:json_annotation/json_annotation.dart';

part 'userquiz.g.dart';

@JsonSerializable()
class UserQuiz {
  int? id;
  int? quizId;
  int? userId;
  double percentage;
  DateTime createdAt;


  UserQuiz(this.id, this.quizId, this.userId, this.percentage, this.createdAt);

  factory UserQuiz.fromJson(Map<String, dynamic> json) => _$UserQuizFromJson(json);

  Map<String, dynamic> toJson() => _$UserQuizToJson(this);
}
