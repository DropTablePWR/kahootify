import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';

part 'ranking_info.g.dart';

@JsonSerializable()
class RankingInfo extends Data {
  List<PlayerInfo> players;

  RankingInfo(this.players) : super(DataType.ranking);

  factory RankingInfo.fromJson(Map<String, dynamic> json) => _$RankingInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RankingInfoToJson(this);
}
