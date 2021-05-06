import 'package:json_annotation/json_annotation.dart';
import 'package:kahootify_server/models/data.dart';

part 'server_info.g.dart';

@JsonSerializable()
class ServerInfo extends Data {
  final String ip;
  final String name;
  final int maxNumberOfPlayers;
  int currentNumberOfPlayers;
  final ServerStatus serverStatus;

  ServerInfo({required this.ip, required this.name, required this.maxNumberOfPlayers, required this.currentNumberOfPlayers, required this.serverStatus})
      : super(DataType.serverInfo);

  ServerInfo.init({required this.name, required this.maxNumberOfPlayers})
      : currentNumberOfPlayers = 0,
        serverStatus = ServerStatus.lobby,
        ip = 'localhost',
        super(DataType.serverInfo);

  copyWith({String? ip, String? name, int? maxNumberOfPlayers, int? currentNumberOfPlayers, ServerStatus? serverStatus}) {
    return ServerInfo(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      maxNumberOfPlayers: maxNumberOfPlayers ?? this.maxNumberOfPlayers,
      currentNumberOfPlayers: currentNumberOfPlayers ?? this.currentNumberOfPlayers,
      serverStatus: serverStatus ?? this.serverStatus,
    );
  }

  factory ServerInfo.fromJson(Map<String, dynamic> json) => _$ServerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerInfoToJson(this);
}

enum ServerStatus { lobby, inGame, results }
