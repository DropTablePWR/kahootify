import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'player_info.g.dart';

@JsonSerializable()
class PlayerInfo extends Data {
  int id;
  String name;
  double score;
  bool ready;

  PlayerInfo({required this.id, required this.name, this.score = 0.0, this.ready = false}) : super(DataType.playerInfo);

  PlayerInfo copyWith({int? id, String? name, double? score, bool? ready}) {
    return PlayerInfo(id: id ?? this.id, name: name ?? this.name, score: score ?? this.score, ready: ready ?? this.ready);
  }

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => _$PlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}
