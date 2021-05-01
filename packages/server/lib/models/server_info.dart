enum ServerStatus { lobby, inGame, results }

class ServerInfo {
  final String ip;
  final String name;
  final int maxNumberOfPlayers;
  final int currentNumberOfPlayers;
  final ServerStatus serverStatus;

  ServerInfo({required this.ip, required this.name, required this.maxNumberOfPlayers, required this.currentNumberOfPlayers, required this.serverStatus});

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
        serverStatus = ServerStatus.lobby;
}
