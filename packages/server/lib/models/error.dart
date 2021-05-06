import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'error.g.dart';

@JsonSerializable()
class Error extends Data {
  String message;

  Error(this.message) : super(DataType.error);

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
