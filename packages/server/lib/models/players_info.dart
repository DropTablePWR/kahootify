import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';

part 'players_info.g.dart';

@JsonSerializable()
class PlayersInfo extends Data {
  List<PlayerInfo> players;

  PlayersInfo(this.players) : super(DataType.playersInfo);

  factory PlayersInfo.fromJson(Map<String, dynamic> json) => _$PlayersInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayersInfoToJson(this);
}
