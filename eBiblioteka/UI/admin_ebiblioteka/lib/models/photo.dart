import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  int? id;
  String? data;
  

  Photo(this.id, this.data);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
