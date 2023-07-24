
import 'package:json_annotation/json_annotation.dart';


part 'gender.g.dart';

@JsonSerializable()
class Gender {
  int? id;
  String? value;

  Gender(this.id, this.value);

  factory Gender.fromJson(Map<String, dynamic> json) => _$GenderFromJson(json);

  Map<String, dynamic> toJson() => _$GenderToJson(this);
}
