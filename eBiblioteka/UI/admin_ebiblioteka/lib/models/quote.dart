import '../models/book.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  int? id;
  String? content;
  int? bookId;
  Book? book;

  Quote(this.id, this.content , this.bookId, this.book);

  factory Quote.fromJson(Map<String, dynamic> json) =>
      _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}
