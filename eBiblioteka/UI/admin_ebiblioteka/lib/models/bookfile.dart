import 'package:json_annotation/json_annotation.dart';

part 'bookfile.g.dart';

@JsonSerializable()
class BookFile {
  int? id;
  String? name;
  String? data;

  BookFile(
    this.id,
    this.name,
    this.data,
  );

  factory BookFile.fromJson(Map<String, dynamic> json) =>
      _$BookFileFromJson(json);

  Map<String, dynamic> toJson() => _$BookFileToJson(this);
}
