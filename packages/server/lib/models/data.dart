import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  late DataType dataType;

  Data(this.dataType);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

enum DataType { serverInfo, playerInfo, unknown, error, playerListInfo, gameStarted, startGame }
