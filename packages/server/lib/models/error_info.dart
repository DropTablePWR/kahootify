import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'error_info.g.dart';

@JsonSerializable()
class ErrorInfo extends Data {
  String message;

  ErrorInfo(this.message) : super(DataType.error);

  factory ErrorInfo.fromJson(Map<String, dynamic> json) => _$ErrorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorInfoToJson(this);
}
