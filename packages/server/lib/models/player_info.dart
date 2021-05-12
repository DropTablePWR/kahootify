import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'player_info.g.dart';

@JsonSerializable()
class PlayerInfo extends Data {
  int id;
  String name;
  double score = 0.0;
  bool ready = false;

  PlayerInfo(this.id, this.name) : super(DataType.playerInfo);

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => _$PlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}
