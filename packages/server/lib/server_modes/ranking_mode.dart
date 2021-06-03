import 'package:kahootify_server/models/answer.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/server.dart';
import 'package:kahootify_server/server_modes/lobby_mode.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';

import '../const.dart';

class RankingMode extends ServerMode {
  RankingMode(Server server) : super(server) {
    print("Server is in Ranking Mode");
    server.sendDataToAll(Data(DataType.rankingStarted).toJson());
    Future.delayed(Duration(seconds: countdownTime)).then((_) => server.sendDataToAll(server.generateRankingInfo().toJson()));
  }

  @override
  void handleAnswer(Answer answer, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void handlePlayerInfo(PlayerInfo playerInfo, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void handleServerInfo(ServerInfo serverInfo, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void handleStartGame(AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  @override
  void nextMode() {
    server.knownPlayers.forEach((_, player) {
      player.clearPlayerInfo();
    });
    server.serverMode = LobbyMode(server);
  }

  void _sendInvalidOperation(AbstractPlayer player) {
    player.send(ErrorInfo("Operation invalid during ranking mode").toJson());
  }

  @override
  void returnToLobby() {
    nextMode();
  }
}
