import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/models/data.dart';
import 'package:kahootify_server/models/player_info.dart';
import 'package:kahootify_server/models/player_list_info.dart';
import 'package:kahootify_server/models/server_info.dart';

class LobbyPageBloc extends Bloc<LobbyPageEvent, LobbyPageState> {
  LobbyPageBloc({
    required PlayerInfo playerInfo,
    required ServerInfo serverInfo,
    required this.amIHost,
    required this.serverOutput,
    required this.serverInput,
  }) : super(LobbyPageState(playerInfo: playerInfo, playerList: PlayerListInfo.empty(), serverInfo: serverInfo)) {
    serverOutput.listen((receivedData) => processServerData(receivedData));
  }

  final Stream serverOutput;
  final StreamController serverInput;
  final bool amIHost;

  void processServerData(receivedData) {
    var decodedData = jsonDecode(receivedData);
    var data = Data.fromJson(decodedData);
    switch (data.dataType) {
      case DataType.playerListInfo:
        add(ReceivedNewPlayerList(PlayerListInfo.fromJson(decodedData)));
        break;
      case DataType.gameStarted:
        add(ReceivedGameStart());
        break;
      case DataType.serverInfo:
        add(ReceivedServerInfo(ServerInfo.fromJson(decodedData)));
        break;
      case DataType.returnToLobby:
        add(IDoNotWantToGoToNextScreenAnymore());
        break;
      case DataType.rankingStarted:
        add(IDoNotWantToGoToNextScreenAnymore());
        break;
      case DataType.startGame:
      case DataType.quizQuestion:
      case DataType.answer:
      case DataType.rankingInfo:
      case DataType.lobbyStarted:
      case DataType.playerInfo:
      case DataType.unknown:
      case DataType.error:
      case DataType.rankingStarted:
      case DataType.correctAnswer:
      case DataType.goodbye:
      case DataType.readyToBeKilled:
        print('unsupported data: ${data.dataType}');
        break;
    }
  }

  @override
  Stream<LobbyPageState> mapEventToState(LobbyPageEvent event) async* {
    if (event is IAmReadyButtonPressed) {
      if (amIHost && isGameReadyToStart(state.playerList)) {
        serverInput.add(jsonEncode(Data(DataType.startGame)));
      } else {
        final newReadyState = !state.playerInfo.ready;
        final newPlayerInfo = state.playerInfo.copyWith(ready: newReadyState);
        yield state.copyWith(playerInfo: newPlayerInfo);
        serverInput.add(jsonEncode(newPlayerInfo));
      }
    } else if (event is ReceivedNewPlayerList) {
      final newPlayerList = event.playerList;
      final isStartGameButtonVisible = isGameReadyToStart(newPlayerList);
      yield state.copyWith(playerList: newPlayerList, isStartGameButtonVisible: isStartGameButtonVisible);
    } else if (event is ReceivedGameStart) {
      yield state.copyWith(shouldProceedToGameScreen: true);
    } else if (event is ReceivedServerInfo) {
      yield state.copyWith(serverInfo: event.serverInfo);
    } else if (event is IDoNotWantToGoToNextScreenAnymore) {
      yield state.copyWith(shouldProceedToGameScreen: false);
    }
  }

  bool isGameReadyToStart(PlayerListInfo playerList) => playerList.isEveryoneReady && playerList.players.length > 1;
}

abstract class LobbyPageEvent {}

class IDoNotWantToGoToNextScreenAnymore extends LobbyPageEvent {}

class IAmReadyButtonPressed extends LobbyPageEvent {}

class ReceivedNewPlayerList extends LobbyPageEvent {
  final PlayerListInfo playerList;

  ReceivedNewPlayerList(this.playerList);
}

class ReceivedServerInfo extends LobbyPageEvent {
  final ServerInfo serverInfo;

  ReceivedServerInfo(this.serverInfo);
}

class ReceivedGameStart extends LobbyPageEvent {}

class LobbyPageState {
  final PlayerInfo playerInfo;
  final PlayerListInfo playerList;
  final bool isStartGameButtonVisible;
  final ServerInfo serverInfo;
  final bool shouldProceedToGameScreen;

  LobbyPageState({
    required this.playerInfo,
    required this.playerList,
    this.isStartGameButtonVisible = false,
    required this.serverInfo,
    this.shouldProceedToGameScreen = false,
  });

  LobbyPageState copyWith({
    PlayerInfo? playerInfo,
    PlayerListInfo? playerList,
    bool? isStartGameButtonVisible,
    ServerInfo? serverInfo,
    bool? shouldProceedToGameScreen,
  }) {
    return LobbyPageState(
      playerInfo: playerInfo ?? this.playerInfo,
      playerList: playerList ?? this.playerList,
      isStartGameButtonVisible: isStartGameButtonVisible ?? this.isStartGameButtonVisible,
      serverInfo: serverInfo ?? this.serverInfo,
      shouldProceedToGameScreen: shouldProceedToGameScreen ?? this.shouldProceedToGameScreen,
    );
  }
}
