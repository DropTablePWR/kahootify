import 'dart:async';
import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:kahootify_server/server.dart';

class ServerStartBloc extends Bloc<ServerStartEvent, ServerStartState> {
  ServerStartBloc({required this.ip, required this.playerInfo}) : super(InitialServerStartState());
  final String ip;
  final PlayerInfo playerInfo;
  final serverOutput = StreamController();
  final serverInput = StreamController();

  @override
  Stream<ServerStartState> mapEventToState(ServerStartEvent event) async* {
    if (event is InitializeServer) {
      var config = event.config;

      final serverInfo = ServerInfo.init(
        name: config.gameName,
        maxNumberOfPlayers: config.maxNumberOfPlayers,
        category: config.category!,
        answerTimeLimit: config.answerTimeLimit,
        numberOfQuestions: config.numberOfQuestions,
        ip: ip,
      );
      final server = await spawnIsolateServer(serverInfo, serverOutput, playerInfo);
      SendPort sendPort = server.item2;
      serverInput.stream.listen((data) => sendPort.send(data));
      yield ServerStarted(serverOutput: serverOutput.stream, serverInput: serverInput, playerInfo: playerInfo, serverInfo: serverInfo);
    }
  }

  @override
  Future<void> close() {
    serverInput.close();
    serverOutput.close();
    return super.close();
  }
}

class ServerStartState {}

class InitialServerStartState extends ServerStartState {}

class ServerStarted extends ServerStartState {
  final Stream serverOutput;
  final StreamController serverInput;
  final PlayerInfo playerInfo;
  final ServerInfo serverInfo;

  ServerStarted({required this.serverOutput, required this.serverInput, required this.playerInfo, required this.serverInfo});
}

abstract class ServerStartEvent {}

class InitializeServer extends ServerStartEvent {
  final GameConfig config;

  InitializeServer(this.config);
}
