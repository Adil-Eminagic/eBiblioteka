import '../models/author.dart';
import '../models/photo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  int? id;
  String? title;
  String? shortDescription;
  int? publishingYear;
  int? openingCount;
  bool? isActive;
  int? coverPhotoId;
  Photo? coverPhoto;
  int? authorID;
  Author? author;
  int? bookFileId;

  Book(
      this.id,
      this.title,
      this.shortDescription,
      this.publishingYear,
      this.openingCount,
      this.coverPhoto,
      this.coverPhotoId,
      this.author,
      this.authorID,
      this.bookFileId,
      this.isActive);

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
