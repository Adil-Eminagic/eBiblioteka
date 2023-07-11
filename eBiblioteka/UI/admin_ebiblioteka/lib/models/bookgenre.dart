import 'package:admin_ebiblioteka/models/book.dart';
import 'package:admin_ebiblioteka/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookgenre.g.dart';

@JsonSerializable()
class BookGenre {
  int? id;
  int? genreId;
  Genre? genre;
  int? bookId;
  Book? book;

  BookGenre(this.id, this.genre, this.genreId, this.book, this.bookId);

  factory BookGenre.fromJson(Map<String, dynamic> json) =>
      _$BookGenreFromJson(json);

  Map<String, dynamic> toJson() => _$BookGenreToJson(this);
}
