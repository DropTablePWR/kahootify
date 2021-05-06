import 'package:kahootify_server/models/data.dart';

enum ServerStatus { lobby, inGame, results }

class ServerInfo extends Data {
  final String ip;
  final String name;
  final int maxNumberOfPlayers;
  final int currentNumberOfPlayers;
  final ServerStatus serverStatus;

  ServerInfo({required this.ip, required this.name, required this.maxNumberOfPlayers, required this.currentNumberOfPlayers, required this.serverStatus})
      : super(DataType.ServerInfo);

  ServerInfo.init({required this.name, required this.maxNumberOfPlayers})
      : currentNumberOfPlayers = 0,
        serverStatus = ServerStatus.lobby,
        ip = 'localhost',
        super(DataType.ServerInfo);

  copyWith({String? ip, String? name, int? maxNumberOfPlayers, int? currentNumberOfPlayers, ServerStatus? serverStatus}) {
    return ServerInfo(
      ip: ip ?? this.ip,
      name: name ?? this.name,
      maxNumberOfPlayers: maxNumberOfPlayers ?? this.maxNumberOfPlayers,
      currentNumberOfPlayers: currentNumberOfPlayers ?? this.currentNumberOfPlayers,
      serverStatus: serverStatus ?? this.serverStatus,
    );
  }

  ServerInfo.fromJson(String ip, Map<String, dynamic> json)
      : ip = ip,
        name = json['name'],
        maxNumberOfPlayers = json['maxNumberOfPlayers'],
        currentNumberOfPlayers = json['currentNumberOfPlayers'],
        serverStatus = json['serverStatus'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    var result = super.toJson();
    result['name'] = name;
    result['maxNumberOfPlayers'] = maxNumberOfPlayers;
    result['currentNumberOfPlayers'] = currentNumberOfPlayers;
    result['serverStatus'] = serverStatus.toString();
    return result;
  }
}
