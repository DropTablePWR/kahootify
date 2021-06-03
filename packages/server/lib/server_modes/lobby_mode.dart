import 'package:dartz/dartz.dart';
import 'package:kahootify_server/data/remote_trivia_repository.dart';
import 'package:kahootify_server/models/answer.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/error_info.dart';
import 'package:kahootify_server/models/errors.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/question.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/players/abstract_player.dart';
import 'package:kahootify_server/players/local_player.dart';
import 'package:kahootify_server/server.dart';
import 'package:kahootify_server/server_modes/game_mode.dart';
import 'package:kahootify_server/server_modes/server_mode.dart';

class LobbyMode extends ServerMode {
  late Future<Either<ApiError, List<Question>>> apiResponse;

  LobbyMode(Server server) : super(server) {
    apiResponse = RemoteTriviaRepository.getTrivia(server.serverInfo.numberOfQuestions, server.serverInfo.category);
    print("Server is in Lobby Mode");
    server.sendDataToAll(Data(DataType.lobbyStarted).toJson());
  }

  @override
  void nextMode() {
    apiResponse.then((value) =>
        value.fold((error) => server.sendDataToHost(ErrorInfo(error.reason).toJson()), (questions) => server.serverMode = GameMode(server, questions)));
  }

  @override
  void handlePlayerInfo(PlayerInfo playerInfo, AbstractPlayer player) {
    playerInfo.score = player.playerInfo.score;
    playerInfo.id = player.playerInfo.id;
    player.playerInfo = playerInfo;
    var playerListInfo = server.generatePlayerListInfo();
    server.sendDataToAll(playerListInfo.toJson());
    if (server.serverInfo.autoStart && playerListInfo.isEveryoneReady) {
      nextMode();
    }
  }

  @override
  void handleServerInfo(ServerInfo serverInfo, AbstractPlayer player) {
    if (player is LocalPlayer) {
      server.serverInfo = serverInfo;
      apiResponse = RemoteTriviaRepository.getTrivia(server.serverInfo.numberOfQuestions, server.serverInfo.category);
      server.sendDataToAll(serverInfo.toJson());
    } else {
      player.send(ErrorInfo("No privileges for this operation"));
    }
  }

  @override
  void handleStartGame(AbstractPlayer player) {
    if (player is LocalPlayer) {
      nextMode();
    } else {
      player.send(ErrorInfo("No privileges for this operation"));
    }
  }

  @override
  void handleAnswer(Answer answer, AbstractPlayer player) {
    _sendInvalidOperation(player);
  }

  void _sendInvalidOperation(AbstractPlayer player) {
    player.send(ErrorInfo("Operation invalid during lobby mode").toJson());
  }

  @override
  void returnToLobby() {
    return;
  }
}
