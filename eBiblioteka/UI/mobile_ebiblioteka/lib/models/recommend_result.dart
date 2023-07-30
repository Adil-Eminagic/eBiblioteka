import 'package:json_annotation/json_annotation.dart';

part 'recommend_result.g.dart';

@JsonSerializable()
class RecommendResult {
  int? id;
  int? bookId;
  int? firstCobookId;
  int? secondCobookId;
  int? thirdCobookId;

  RecommendResult(this.id, this.bookId, this.firstCobookId, this.secondCobookId, this.thirdCobookId);

  factory RecommendResult.fromJson(Map<String, dynamic> json) =>
      _$RecommendResultFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendResultToJson(this);
}


