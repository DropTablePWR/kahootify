import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';

part 'player_list_info.g.dart';

@JsonSerializable()
class PlayerListInfo extends Data {
  List<PlayerInfo> players;
  bool isEveryoneReady;

  PlayerListInfo(this.players, this.isEveryoneReady) : super(DataType.playerListInfo);

  PlayerListInfo.empty()
      : players = [],
        isEveryoneReady = false,
        super(DataType.playerListInfo);

  factory PlayerListInfo.fromJson(Map<String, dynamic> json) => _$PlayerListInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerListInfoToJson(this);
}
